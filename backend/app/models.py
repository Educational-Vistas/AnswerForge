from __future__ import annotations

from datetime import date, datetime
from typing import List

from sqlalchemy import (
    BigInteger,
    Boolean,
    Date,
    DateTime,
    ForeignKey,
    Integer,
    String,
    Text,
)
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.core.database import Base


class CyberAssessment(Base):
    __tablename__ = "cyber_assessments"

    assessment_id: Mapped[int] = mapped_column(
        BigInteger, primary_key=True, autoincrement=True
    )
    assessment_key: Mapped[str | None] = mapped_column(String(100), unique=True)
    assessment_name: Mapped[str | None] = mapped_column(String(255))
    customer_name: Mapped[str | None] = mapped_column(String(255))
    source_questionnaire: Mapped[str | None] = mapped_column(String(255))
    assessment_date: Mapped[date | None] = mapped_column(Date)
    review_date: Mapped[date | None] = mapped_column(Date)
    status: Mapped[str | None] = mapped_column(String(50))
    created_at: Mapped[datetime | None] = mapped_column(DateTime)
    updated_at: Mapped[datetime | None] = mapped_column(DateTime)

    categories: Mapped[List["CyberCategory"]] = relationship(
        back_populates="assessment"
    )
    headers: Mapped[List["CyberHeader"]] = relationship(back_populates="assessment")
    responses: Mapped[List["CyberResponse"]] = relationship(back_populates="assessment")


class CyberCategory(Base):
    __tablename__ = "cyber_categories"

    category_id: Mapped[int] = mapped_column(
        BigInteger, primary_key=True, autoincrement=True
    )
    assessment_id: Mapped[int | None] = mapped_column(
        BigInteger, ForeignKey("cyber_assessments.assessment_id")
    )
    category_name: Mapped[str | None] = mapped_column(String(255))
    category_description: Mapped[str | None] = mapped_column(Text)
    display_order: Mapped[int | None] = mapped_column(Integer)
    created_at: Mapped[datetime | None] = mapped_column(DateTime)
    updated_at: Mapped[datetime | None] = mapped_column(DateTime)

    assessment: Mapped["CyberAssessment"] = relationship(back_populates="categories")
    questions: Mapped[List["CyberQuestion"]] = relationship(back_populates="category")


class CyberHeader(Base):
    __tablename__ = "cyber_headers"

    header_id: Mapped[int] = mapped_column(
        BigInteger, primary_key=True, autoincrement=True
    )
    assessment_id: Mapped[int | None] = mapped_column(
        BigInteger, ForeignKey("cyber_assessments.assessment_id")
    )
    header_key: Mapped[str | None] = mapped_column(String(50))
    header_label: Mapped[str | None] = mapped_column(String(255))
    header_value: Mapped[str | None] = mapped_column(Text)
    additional_information: Mapped[str | None] = mapped_column(Text)
    display_order: Mapped[int | None] = mapped_column(Integer)
    created_at: Mapped[datetime | None] = mapped_column(DateTime)
    updated_at: Mapped[datetime | None] = mapped_column(DateTime)

    assessment: Mapped["CyberAssessment"] = relationship(back_populates="headers")


class CyberQuestion(Base):
    __tablename__ = "cyber_questions"

    question_id: Mapped[int] = mapped_column(
        BigInteger, primary_key=True, autoincrement=True
    )
    category_id: Mapped[int | None] = mapped_column(
        BigInteger, ForeignKey("cyber_categories.category_id")
    )
    control_id: Mapped[str | None] = mapped_column(String(50))
    question_text: Mapped[str | None] = mapped_column(Text)
    guidance_text: Mapped[str | None] = mapped_column(Text)
    answer_type: Mapped[str | None] = mapped_column(String(50))
    display_order: Mapped[int | None] = mapped_column(Integer)
    is_active: Mapped[bool | None] = mapped_column(Boolean, default=True)
    created_at: Mapped[datetime | None] = mapped_column(DateTime)
    updated_at: Mapped[datetime | None] = mapped_column(DateTime)

    category: Mapped["CyberCategory"] = relationship(back_populates="questions")
    responses: Mapped[List["CyberResponse"]] = relationship(back_populates="question")


class CyberResponse(Base):
    __tablename__ = "cyber_responses"

    response_id: Mapped[int] = mapped_column(
        BigInteger, primary_key=True, autoincrement=True
    )
    assessment_id: Mapped[int | None] = mapped_column(
        BigInteger, ForeignKey("cyber_assessments.assessment_id")
    )
    question_id: Mapped[int | None] = mapped_column(
        BigInteger, ForeignKey("cyber_questions.question_id")
    )
    vendor_answer: Mapped[str | None] = mapped_column(Text)
    additional_information: Mapped[str | None] = mapped_column(Text)
    internal_notes: Mapped[str | None] = mapped_column(Text)
    status: Mapped[str | None] = mapped_column(String(50))
    risk_flag: Mapped[bool | None] = mapped_column(Boolean, default=False)
    ai_suggested: Mapped[bool | None] = mapped_column(Boolean, default=False)
    last_reviewed_date: Mapped[date | None] = mapped_column(Date)
    approved_by: Mapped[str | None] = mapped_column(String(255))
    created_at: Mapped[datetime | None] = mapped_column(DateTime)
    updated_at: Mapped[datetime | None] = mapped_column(DateTime)

    assessment: Mapped["CyberAssessment"] = relationship(back_populates="responses")
    question: Mapped["CyberQuestion"] = relationship(back_populates="responses")
    evidence_items: Mapped[List["CyberEvidence"]] = relationship(
        secondary="cyber_response_evidence",
        back_populates="responses",
    )


class CyberEvidence(Base):
    __tablename__ = "cyber_evidence"

    evidence_id: Mapped[int] = mapped_column(
        BigInteger, primary_key=True, autoincrement=True
    )
    evidence_name: Mapped[str | None] = mapped_column(String(255))
    evidence_type: Mapped[str | None] = mapped_column(String(100))
    description: Mapped[str | None] = mapped_column(Text)
    file_path_or_url: Mapped[str | None] = mapped_column(String(500))
    confidentiality_level: Mapped[str | None] = mapped_column(String(50))
    owner: Mapped[str | None] = mapped_column(String(255))
    review_date: Mapped[date | None] = mapped_column(Date)
    expiration_date: Mapped[date | None] = mapped_column(Date)
    created_at: Mapped[datetime | None] = mapped_column(DateTime)
    updated_at: Mapped[datetime | None] = mapped_column(DateTime)

    responses: Mapped[List["CyberResponse"]] = relationship(
        secondary="cyber_response_evidence",
        back_populates="evidence_items",
    )


class CyberResponseEvidence(Base):
    __tablename__ = "cyber_response_evidence"

    response_id: Mapped[int] = mapped_column(
        BigInteger, ForeignKey("cyber_responses.response_id"), primary_key=True
    )
    evidence_id: Mapped[int] = mapped_column(
        BigInteger, ForeignKey("cyber_evidence.evidence_id"), primary_key=True
    )


class CyberAnswerLibrary(Base):
    __tablename__ = "cyber_answer_library"

    answer_template_id: Mapped[int] = mapped_column(
        BigInteger, primary_key=True, autoincrement=True
    )
    category_id: Mapped[int | None] = mapped_column(
        BigInteger, ForeignKey("cyber_categories.category_id")
    )
    topic: Mapped[str | None] = mapped_column(String(255))
    standard_answer: Mapped[str | None] = mapped_column(Text)
    approved_external_answer: Mapped[str | None] = mapped_column(Text)
    internal_notes: Mapped[str | None] = mapped_column(Text)
    status: Mapped[str | None] = mapped_column(String(50))
    last_reviewed_date: Mapped[date | None] = mapped_column(Date)
    usage_count: Mapped[int | None] = mapped_column(Integer, default=0)
    created_at: Mapped[datetime | None] = mapped_column(DateTime)
    updated_at: Mapped[datetime | None] = mapped_column(DateTime)


class CyberRisk(Base):
    __tablename__ = "cyber_risks"

    risk_id: Mapped[int] = mapped_column(
        BigInteger, primary_key=True, autoincrement=True
    )
    assessment_id: Mapped[int | None] = mapped_column(
        BigInteger, ForeignKey("cyber_assessments.assessment_id")
    )
    question_id: Mapped[int | None] = mapped_column(
        BigInteger, ForeignKey("cyber_questions.question_id")
    )
    risk_title: Mapped[str | None] = mapped_column(String(255))
    risk_description: Mapped[str | None] = mapped_column(Text)
    severity: Mapped[str | None] = mapped_column(String(50))
    likelihood: Mapped[int | None] = mapped_column(Integer)
    impact: Mapped[int | None] = mapped_column(Integer)
    risk_score: Mapped[int | None] = mapped_column(Integer)
    owner: Mapped[str | None] = mapped_column(String(255))
    target_date: Mapped[date | None] = mapped_column(Date)
    status: Mapped[str | None] = mapped_column(String(50))
    treatment: Mapped[str | None] = mapped_column(String(50))
    remediation_notes: Mapped[str | None] = mapped_column(Text)
    residual_risk_score: Mapped[int | None] = mapped_column(Integer)
    created_at: Mapped[datetime | None] = mapped_column(DateTime)
    updated_at: Mapped[datetime | None] = mapped_column(DateTime)
