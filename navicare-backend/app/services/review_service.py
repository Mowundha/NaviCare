"""
Reviews left by users against a Place, Caretaker, or Transit node.
Read side is public (helps a user decide before booking/visiting);
write side requires auth so ratings are tied to a real account.
"""
from app.core.firestore_client import FirestoreRepository
from app.models.enums import ReviewTargetType
from app.models.misc import Review, ReviewCreate

review_repo = FirestoreRepository("Reviews", Review, "review_id")


def create_review(user_id: str, payload: ReviewCreate) -> Review:
    if payload.user_id != user_id:
        raise PermissionError("Cannot submit a review on behalf of another user")

    review = Review(review_id=review_repo.generate_id(), **payload.model_dump())
    return review_repo.create(review)


def list_reviews_for_target(target_id: str, target_type: ReviewTargetType, limit: int = 50) -> list[Review]:
    all_matches = review_repo.find_many_by("target_id", target_id, limit=limit * 2)
    return [r for r in all_matches if r.target_type == target_type][:limit]
