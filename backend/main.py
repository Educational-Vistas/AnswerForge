from __future__ import annotations

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.core.config import get_settings
from app.api.assessments import router as assessments_router
from app.api.other import (
    router_categories,
    router_evidence,
    router_answers,
    router_risks,
)

settings = get_settings()

app = FastAPI(
    title=settings.app_name,
    version=settings.app_version,
    description="AI-assisted cybersecurity questionnaire and compliance response platform",
)

# CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.cors_origin_list,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Routers
app.include_router(assessments_router)
app.include_router(router_categories)
app.include_router(router_evidence)
app.include_router(router_answers)
app.include_router(router_risks)


@app.get("/api/health")
def health_check():
    return {
        "status": "healthy",
        "app": settings.app_name,
        "version": settings.app_version,
    }


@app.get("/api/dashboard")
def dashboard(db=Depends(lambda: None)):
    """Return dashboard summary stats."""
    from app.core.database import SessionLocal
    from app.models import (
        CyberAssessment,
        CyberResponse,
        CyberEvidence,
        CyberRisk,
    )

    db = SessionLocal()
    try:
        total_assessments = db.query(CyberAssessment).count()
        total_responses = db.query(CyberResponse).count()
        responses_need_review = (
            db.query(CyberResponse)
            .filter(CyberResponse.status == "Needs Review")
            .count()
        )
        total_evidence = db.query(CyberEvidence).count()
        open_risks = (
            db.query(CyberRisk)
            .filter(CyberRisk.status.in_(["Open", "In Progress"]))
            .count()
        )

        return {
            "total_assessments": total_assessments,
            "total_responses": total_responses,
            "responses_need_review": responses_need_review,
            "total_evidence": total_evidence,
            "open_risks": open_risks,
        }
    finally:
        db.close()


if __name__ == "__main__":
    import uvicorn

    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
