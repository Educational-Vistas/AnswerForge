from __future__ import annotations

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.models import CyberAnswerLibrary, CyberEvidence, CyberRisk
from app.schemas import AnswerLibraryResponse, EvidenceResponse, RiskResponse

router_categories = APIRouter(prefix="/api/categories", tags=["categories"])
router_evidence = APIRouter(prefix="/api/evidence", tags=["evidence"])
router_answers = APIRouter(prefix="/api/answer-library", tags=["answer-library"])
router_risks = APIRouter(prefix="/api/risks", tags=["risks"])


# Categories
@router_categories.get("/{category_id}/questions")
def get_category_questions(category_id: int, db: Session = Depends(get_db)):
    from app.models import CyberCategory, CyberQuestion

    category = (
        db.query(CyberCategory).filter(CyberCategory.category_id == category_id).first()
    )
    if not category:
        raise HTTPException(status_code=404, detail="Category not found")

    questions = (
        db.query(CyberQuestion)
        .filter(CyberQuestion.category_id == category_id)
        .order_by(CyberQuestion.display_order)
        .all()
    )

    return {
        "category_id": category_id,
        "category_name": category.category_name,
        "question_count": len(questions),
        "questions": questions,
    }


# Evidence Vault
@router_evidence.get("", response_model=list[EvidenceResponse])
def list_evidence(
    confidentiality: str | None = None,
    db: Session = Depends(get_db),
):
    query = db.query(CyberEvidence)
    if confidentiality:
        query = query.filter(CyberEvidence.confidentiality_level == confidentiality)
    return query.all()


@router_evidence.get("/{evidence_id}", response_model=EvidenceResponse)
def get_evidence(evidence_id: int, db: Session = Depends(get_db)):
    evidence = (
        db.query(CyberEvidence).filter(CyberEvidence.evidence_id == evidence_id).first()
    )
    if not evidence:
        raise HTTPException(status_code=404, detail="Evidence not found")
    return evidence


# Answer Library
@router_answers.get("", response_model=list[AnswerLibraryResponse])
def list_answer_templates(
    topic: str | None = None,
    status: str | None = None,
    db: Session = Depends(get_db),
):
    query = db.query(CyberAnswerLibrary)
    if topic:
        query = query.filter(CyberAnswerLibrary.topic.ilike(f"%{topic}%"))
    if status:
        query = query.filter(CyberAnswerLibrary.status == status)
    return query.all()


@router_answers.get("/{template_id}", response_model=AnswerLibraryResponse)
def get_answer_template(template_id: int, db: Session = Depends(get_db)):
    template = (
        db.query(CyberAnswerLibrary)
        .filter(CyberAnswerLibrary.answer_template_id == template_id)
        .first()
    )
    if not template:
        raise HTTPException(status_code=404, detail="Answer template not found")
    return template


# Risks
@router_risks.get("", response_model=list[RiskResponse])
def list_risks(
    severity: str | None = None,
    status: str | None = None,
    db: Session = Depends(get_db),
):
    query = db.query(CyberRisk)
    if severity:
        query = query.filter(CyberRisk.severity == severity)
    if status:
        query = query.filter(CyberRisk.status == status)
    return query.order_by(CyberRisk.risk_score.desc()).all()


@router_risks.get("/{risk_id}", response_model=RiskResponse)
def get_risk(risk_id: int, db: Session = Depends(get_db)):
    risk = db.query(CyberRisk).filter(CyberRisk.risk_id == risk_id).first()
    if not risk:
        raise HTTPException(status_code=404, detail="Risk not found")
    return risk
