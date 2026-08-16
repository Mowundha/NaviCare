from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.api.v1 import admin, agent, auth, caretaker, community, dispatch, payment, review, travel, verification
from app.core.config import settings

app = FastAPI(title=settings.PROJECT_NAME)

app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.ALLOWED_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/health")
def health_check():
    return {"status": "ok", "environment": settings.ENVIRONMENT}


app.include_router(auth.router, prefix=f"{settings.API_V1_PREFIX}/auth", tags=["auth"])
app.include_router(verification.router, prefix=f"{settings.API_V1_PREFIX}/verification", tags=["verification"])
app.include_router(travel.router, prefix=f"{settings.API_V1_PREFIX}/travel", tags=["travel"])
app.include_router(dispatch.router, prefix=f"{settings.API_V1_PREFIX}/dispatch", tags=["dispatch"])
app.include_router(payment.router, prefix=f"{settings.API_V1_PREFIX}/payment", tags=["payment"])
app.include_router(agent.router, prefix=f"{settings.API_V1_PREFIX}/agent", tags=["agent"])
app.include_router(community.router, prefix=f"{settings.API_V1_PREFIX}/community", tags=["community"])
app.include_router(caretaker.router, prefix=f"{settings.API_V1_PREFIX}/caretaker", tags=["caretaker"])
app.include_router(review.router, prefix=f"{settings.API_V1_PREFIX}/reviews", tags=["reviews"])
app.include_router(admin.router, prefix=f"{settings.API_V1_PREFIX}/admin", tags=["admin"])
