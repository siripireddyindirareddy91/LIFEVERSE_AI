import math
import re
from uuid import uuid4

from sqlalchemy import Float, cast, delete, func, or_, select
from sqlalchemy.dialects.postgresql import ARRAY

from app.agentic.common import AgentError, check_consent
from app.agentic.models import KnowledgeSource, RetrievalChunk
from app.config import get_settings
from app.life.models import Memory
from app.life.service import now
from app.models import Profile


def source_model(kind):
    if kind == "memory":
        return Memory
    if kind == "knowledge":
        return KnowledgeSource
    raise AgentError("invalid_source", "Unsupported retrieval source")


def chunk_key(kind):
    return RetrievalChunk.memory_id if kind == "memory" else RetrievalChunk.source_id


def active_source(model):
    return (model.allow_ai.is_(True), or_(model.expires_at.is_(None), model.expires_at > now()))


def split_chunks(title, content):
    text = title + "\n" + content
    return [text[start : start + 1000] for start in range(0, len(text), 900)]


def invalidate_source(db, user_id, kind, source):
    source.revision = uuid4()
    db.execute(
        delete(RetrievalChunk).where(
            RetrievalChunk.user_id == user_id, chunk_key(kind) == source.id
        )
    )


def ensure_chunks(db, user_id, kind, source):
    if not source.allow_ai:
        db.execute(
            delete(RetrievalChunk).where(
                RetrievalChunk.user_id == user_id, chunk_key(kind) == source.id
            )
        )
        return []
    texts = split_chunks(source.title, source.content)
    rows = list(
        db.scalars(
            select(RetrievalChunk)
            .where(RetrievalChunk.user_id == user_id, chunk_key(kind) == source.id)
            .order_by(RetrievalChunk.ordinal)
        )
    )
    if len(rows) == len(texts) and all(row.source_revision == source.revision for row in rows):
        return rows
    db.execute(
        delete(RetrievalChunk).where(
            RetrievalChunk.user_id == user_id, chunk_key(kind) == source.id
        )
    )
    rows = [
        RetrievalChunk(
            user_id=user_id,
            memory_id=source.id if kind == "memory" else None,
            source_id=source.id if kind == "knowledge" else None,
            source_revision=source.revision,
            ordinal=index,
            content=content,
        )
        for index, content in enumerate(texts)
    ]
    db.add_all(rows)
    db.flush()
    return rows


def source_snapshot(db, user_id, kind, source_id, lock=False):
    model = source_model(kind)
    query = select(model).where(
        model.id == source_id, model.user_id == user_id, *active_source(model)
    )
    if lock:
        query = query.with_for_update()
    source = db.scalar(query)
    if source is None:
        raise AgentError(
            "stale_source", "A reference source was deleted, expired or unshared. Make a new plan."
        )
    return source


def check_vectors(vectors, count, dimensions):
    if len(vectors) != count:
        raise AgentError("invalid_embeddings", "The embedding provider returned an invalid batch.")
    for vector in vectors:
        if (
            len(vector) != dimensions
            or any(
                isinstance(value, bool)
                or not isinstance(value, (float, int))
                or not math.isfinite(value)
                for value in vector
            )
            or sum(value * value for value in vector) == 0
        ):
            raise AgentError(
                "invalid_embeddings", "The embedding provider returned an invalid vector."
            )


def index_source(db, user_id, kind, source_id, embedder):
    # Lock consent before source rows: revocation after this transaction removes
    # the completed cache, rather than racing an in-flight indexing write.
    db.scalar(select(Profile).where(Profile.user_id == user_id).with_for_update())
    check_consent(db, user_id, [kind])
    model = source_model(kind)
    source = db.scalar(
        select(model).where(model.id == source_id, model.user_id == user_id).with_for_update()
    )
    if source is None:
        raise AgentError("not_found", "Source not found")
    source_snapshot(db, user_id, kind, source_id)
    if embedder is None:
        raise AgentError(
            "embeddings_unavailable",
            "An embedding model is not configured. Keyword retrieval remains available.",
        )
    chunks = ensure_chunks(db, user_id, kind, source)
    if len(chunks) > 40:
        raise AgentError("source_too_large", "This source exceeds the indexing budget.")
    pending = [
        chunk
        for chunk in chunks
        if chunk.embedding is None
        or chunk.embedding_model != embedder.model
        or len(chunk.embedding) != embedder.dimensions
    ]
    vectors = embedder.embed([chunk.content for chunk in pending]) if pending else []
    check_vectors(vectors, len(pending), embedder.dimensions)
    for chunk, vector in zip(pending, vectors, strict=True):
        chunk.embedding = vector
        chunk.embedding_model = embedder.model
        chunk.indexed_at = now()
    db.flush()
    return {
        "indexed_chunks": len(chunks),
        "model": embedder.model,
        "dimensions": embedder.dimensions,
        "cached": not pending,
    }


def knowledge_read(db, user_id, source):
    settings = get_settings()
    indexed = db.scalar(
        select(func.count())
        .select_from(RetrievalChunk)
        .where(
            RetrievalChunk.user_id == user_id,
            RetrievalChunk.source_id == source.id,
            RetrievalChunk.source_revision == source.revision,
            RetrievalChunk.embedding.is_not(None),
            RetrievalChunk.embedding_model == settings.ai_embedding_model,
            func.array_length(RetrievalChunk.embedding, 1) == settings.ai_embedding_dimensions,
        )
    )
    return {
        "id": source.id,
        "title": source.title,
        "content": source.content,
        "allow_ai": source.allow_ai,
        "expires_at": source.expires_at,
        "revision": source.revision,
        "created_at": source.created_at,
        "chunk_count": len(split_chunks(source.title, source.content)),
        "indexed_chunks": indexed,
    }


def search(db, user_id, kind, query_text, limit=3, embedder=None):
    check_consent(db, user_id, [kind], lock=True)
    model = source_model(kind)
    terms = re.findall(r"[\w]{3,}", query_text, re.UNICODE)[:12]
    lexical_ids = []
    if terms:
        query = func.websearch_to_tsquery("english", " OR ".join(terms))
        parent_doc = func.to_tsvector("english", model.title + " " + model.content)
        parents = db.scalars(
            select(model)
            .where(model.user_id == user_id, *active_source(model), parent_doc.op("@@")(query))
            .order_by(func.ts_rank(parent_doc, query).desc(), model.id)
            .limit(20)
            .with_for_update()
        ).all()
        for source in parents:
            ensure_chunks(db, user_id, kind, source)
        document = func.to_tsvector("english", RetrievalChunk.content)
        lexical_ids = list(
            db.scalars(
                select(RetrievalChunk.id)
                .join(model, chunk_key(kind) == model.id)
                .where(
                    RetrievalChunk.user_id == user_id,
                    model.user_id == user_id,
                    *active_source(model),
                    RetrievalChunk.source_revision == model.revision,
                    document.op("@@")(query),
                )
                .order_by(func.ts_rank(document, query).desc(), RetrievalChunk.id)
                .limit(20)
            )
        )
    semantic_ids = []
    warning = None
    if embedder is not None:
        try:
            vectors = embedder.embed([query_text])
            check_vectors(vectors, 1, embedder.dimensions)
            check_consent(db, user_id, [kind])
            candidates = (
                select(RetrievalChunk.id, RetrievalChunk.embedding)
                .join(model, chunk_key(kind) == model.id)
                .where(
                    RetrievalChunk.user_id == user_id,
                    model.user_id == user_id,
                    *active_source(model),
                    RetrievalChunk.source_revision == model.revision,
                    RetrievalChunk.embedding.is_not(None),
                    RetrievalChunk.embedding_model == embedder.model,
                    func.array_length(RetrievalChunk.embedding, 1) == embedder.dimensions,
                )
                .order_by(RetrievalChunk.created_at.desc(), RetrievalChunk.id)
                .limit(get_settings().retrieval_candidate_limit)
                .subquery()
            )
            score = func.lifeverse_cosine(candidates.c.embedding, cast(vectors[0], ARRAY(Float)))
            semantic_ids = list(
                db.scalars(
                    select(candidates.c.id)
                    .where(score > 0.25)
                    .order_by(score.desc(), candidates.c.id)
                    .limit(20)
                )
            )
        except AgentError as error:
            if error.code == "consent_required":
                raise
            warning = "Semantic retrieval was unavailable; keyword retrieval was used."
    mode = "hybrid" if semantic_ids and lexical_ids else "semantic" if semantic_ids else "keyword"
    scores = {}
    for ranked in (lexical_ids, semantic_ids):
        for index, chunk_id in enumerate(ranked):
            scores[chunk_id] = scores.get(chunk_id, 0) + 1 / (60 + index + 1)
    results = []
    seen = set()
    for chunk_id in sorted(scores, key=lambda key: (-scores[key], str(key))):
        chunk = db.get(RetrievalChunk, chunk_id)
        source_id = chunk.memory_id if kind == "memory" else chunk.source_id
        if source_id in seen:
            continue
        source = source_snapshot(db, user_id, kind, source_id)
        if source.revision != chunk.source_revision:
            continue
        seen.add(source_id)
        results.append(
            {
                "kind": kind,
                "source_id": str(source.id),
                "revision": str(source.revision),
                "chunk_id": str(chunk.id),
                "title": source.title,
                "excerpt": chunk.content[:1200],
                "mode": mode,
            }
        )
        if len(results) >= limit:
            break
    return {"sources": results, "mode": mode, "warning": warning}
