from __future__ import annotations

from datetime import date, datetime

from pydantic import BaseModel, ConfigDict


class AssessmentBase(BaseModel):
    assessment_key: str | None = None
    assessment_name: str | None = None
    customer_name: str | None = None
    source_questionnaire: str | None = None
    assessment_date: date | None = None
    review_date: date | None = None
    status: str | None = None


class AssessmentResponse(AssessmentBase):
    model_config = ConfigDict(from_attributes=True)

    assessment_id: int
    created_at: datetime | None = None
    updated_at: datetime | None = None


class CategoryBase(BaseModel):
    category_name: str | None = None
    category_description: str | None = None
    display_order: int | None = None


class CategoryResponse(CategoryBase):
    model_config = ConfigDict(from_attributes=True)

    category_id: int
    assessment_id: int | None = None
    created_at: datetime | None = None
    updated_at: datetime | None = None


class QuestionBase(BaseModel):
    control_id: str | None = None
    question_text: str | None = None
    guidance_text: str | None = None
    answer_type: str | None = None
    display_order: int | None = None
    is_active: bool | None = True


class QuestionResponse(QuestionBase):
    model_config = ConfigDict(from_attributes=True)

    question_id: int
    category_id: int | None = None
    created_at: datetime | None = None
    updated_at: datetime | None = None


class ResponseBase(BaseModel):
    vendor_answer: str | None = None
    additional_information: str | None = None
    internal_notes: str | None = None
    status: str | None = None
    risk_flag: bool | None = False
    ai_suggested: bool | None = False
    last_reviewed_date: date | None = None
    approved_by: str | None = None


class ResponseDetail(ResponseBase):
    model_config = ConfigDict(from_attributes=True)

    response_id: int
    assessment_id: int | None = None
    question_id: int | None = None
    created_at: datetime | None = None
    updated_at: datetime | None = None


class ResponseWithQuestion(ResponseDetail):
    question: QuestionResponse | None = None


class CategoryWithQuestions(CategoryResponse):
    questions: list[QuestionResponse] = []


class AssessmentDetail(AssessmentResponse):
    categories: list[CategoryWithQuestions] = []
    responses: list[ResponseDetail] = []


class EvidenceBase(BaseModel):
    evidence_name: str | None = None
    evidence_type: str | None = None
    description: str | None = None
    file_path_or_url: str | None = None
    confidentiality_level: str | None = None
    owner: str | None = None
    review_date: date | None = None
    expiration_date: date | None = None


class EvidenceResponse(EvidenceBase):
    model_config = ConfigDict(from_attributes=True)

    evidence_id: int
    created_at: datetime | None = None
    updated_at: datetime | None = None


class AnswerLibraryBase(BaseModel):
    topic: str | None = None
    standard_answer: str | None = None
    approved_external_answer: str | None = None
    internal_notes: str | None = None
    status: str | None = None


class AnswerLibraryResponse(AnswerLibraryBase):
    model_config = ConfigDict(from_attributes=True)

    answer_template_id: int
    category_id: int | None = None
    last_reviewed_date: date | None = None
    usage_count: int | None = None
    created_at: datetime | None = None
    updated_at: datetime | None = None


class RiskBase(BaseModel):
    risk_title: str | None = None
    risk_description: str | None = None
    severity: str | None = None
    likelihood: int | None = None
    impact: int | None = None
    risk_score: int | None = None
    owner: str | None = None
    target_date: date | None = None
    status: str | None = None
    treatment: str | None = None
    remediation_notes: str | None = None
    residual_risk_score: int | None = None


class RiskResponse(RiskBase):
    model_config = ConfigDict(from_attributes=True)

    risk_id: int
    assessment_id: int | None = None
    question_id: int | None = None
    created_at: datetime | None = None
    updated_at: datetime | None = None
