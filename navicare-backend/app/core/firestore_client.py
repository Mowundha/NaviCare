"""
Firestore client singleton + a small generic repository helper so every
service module doesn't hand-roll its own get/set/query boilerplate.
"""
from __future__ import annotations

import uuid
from typing import Any, Generic, TypeVar

from google.cloud import firestore
from pydantic import BaseModel

from app.core.config import settings

_client: firestore.Client | None = None


def get_firestore_client() -> firestore.Client:
    """Returns a lazily-initialized Firestore client (reused across requests)."""
    global _client
    if _client is None:
        _client = firestore.Client(
            project=settings.GCP_PROJECT_ID,
            database=settings.FIRESTORE_DATABASE,
        )
    return _client


ModelT = TypeVar("ModelT", bound=BaseModel)


class FirestoreRepository(Generic[ModelT]):
    """
    Thin generic wrapper around a Firestore collection, typed to a Pydantic
    model. Keeps document IDs consistent with the `<collection>_id` UUID
    convention used across the NaviCare schema (Users.user_id,
    Caretakers.caretaker_id, etc).
    """

    def __init__(self, collection_name: str, model: type[ModelT], id_field: str):
        self.collection_name = collection_name
        self.model = model
        self.id_field = id_field
        self._db: firestore.Client | None = None  # connected lazily, on first real use

    @property
    def db(self) -> firestore.Client:
        if self._db is None:
            self._db = get_firestore_client()
        return self._db

    @property
    def collection(self):
        return self.db.collection(self.collection_name)

    def generate_id(self) -> str:
        return str(uuid.uuid4())

    def create(self, data: ModelT) -> ModelT:
        doc_id = getattr(data, self.id_field)
        self.collection.document(doc_id).set(data.model_dump())
        return data

    def get(self, doc_id: str) -> ModelT | None:
        snap = self.collection.document(doc_id).get()
        if not snap.exists:
            return None
        return self.model.model_validate(snap.to_dict())

    def update(self, doc_id: str, fields: dict[str, Any]) -> None:
        self.collection.document(doc_id).update(fields)

    def delete(self, doc_id: str) -> None:
        self.collection.document(doc_id).delete()

    def find_one_by(self, field: str, value: Any) -> ModelT | None:
        query = self.collection.where(field, "==", value).limit(1).stream()
        for doc in query:
            return self.model.model_validate(doc.to_dict())
        return None

    def find_many_by(self, field: str, value: Any, limit: int = 50) -> list[ModelT]:
        query = self.collection.where(field, "==", value).limit(limit).stream()
        return [self.model.model_validate(doc.to_dict()) for doc in query]

    def list_all(self, limit: int = 100) -> list[ModelT]:
        query = self.collection.limit(limit).stream()
        return [self.model.model_validate(doc.to_dict()) for doc in query]
