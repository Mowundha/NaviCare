from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.api.v1 import  agent, auth ,community,dispatch,payment, travel, verification
from app.core.config import settings

from app.services.recommendation_engine import UserProfile, Caretaker, match_caretakers, recommend_places

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
# --- Remaining routers register here as each service module is built ---
# from app.api.v1 import dispatch, payment, agent
# app.include_router(dispatch.router, prefix=f"{settings.API_V1_PREFIX}/dispatch", tags=["dispatch"])
# app.include_router(payment.router, prefix=f"{settings.API_V1_PREFIX}/payment", tags=["payment"])
# app.include_router(agent.router, prefix=f"{settings.API_V1_PREFIX}/agent", tags=["agent"])
