from uuid import UUID

from fastapi import HTTPException
from pydantic import ValidationError
from sqlalchemy import select
from sqlalchemy.exc import SQLAlchemyError

from app.agentic.common import AgentError, check_consent, digest, event
from app.agentic.models import AgentAction, AgentDecision, AgentJob
from app.agentic.rag import source_snapshot
from app.agentic.tools import actions_digest, current_snapshot, execute
from app.life.service import now


def expire_run(db, run):
    expired = (run.status == "awaiting_approval" and run.review_expires_at <= now()) or (
        run.status == "queued" and run.queue_expires_at <= now()
    )
    if not expired:
        return
    run.status = "expired"
    run.finished_at = now()
    run.error = "This request or approval preview expired. Start a new plan."
    for action in db.scalars(
        select(AgentAction).where(AgentAction.user_id == run.user_id, AgentAction.run_id == run.id)
    ):
        action.status = "blocked"
    job = db.scalar(
        select(AgentJob).where(AgentJob.user_id == run.user_id, AgentJob.run_id == run.id)
    )
    if job:
        job.status = "done"
        job.lease_until = None
    event(db, run, "system", run.error, status="failed")


def decide(db, run, payload):
    payload_hash = digest(payload.model_dump(mode="json"))
    previous = db.scalar(
        select(AgentDecision).where(
            AgentDecision.user_id == run.user_id, AgentDecision.request_id == payload.request_id
        )
    )
    if previous:
        if previous.run_id != run.id or previous.payload_hash != payload_hash:
            raise HTTPException(409, "That decision identifier was used for a different review.")
        return
    expire_run(db, run)
    if run.status != "awaiting_approval":
        raise HTTPException(409, "This run is not awaiting approval.")
    actions = list(
        db.scalars(
            select(AgentAction)
            .where(AgentAction.user_id == run.user_id, AgentAction.run_id == run.id)
            .order_by(AgentAction.position)
            .with_for_update()
        )
    )
    if (
        str(run.review_nonce) != str(payload.nonce)
        or run.approval_digest != payload.digest
        or actions_digest(actions) != payload.digest
    ):
        raise HTTPException(409, "The preview changed. Refresh and review it again.")
    selected = set(payload.action_ids)
    by_id = {action.id: action for action in actions}
    if not selected.issubset(by_id):
        raise HTTPException(422, "Select only actions in this plan.")
    if any(not set(by_id[key].dependencies).issubset(selected) for key in selected):
        raise HTTPException(422, "Select the prerequisite goal proposals before dependent tasks.")
    decision = AgentDecision(
        user_id=run.user_id,
        run_id=run.id,
        request_id=payload.request_id,
        payload_hash=payload_hash,
        decision=payload.decision,
        selected_ids=payload.action_ids,
        outcome="rejected",
    )
    db.add(decision)
    if payload.decision == "reject":
        for action in actions:
            action.status = "rejected"
        run.status = "rejected"
        run.finished_at = now()
        run.summary = "You rejected the proposals. No life records changed."
        event(db, run, "approval", "User rejected all proposals.")
        return
    try:
        # All selected writes and their applied metadata form one transaction.
        # A failed check/write rolls the entire batch back to this savepoint.
        with db.begin_nested():
            if run.origin == "workflow":
                from app.automation.models import Workflow, WorkflowRun

                linked = db.scalar(
                    select(WorkflowRun)
                    .join(
                        Workflow,
                        (Workflow.user_id == WorkflowRun.user_id)
                        & (Workflow.id == WorkflowRun.workflow_id),
                    )
                    .where(
                        WorkflowRun.user_id == run.user_id,
                        WorkflowRun.proposal_run_id == run.id,
                        Workflow.enabled.is_(True),
                        Workflow.revision == WorkflowRun.revision,
                        WorkflowRun.status == "waiting_approval",
                    )
                )
                if linked is None:
                    raise AgentError(
                        "workflow_stopped",
                        "The owning workflow stopped or changed. No changes were applied.",
                    )
            else:
                check_consent(db, run.user_id, run.scopes, lock=True)
            for source in run.sources:
                current = source_snapshot(
                    db, run.user_id, source["kind"], UUID(source["source_id"]), lock=True
                )
                if str(current.revision) != source["revision"]:
                    raise AgentError("stale_source", "A reference source changed. Make a new plan.")
            for action in actions:
                if action.id in selected and action.before is not None:
                    if digest(current_snapshot(db, run.user_id, action)) != action.expected_hash:
                        raise AgentError(
                            "stale_target",
                            "A target record changed after this preview. Make a new plan.",
                        )
            results = {}
            for action in actions:
                if action.id in selected:
                    results[action.id] = execute(db, run.user_id, action)
            for action in actions:
                action.status = "applied" if action.id in selected else "rejected"
                if action.id in results:
                    action.result = results[action.id]
            db.flush()
        decision.outcome = "applied"
        run.status = "completed"
        run.finished_at = now()
        run.summary = (
            f"Applied {len(selected)} approved changes. Unselected proposals were not applied."
        )
        event(
            db,
            run,
            "approval",
            "User approved the exact preview.",
            details={"actions": len(selected)},
        )
        for action in actions:
            if action.id in selected:
                event(
                    db,
                    run,
                    "execution",
                    action.label,
                    agent=action.agent,
                    tool=action.tool,
                    details=action.result,
                )
    except (AgentError, HTTPException, ValidationError, SQLAlchemyError) as error:
        decision.outcome = "blocked"
        run.status = "stale"
        run.finished_at = now()
        run.error = (
            error.message
            if isinstance(error, AgentError)
            else "Records or constraints changed. No selected actions were applied; make a new plan."
        )
        for action in actions:
            action.status = "blocked"
            action.result = None
        event(db, run, "execution", run.error, status="failed")
