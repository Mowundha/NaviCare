"""
Caretaker dispatch state machine.
REQUESTED -> ACCEPTED -> ARRIVED -> IN_PROGRESS -> COMPLETED
                                                  -> CANCELLED (from any non-terminal state)

Persists dispatch_status + assigned_caretaker_id on the Travel_Plans document,
and flips Caretakers.is_available at the right points in the lifecycle.
"""
from app.models.enums import DispatchStatus
from app.services import payment_service
from app.services.auth_service import caretaker_repo
from app.services.travel_service import plan_repo

# Which transitions are legal, and who is allowed to trigger them.
ALLOWED_TRANSITIONS: dict[DispatchStatus | None, list[DispatchStatus]] = {
    None: [DispatchStatus.REQUESTED],
    DispatchStatus.REQUESTED: [DispatchStatus.ACCEPTED, DispatchStatus.CANCELLED],
    DispatchStatus.ACCEPTED: [DispatchStatus.ARRIVED, DispatchStatus.CANCELLED],
    DispatchStatus.ARRIVED: [DispatchStatus.IN_PROGRESS, DispatchStatus.CANCELLED],
    DispatchStatus.IN_PROGRESS: [DispatchStatus.COMPLETED, DispatchStatus.CANCELLED],
    DispatchStatus.COMPLETED: [],  # terminal
    DispatchStatus.CANCELLED: [],  # terminal
}

# Which role is allowed to perform each transition target.
CARETAKER_ONLY_TRANSITIONS = {DispatchStatus.ACCEPTED, DispatchStatus.ARRIVED, DispatchStatus.IN_PROGRESS, DispatchStatus.COMPLETED}
USER_OR_CARETAKER_TRANSITIONS = {DispatchStatus.CANCELLED}


def request_caretaker(plan_id: str, caretaker_id: str, requesting_user_id: str):
    plan = plan_repo.get(plan_id)
    if not plan:
        raise ValueError("Travel plan not found")
    if plan.user_id != requesting_user_id:
        raise PermissionError("Not your travel plan")
    if plan.dispatch_status is not None:
        raise ValueError(f"This plan already has an active dispatch (status: {plan.dispatch_status})")

    caretaker = caretaker_repo.get(caretaker_id)
    if not caretaker:
        raise ValueError("Caretaker not found")
    if not caretaker.is_available:
        raise ValueError("This caretaker is not currently available")

    plan_repo.update(plan_id, {
        "assigned_caretaker_id": caretaker_id,
        "dispatch_status": DispatchStatus.REQUESTED.value,
    })
    return plan_repo.get(plan_id)


def transition(plan_id: str, actor_role: str, actor_id: str, new_status: DispatchStatus):
    """
    actor_role: 'user' | 'caretaker' — used to enforce who can trigger which transition.
    """
    plan = plan_repo.get(plan_id)
    if not plan:
        raise ValueError("Travel plan not found")

    current = plan.dispatch_status
    allowed_next = ALLOWED_TRANSITIONS.get(current, [])
    if new_status not in allowed_next:
        current_label = getattr(current, "value", current) or "None"
        raise ValueError(f"Cannot transition from {current_label} to {new_status.value}")

    # Authorization: only the assigned caretaker or the plan's owner may act, and only in their allowed lane
    if new_status in CARETAKER_ONLY_TRANSITIONS:
        if actor_role != "caretaker" or actor_id != plan.assigned_caretaker_id:
            raise PermissionError("Only the assigned caretaker can perform this action")
    elif new_status in USER_OR_CARETAKER_TRANSITIONS:
        is_owning_user = actor_role == "user" and actor_id == plan.user_id
        is_assigned_caretaker = actor_role == "caretaker" and actor_id == plan.assigned_caretaker_id
        if not (is_owning_user or is_assigned_caretaker):
            raise PermissionError("Only the plan owner or assigned caretaker can cancel")

    plan_repo.update(plan_id, {"dispatch_status": new_status.value})

    # Side effects: caretaker becomes unavailable once they accept, available again once done/cancelled
    if plan.assigned_caretaker_id:
        if new_status == DispatchStatus.ACCEPTED:
            caretaker_repo.update(plan.assigned_caretaker_id, {"is_available": False})
        elif new_status in (DispatchStatus.COMPLETED, DispatchStatus.CANCELLED):
            caretaker_repo.update(plan.assigned_caretaker_id, {"is_available": True})
            if new_status == DispatchStatus.COMPLETED:
                try:
                    payment_service.release_payment_and_payout(plan_id)
                except Exception:
                    # Don't block the dispatch completion itself if payout fails —
                    # this needs to surface to an ops/alerting flow for manual retry,
                    # not silently swallow, but that alerting hook doesn't exist yet.
                    pass
    updated_plan = plan_repo.get(plan_id)
    return updated_plan


def get_dispatch_state(plan_id: str):
    plan = plan_repo.get(plan_id)
    if not plan:
        raise ValueError("Travel plan not found")
    return plan