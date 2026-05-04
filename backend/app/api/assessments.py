from __future__ import annotations

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session, joinedload

from app.core.database import get_db
from app.models import CyberAssessment, CyberCategory, CyberQuestion, CyberResponse
from app.schemas import (
    AssessmentDetail,
    AssessmentResponse,
    CategoryWithQuestions,
    ResponseWithQuestion,
)

router = APIRouter(prefix="/api/assessments", tags=["assessments"])


@router.get("", response_model=list[AssessmentResponse])
def list_assessments(db: Session = Depends(get_db)):
    assessments = db.query(CyberAssessment).all()
    return assessments


@router.get("/{assessment_id}", response_model=AssessmentDetail)
def get_assessment(assessment_id: int, db: Session = Depends(get_db)):
    assessment = (
        db.query(CyberAssessment)
        .options(
            joinedload(CyberAssessment.categories).joinedload(CyberCategory.questions),
            joinedload(CyberAssessment.responses),
        )
        .filter(CyberAssessment.assessment_id == assessment_id)
        .first()
    )
    if not assessment:
        raise HTTPException(status_code=404, detail="Assessment not found")
    return assessment


@router.get("/{assessment_id}/categories", response_model=list[CategoryWithQuestions])
def get_assessment_categories(assessment_id: int, db: Session = Depends(get_db)):
    categories = (
        db.query(CyberCategory)
        .options(joinedload(CyberCategory.questions))
        .filter(CyberCategory.assessment_id == assessment_id)
        .order_by(CyberCategory.display_order)
        .all()
    )
    return categories


@router.get("/{assessment_id}/responses", response_model=list[ResponseWithQuestion])
def get_assessment_responses(assessment_id: int, db: Session = Depends(get_db)):
    responses = (
        db.query(CyberResponse)
        .options(joinedload(CyberResponse.question))
        .filter(CyberResponse.assessment_id == assessment_id)
        .all()
    )
    return responses


@router.get("/{assessment_id}/search")
def search_assessment(
    assessment_id: int,
    q: str = "",
    db: Session = Depends(get_db),
):
    """Search questions and responses within an assessment."""
    if not q:
        return {"results": []}

    search_term = f"%{q}%"

    questions = (
        db.query(CyberQuestion)
        .join(CyberCategory)
        .filter(
            CyberCategory.assessment_id == assessment_id,
            (
                CyberQuestion.question_text.ilike(search_term)
                | CyberQuestion.control_id.ilike(search_term)
            ),
        )
        .all()
    )

    responses = (
        db.query(CyberResponse)
        .filter(
            CyberResponse.assessment_id == assessment_id,
            (
                CyberResponse.vendor_answer.ilike(search_term)
                | CyberResponse.additional_information.ilike(search_term)
            ),
        )
        .all()
    )

    return {
        "query": q,
        "question_count": len(questions),
        "response_count": len(responses),
        "questions": [
            {
                "question_id": q.question_id,
                "control_id": q.control_id,
                "question_text": q.question_text,
            }
            for q in questions
        ],
        "responses": [
            {
                "response_id": r.response_id,
                "vendor_answer": r.vendor_answer,
                "status": r.status,
            }
            for r in responses
        ],
    }
