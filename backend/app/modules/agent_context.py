from sqlalchemy import select, or_
from app.modules.models import ModuleRecord, VaultFile
from app.modules.service import module_kinds
from app.life.service import now


def knowledge_connections(db, user, query):
    from app.agentic.common import check_consent
    from app.agentic.models import KnowledgeSource
    from app.modules.models import KnowledgeLink

    check_consent(db, user.id, ["knowledge"])
    statement = select(KnowledgeSource).where(
        KnowledgeSource.user_id == user.id,
        KnowledgeSource.allow_ai.is_(True),
        or_(KnowledgeSource.expires_at.is_(None), KnowledgeSource.expires_at > now()),
    )
    if query:
        escaped = query.replace("\\", "\\\\").replace("%", "\\%").replace("_", "\\_")
        statement = statement.where(KnowledgeSource.title.ilike("%" + escaped + "%", escape="\\"))
    nodes = list(db.scalars(statement.order_by(KnowledgeSource.created_at.desc()).limit(10)))
    ids = [n.id for n in nodes]
    links = db.scalars(
        select(KnowledgeLink)
        .where(
            KnowledgeLink.user_id == user.id,
            KnowledgeLink.source_id.in_(ids),
            KnowledgeLink.target_id.in_(ids),
        )
        .order_by(KnowledgeLink.created_at)
        .limit(50)
    )
    return {
        "items": [{"id": str(n.id), "title": n.title} for n in nodes],
        "connections": [
            {"source_id": str(e.source_id), "target_id": str(e.target_id), "label": e.label}
            for e in links
        ],
        "sources": [
            {
                "kind": "knowledge",
                "source_id": str(n.id),
                "revision": str(n.revision),
                "title": n.title,
                "excerpt": n.title,
                "mode": "shared graph node",
            }
            for n in nodes
        ],
        "boundary": "Only the newest ten shared matching nodes and at most fifty connections among them.",
    }


def context(db, user, module, query):
    sources = []
    if module == "vault":
        statement = select(VaultFile).where(
            VaultFile.user_id == user.id,
            VaultFile.allow_ai.is_(True),
            or_(VaultFile.expires_at.is_(None), VaultFile.expires_at > now()),
        )
        if query:
            statement = statement.where(
                VaultFile.title.ilike(
                    "%" + query.replace("%", "\\%").replace("_", "\\_") + "%", escape="\\"
                )
            )
        rows = list(db.scalars(statement.order_by(VaultFile.created_at.desc()).limit(8)))
        return {
            "sources": [
                {
                    "kind": "vault",
                    "source_id": str(r.id),
                    "revision": str(r.revision),
                    "title": r.title,
                    "excerpt": r.category + " · " + r.filename,
                    "mode": "shared metadata",
                }
                for r in rows
            ],
            "items": [
                {
                    "id": str(r.id),
                    "title": r.title,
                    "category": r.category,
                    "filename": r.filename,
                    "expires_at": str(r.expires_at) if r.expires_at else None,
                }
                for r in rows
            ],
            "boundary": "Metadata only. File bytes, OCR and document contents are not available.",
        }
    statement = select(ModuleRecord).where(
        ModuleRecord.user_id == user.id,
        ModuleRecord.kind.in_(module_kinds(module)),
        ModuleRecord.allow_ai.is_(True),
    )
    if query:
        escaped = query.replace("\\", "\\\\").replace("%", "\\%").replace("_", "\\_")
        statement = statement.where(ModuleRecord.title.ilike("%" + escaped + "%", escape="\\"))
    items = []
    for row in db.scalars(
        statement.order_by(ModuleRecord.created_at.desc(), ModuleRecord.id).limit(8)
    ):
        data = {
            key: (value[:700] if isinstance(value, str) else value)
            for key, value in row.data.items()
        }
        items.append({"id": str(row.id), "kind": row.kind, "data": data})
        sources.append(
            {
                "kind": module,
                "source_id": str(row.id),
                "revision": str(row.revision),
                "title": row.title,
                "excerpt": str(data)[:300],
                "mode": "shared record",
            }
        )
    # Keep complete JSON below the runtime's tool budget without cutting JSON strings.
    import json

    while len(json.dumps(items, default=str)) > 6000:
        items.pop()
        sources.pop()
    return {
        "items": items,
        "sources": sources,
        "boundary": "Only explicitly shared records, newest eight at most. This is not an account-wide report. Read-only; no transactions, bookings or medical decisions.",
    }
