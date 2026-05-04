---
stepsCompleted:
  - product-definition
  - user-research
  - vanta-competitive-analysis
  - database-schema
  - feature-roadmap
  - technical-architecture
inputDocuments:
  - _bmad-input/prd_brainstorming.md
  - _bmad-input/Educational_Vistas_Vendor_Security_Questionnaire_Responses.md
  - _bmad-input/create_cyber_questionnaire_normalized.sql
  - _bmad-output/vanta-feature-gap-analysis.md
workflowType: prd
---

# Product Requirements Document - AnswerForge / ControlDeck

**Project:** answerforge
**Author:** Educational Vistas, Inc.
**Date:** 2026-04-30
**Status:** Draft v2.0 (post-Vanta competitive analysis)
**Audience:** EVI IT, Security, Compliance, Leadership, and Product stakeholders

---

## 1. Executive Summary

AnswerForge (powered by ControlDeck) is an internal cybersecurity questionnaire, compliance response, and trust management platform for Educational Vistas, Inc. It centralizes security questionnaire responses, vendor security answers, compliance evidence, assessment history, reusable security language, and — critically — provides a path toward proactive trust demonstration with customers.

After competitive analysis against Vanta (the market leader in automated compliance and trust management), this PRD has been expanded to include high-value features that accelerate EVI's ability to respond to security questionnaires, identify compliance gaps, and eventually demonstrate security posture proactively to customers and auditors.

### Product Naming

- **ControlDeck** — The internal security questionnaire and compliance response platform.
- **AnswerForge** — The AI-assisted answer drafting and trust demonstration engine inside ControlDeck.

> **ControlDeck** manages assessments, answers, evidence, risks, and exports. **AnswerForge** drafts, refines, validates, and helps demonstrate questionnaire responses using approved internal data.

---

## 2. Product Vision

Build an internal application that centralizes cybersecurity questionnaire responses, vendor security answers, compliance evidence, assessment history, and reusable security language — and evolves toward a platform that helps Educational Vistas **prove trust** to customers before they even ask.

### Vision Statement

> "Reduce questionnaire response time by 80%, improve answer consistency across all customers, and give Educational Vistas a real-time view of its cybersecurity and compliance maturity."

### North Star Metrics

| Metric | Current State | 12-Month Target |
|---|---|---|
| Time to complete a vendor security questionnaire | 8-16 hours | < 2 hours |
| Answer reuse rate across questionnaires | ~10% | > 70% |
| Evidence documents scattered across locations | 10+ locations | 1 centralized vault |
| Gaps identified only during questionnaires | 100% | < 20% (proactive tracking) |
| Customer trust demonstrations | Reactive only | Proactive Trust Center |

---

## 3. Problem Statement

Educational Vistas receives vendor security questionnaires from school districts and other education customers. These questionnaires often contain repeated or similar questions about cybersecurity, privacy, business continuity, disaster recovery, access controls, encryption, datacenter security, vulnerability management, and compliance.

### Current Pain Points

1. **Inconsistent Answers** — Answers vary across questionnaires depending on who responds.
2. **Reactive Gap Discovery** — Security gaps are found during questionnaire completion, not tracked centrally.
3. **Scattered Evidence** — SOC 2 reports, incident response plans, and policies live in emails, file shares, and SharePoint.
4. **Mixed Data** — General company info, questions, categories, and responses are blended together.
5. **No Reuse** — Each questionnaire starts from scratch; institutional memory is lost.
6. **Slow Sales Cycles** — Security reviews delay deals by days or weeks.
7. **Audit Friction** — Preparing for audits requires manual evidence gathering and spreadsheet tracking.

### Competitive Context

Vanta (vanta.com) has established the gold standard for trust management platforms. Their "Agentic Trust Platform" offers:

- 400+ integrations for automated evidence collection
- Continuous control monitoring (not point-in-time)
- Customer-facing Trust Centers that accelerate sales
- AI-powered questionnaire automation
- Auditor portals for streamlined audits
- Policy management with employee acknowledgment tracking
- Risk registers with heat maps and scoring
- Third-party vendor risk management

EVI does not need to replicate Vanta entirely, but should adopt its **highest-value features** for an internal K-12 education-focused platform.

---

## 4. Goals

### Primary Goals

1. Store all questionnaire questions, categories, answers, and supporting notes in a normalized database.
2. Separate general vendor/header information from individual questionnaire responses.
3. Maintain reusable standard answers for common security questions with approval workflows.
4. Track answer status: Draft, Approved, Needs Review, Needs Evidence, Outdated, Do Not Use.
5. Provide a searchable interface for prior questions and responses with AI-powered similarity matching.
6. Support AI-assisted answer drafting grounded in approved internal data only.
7. Track evidence documents (SOC 2 reports, IR plans, DR plans, policies, diagrams) with expiration alerts.
8. Show readiness/completion status by category, assessment, and framework.
9. Export responses to Markdown, Excel, PDF, SQL, and customer-specific formats with confidentiality controls.
10. Identify gaps where EVI lacks formal documentation or needs remediation, tracked as risks.

### Secondary Goals (Competitive Differentiation)

11. **Trust Center** — Proactively demonstrate compliance status to customers (Phase 2).
12. **Audit Management** — Streamline external audit preparation and evidence sharing (Phase 2).
13. **Policy Management** — Distribute, track acknowledgment, and version security policies (Phase 2).
14. **Framework Mapping** — Map controls across multiple compliance frameworks (SOC 2, ISO 27001, NY Ed Law 2-d, etc.) (Phase 3).
15. **Vendor Risk Management** — Assess and monitor third-party vendor security posture (Phase 3).
16. **Continuous Monitoring** — Automated control tests via integrations (Phase 4).

---

## 5. Non-Goals

The following are explicitly out of scope for all phases unless otherwise noted:

- No direct production customer data access.
- No automated submission into third-party questionnaire portals (e.g., Whistic, SecurityScorecard).
- No direct write access to production SQL Server from AI tools.
- No replacement for legal review or formal cybersecurity audits.
- No autonomous AI approval of questionnaire answers (human-in-the-loop required).
- No storage of customer PII unless explicitly required and approved.
- No public vulnerability disclosure or bug bounty program management.

---

## 6. Target Users

### 6.1 IT / Security Administrator (Primary)

**Responsibilities:** Maintain answers, evidence, technical accuracy, and security posture.

**Needs:**
- Fast semantic search across prior answers and evidence.
- Update responses with full audit trail.
- Flag questions needing review and assign owners.
- Attach or reference evidence with confidentiality classification.
- Identify missing controls, policies, or documentation gaps.
- Manage vulnerability findings and remediation timelines.
- Conduct periodic access reviews.

**Pain:** "I spend hours searching through old emails and spreadsheets to find the right answer."

### 6.2 Executive / Leadership Reviewer

**Responsibilities:** Review risk exposure and approve sensitive answers.

**Needs:**
- High-level executive dashboard with program health score.
- Open risks/gaps with severity and owner.
- Questionnaire completion status across all assessments.
- Recently changed answers requiring re-approval.
- Items requiring executive or legal review.
- Compliance framework coverage (e.g., SOC 2, ISO 27001 readiness).

**Pain:** "I don't know our current compliance posture until a customer asks or an audit starts."

### 6.3 Sales / Account Management

**Responsibilities:** Respond to customer security requests and close deals.

**Needs:**
- Approved answer library with clear external-shareable flag.
- One-click export of customer-ready responses.
- Customer-specific questionnaire records and history.
- Clear indication of what can be shared externally vs. internal-only.
- Trust Center link to share with prospects proactively.
- Track which customers have viewed the Trust Center.

**Pain:** "Security questionnaires delay deals by a week because I have to wait for IT to draft answers."

### 6.4 Product / Development Team

**Responsibilities:** Technical remediation and application security improvements.

**Needs:**
- Vulnerability-related question tracking with severity.
- Remediation notes and target dates.
- Product-specific security answers and gaps.
- Integration with ticketing systems (Jira, Azure DevOps).
- Security requirements from customer commitments.

**Pain:** "I don't know which security gaps are blocking sales or customer renewals."

### 6.5 External Auditor (Phase 2)

**Responsibilities:** Verify EVI's security controls and compliance.

**Needs:**
- Secure auditor portal with time-limited access.
- Direct evidence download (SOC 2 reports, pen tests, policies).
- Audit finding tracking and remediation status.
- Read-only access to controls and test history.

**Pain:** "I waste days requesting evidence via email and waiting for responses."

---

## 7. Core Concepts

### 7.1 Assessment

A customer-specific questionnaire or security review instance.

**Examples:**
- Mount Pleasant CSD Vendor Assessment (2026-04-30)
- CoSN K-12 Vendor Assessment Lite
- NY Ed Law 2-d Security Review
- Internal SOC 2 Readiness Assessment

**Fields:** `assessment_id`, `assessment_key`, `assessment_name`, `customer_name`, `source_questionnaire`, `assessment_date`, `review_date`, `status`, `created_at`, `updated_at`

### 7.2 Category

A questionnaire section or domain.

**Examples:** Documentation, Company Overview, Application Security, Authentication, Business Continuity, Change Management, Data, Database, Datacenter, Disaster Recovery, Firewalls/IDS/IPS, Physical Security, Policies, Systems Management, Vulnerability Scanning.

**Fields:** `category_id`, `category_name`, `category_description`, `display_order`, `framework_mappings`

### 7.3 Question (Control)

A specific control or question from a questionnaire.

**Example:** `HLAP-01`: "Does your system support various permission levels, for example role-based access control, for end users?"

**Fields:** `question_id`, `category_id`, `control_id`, `question_text`, `guidance_text`, `answer_type`, `display_order`, `is_active`, `framework_mappings`

### 7.4 Response

EVI's answer to a question for a specific assessment.

**Fields:** `response_id`, `assessment_id`, `question_id`, `vendor_answer`, `additional_information`, `internal_notes`, `status`, `risk_flag`, `last_reviewed_date`, `approved_by`, `ai_suggested`, `created_at`, `updated_at`

### 7.5 Evidence

A document, link, or artifact supporting an answer or control.

**Examples:** SOC 2 Type II report, Incident Response Plan, Disaster Recovery Plan, Network diagram, Vulnerability scan summary, Security policy, Backup procedure, Datacenter security documentation.

**Fields:** `evidence_id`, `evidence_name`, `evidence_type`, `description`, `file_path_or_url`, `confidentiality_level`, `owner`, `review_date`, `expiration_date`, `framework_mappings`, `created_at`, `updated_at`

### 7.6 Answer Template (Answer Library)

Reusable approved answer for common topics.

**Examples:** Encryption at rest, Encryption in transit, Role-based access control, Tenant segmentation, Incident response, Disaster recovery.

**Fields:** `answer_template_id`, `category_id`, `topic`, `standard_answer`, `approved_external_answer`, `internal_notes`, `status`, `last_reviewed_date`, `usage_count`

### 7.7 Risk / Gap

A discovered weakness requiring remediation.

**Fields:** `risk_id`, `assessment_id`, `question_id`, `risk_title`, `risk_description`, `severity`, `likelihood`, `impact`, `owner`, `target_date`, `status`, `remediation_notes`, `residual_risk`, `created_at`, `updated_at`

### 7.8 Policy

A formal security or compliance policy document.

**Fields:** `policy_id`, `policy_name`, `policy_type`, `version`, `content`, `owner`, `review_cycle_months`, `last_reviewed_date`, `next_review_date`, `acknowledgment_required`, `created_at`, `updated_at`

### 7.9 Compliance Framework

A standard or regulation that EVI must comply with.

**Examples:** SOC 2, ISO 27001, NY Ed Law 2-d, FERPA, NIST CSF, CIS Controls, CoSN K-12, GDPR, HIPAA.

**Fields:** `framework_id`, `framework_code`, `framework_name`, `version`, `description`, `is_active`

### 7.10 Control

A specific requirement within a compliance framework.

**Fields:** `control_id`, `framework_id`, `control_code`, `control_name`, `control_description`, `maturity_level`, `owner`, `test_frequency`, `last_tested_date`, `status`

---

## 8. Database Model

### Core Tables (MVP)

```sql
-- 1. Assessments
dbo.cyber_assessments
  assessment_id (PK, INT, IDENTITY)
  assessment_key (NVARCHAR(100), UNIQUE)
  assessment_name (NVARCHAR(255))
  customer_name (NVARCHAR(255))
  source_questionnaire (NVARCHAR(255))
  assessment_date (DATE)
  review_date (DATE)
  status (NVARCHAR(50)) -- Draft, Active, Archived, Closed
  created_at (DATETIME2)
  updated_at (DATETIME2)

-- 2. Categories
dbo.cyber_categories
  category_id (PK, INT, IDENTITY)
  assessment_id (FK)
  category_name (NVARCHAR(255))
  category_description (NVARCHAR(MAX))
  display_order (INT)
  created_at (DATETIME2)
  updated_at (DATETIME2)

-- 3. Headers (General Information)
dbo.cyber_headers
  header_id (PK, INT, IDENTITY)
  assessment_id (FK)
  header_key (NVARCHAR(50))
  header_label (NVARCHAR(255))
  header_value (NVARCHAR(MAX))
  additional_information (NVARCHAR(MAX))
  display_order (INT)
  created_at (DATETIME2)
  updated_at (DATETIME2)

-- 4. Questions
dbo.cyber_questions
  question_id (PK, INT, IDENTITY)
  category_id (FK)
  control_id (NVARCHAR(50))
  question_text (NVARCHAR(MAX))
  guidance_text (NVARCHAR(MAX))
  answer_type (NVARCHAR(50)) -- Yes/No, Text, Multi-select, etc.
  display_order (INT)
  is_active (BIT, DEFAULT 1)
  created_at (DATETIME2)
  updated_at (DATETIME2)

-- 5. Responses
dbo.cyber_responses
  response_id (PK, INT, IDENTITY)
  assessment_id (FK)
  question_id (FK)
  vendor_answer (NVARCHAR(MAX))
  additional_information (NVARCHAR(MAX))
  internal_notes (NVARCHAR(MAX))
  status (NVARCHAR(50)) -- Draft, Needs Review, Approved, Needs Evidence, Outdated, Do Not Use
  risk_flag (BIT, DEFAULT 0)
  ai_suggested (BIT, DEFAULT 0)
  last_reviewed_date (DATE)
  approved_by (NVARCHAR(255))
  created_at (DATETIME2)
  updated_at (DATETIME2)

-- 6. Evidence
dbo.cyber_evidence
  evidence_id (PK, INT, IDENTITY)
  evidence_name (NVARCHAR(255))
  evidence_type (NVARCHAR(100)) -- Policy, Report, Diagram, Certificate, etc.
  description (NVARCHAR(MAX))
  file_path_or_url (NVARCHAR(500))
  confidentiality_level (NVARCHAR(50)) -- Public, Customer-shareable under NDA, Internal, Confidential, Restricted
  owner (NVARCHAR(255))
  review_date (DATE)
  expiration_date (DATE)
  created_at (DATETIME2)
  updated_at (DATETIME2)

-- 7. Response-Evidence Junction
dbo.cyber_response_evidence
  response_id (FK)
  evidence_id (FK)

-- 8. Answer Library
dbo.cyber_answer_library
  answer_template_id (PK, INT, IDENTITY)
  category_id (FK, NULL)
  topic (NVARCHAR(255))
  standard_answer (NVARCHAR(MAX))
  approved_external_answer (NVARCHAR(MAX))
  internal_notes (NVARCHAR(MAX))
  status (NVARCHAR(50)) -- Draft, Approved, Needs Review, Outdated
  last_reviewed_date (DATE)
  usage_count (INT, DEFAULT 0)
  created_at (DATETIME2)
  updated_at (DATETIME2)
```

### Phase 2 Tables

```sql
-- 9. Risks / Gaps
dbo.cyber_risks
  risk_id (PK, INT, IDENTITY)
  assessment_id (FK, NULL)
  question_id (FK, NULL)
  control_id (FK, NULL)
  risk_title (NVARCHAR(255))
  risk_description (NVARCHAR(MAX))
  severity (NVARCHAR(50)) -- Critical, High, Medium, Low, Informational
  likelihood (INT, 1-5)
  impact (INT, 1-5)
  risk_score (INT) -- Calculated: likelihood * impact
  owner (NVARCHAR(255))
  target_date (DATE)
  status (NVARCHAR(50)) -- Open, In Progress, Mitigated, Accepted, Closed
  treatment (NVARCHAR(50)) -- Mitigate, Transfer, Accept, Avoid
  remediation_notes (NVARCHAR(MAX))
  residual_risk_score (INT)
  created_at (DATETIME2)
  updated_at (DATETIME2)

-- 10. Policies
dbo.cyber_policies
  policy_id (PK, INT, IDENTITY)
  policy_name (NVARCHAR(255))
  policy_type (NVARCHAR(100))
  version (NVARCHAR(20))
  content (NVARCHAR(MAX))
  owner (NVARCHAR(255))
  review_cycle_months (INT)
  last_reviewed_date (DATE)
  next_review_date (DATE)
  acknowledgment_required (BIT, DEFAULT 0)
  created_at (DATETIME2)
  updated_at (DATETIME2)

-- 11. Policy Acknowledgments
dbo.cyber_policy_acknowledgments
  acknowledgment_id (PK, INT, IDENTITY)
  policy_id (FK)
  user_id (NVARCHAR(255))
  acknowledged_at (DATETIME2)
  ip_address (NVARCHAR(45))

-- 12. Review History
dbo.cyber_review_history
  review_id (PK, INT, IDENTITY)
  entity_type (NVARCHAR(50)) -- Response, Evidence, Policy, Risk
  entity_id (INT)
  reviewed_by (NVARCHAR(255))
  reviewed_at (DATETIME2)
  review_notes (NVARCHAR(MAX))
  status_changed_from (NVARCHAR(50))
  status_changed_to (NVARCHAR(50))

-- 13. Frameworks
dbo.cyber_frameworks
  framework_id (PK, INT, IDENTITY)
  framework_code (NVARCHAR(50), UNIQUE)
  framework_name (NVARCHAR(255))
  version (NVARCHAR(20))
  description (NVARCHAR(MAX))
  is_active (BIT, DEFAULT 1)

-- 14. Framework Controls
dbo.cyber_framework_controls
  control_id (PK, INT, IDENTITY)
  framework_id (FK)
  control_code (NVARCHAR(50))
  control_name (NVARCHAR(255))
  control_description (NVARCHAR(MAX))
  maturity_level (INT, 1-5)
  owner (NVARCHAR(255))
  test_frequency (NVARCHAR(50)) -- Daily, Weekly, Monthly, Quarterly, Annually
  last_tested_date (DATE)
  status (NVARCHAR(50)) -- Not Implemented, Partially Implemented, Implemented, Not Applicable

-- 15. Control-Question Mapping
dbo.cyber_control_question_mapping
  mapping_id (PK, INT, IDENTITY)
  control_id (FK)
  question_id (FK)
```

### Phase 3+ Tables

```sql
-- 16. Vendors (Third-Party Risk Management)
dbo.cyber_vendors
  vendor_id (PK, INT, IDENTITY)
  vendor_name (NVARCHAR(255))
  vendor_type (NVARCHAR(100)) -- Cloud Provider, Software, Service, Hardware
  criticality (NVARCHAR(50)) -- Critical, High, Medium, Low
  risk_score (INT)
  status (NVARCHAR(50)) -- Active, Under Review, Remediation, Approved, Denied
  onboarded_date (DATE)
  last_reviewed_date (DATE)
  next_review_date (DATE)
  created_at (DATETIME2)
  updated_at (DATETIME2)

-- 17. Vendor Assessments
dbo.cyber_vendor_assessments
  vendor_assessment_id (PK, INT, IDENTITY)
  vendor_id (FK)
  assessment_type (NVARCHAR(100)) -- Questionnaire, Audit, Document Review
  status (NVARCHAR(50))
  findings_summary (NVARCHAR(MAX))
  completed_date (DATE)
  reviewed_by (NVARCHAR(255))

-- 18. Integrations
dbo.cyber_integrations
  integration_id (PK, INT, IDENTITY)
  integration_name (NVARCHAR(255))
  integration_type (NVARCHAR(100)) -- AWS, Azure, GitHub, Okta, Jira, etc.
  configuration (NVARCHAR(MAX)) -- JSON config
  last_sync_at (DATETIME2)
  status (NVARCHAR(50)) -- Active, Error, Paused

-- 19. Audit Logs
dbo.cyber_audit_logs
  log_id (PK, INT, IDENTITY)
  user_id (NVARCHAR(255))
  action (NVARCHAR(100)) -- CREATE, UPDATE, DELETE, VIEW, EXPORT
  entity_type (NVARCHAR(50))
  entity_id (INT)
  old_values (NVARCHAR(MAX))
  new_values (NVARCHAR(MAX))
  ip_address (NVARCHAR(45))
  user_agent (NVARCHAR(500))
  created_at (DATETIME2)

-- 20. Users & Roles
dbo.cyber_users
  user_id (PK, INT, IDENTITY)
  email (NVARCHAR(255), UNIQUE)
  display_name (NVARCHAR(255))
  role (NVARCHAR(50)) -- Admin, Editor, Reviewer, Viewer, Auditor
  department (NVARCHAR(100))
  is_active (BIT, DEFAULT 1)
  last_login_at (DATETIME2)
  created_at (DATETIME2)
  updated_at (DATETIME2)
```

---

## 9. Application Features

### 9.1 Dashboard

**Purpose:** Single-pane-of-glass view of the compliance program.

**Widgets:**
- **Program Health Score** — Overall compliance maturity (0-100%)
- **Assessment Overview** — Total / Open / Completed assessments
- **Questions Answered** — Count by status (Approved, Draft, Needs Review)
- **Gaps by Severity** — Critical / High / Medium / Low risk count
- **Evidence Status** — Total evidence / Expiring soon / Expired
- **Category Maturity** — Heat map of category readiness
- **Framework Coverage** — Progress bars per framework (SOC 2, ISO 27001, etc.)
- **Recent Activity** — Last updated answers, new evidence, review completions
- **AI Suggestions Pending** — Count of AI-drafted answers awaiting review

**Example Cards:**
- "92% Complete — Mount Pleasant CSD Assessment"
- "6 Answers Need Review"
- "3 Policy Gaps Identified"
- "2 Evidence Documents Expiring in 30 Days"
- "SOC 2 Readiness: 78%"

### 9.2 Assessment Manager

**Purpose:** Create, manage, and complete customer security questionnaires.

**Features:**
- **Assessment List** — Filter by customer, status, date, framework
- **Assessment Builder** — Create from template, duplicate existing, or import customer Excel
- **Category Navigation** — Left sidebar with progress indicators
- **Question Cards** — Expandable cards with inline editing
- **Bulk Operations** — Approve, flag, or assign multiple responses
- **Comparison View** — Side-by-side comparison of two assessments
- **Import from Excel** — Parse customer questionnaires into structured data
- **Duplicate Detection** — AI suggests similar past assessments

### 9.3 Questionnaire Viewer

**Purpose:** Structured view of an individual assessment.

**Features:**
- Left sidebar category navigation with completion %
- Control ID and keyword search
- Filter by answer: Yes / No / N/A / Partially / Not Answered
- Filter by status: Draft / Approved / Needs Review / Needs Evidence
- Expandable question cards with:
  - Vendor answer field
  - Additional information (customer-facing)
  - Internal notes (hidden from export)
  - Evidence attachment area
  - AI suggestion panel
  - Review status and history
- Inline editing with auto-save
- Real-time collaboration indicators

### 9.4 Answer Library

**Purpose:** Centralized repository of approved, reusable answers.

**Features:**
- **Topic Browser** — Browse by category or search
- **Template Editor** — Create and edit answer templates
- **Approval Workflow** — Draft → Needs Review → Approved → Outdated
- **Version History** — Track changes to approved answers
- **Usage Analytics** — See how often each template is used
- **AI Enhancement** — Suggest improvements to existing templates
- **External vs. Internal** — Separate approved external answer from internal notes
- **Framework Tagging** — Link templates to specific compliance frameworks

**Example Topics:**
Encryption at rest, Encryption in transit, Role-based access control, Tenant segmentation, Incident response, Disaster recovery, Firewall controls, Physical security, Vulnerability remediation, NY Ed Law 2-d, Business continuity, Change management.

### 9.5 Evidence Vault

**Purpose:** Central document library for compliance artifacts.

**Features:**
- **Document Upload** — Drag-and-drop or file picker
- **Confidentiality Classification** — Public / Customer-shareable under NDA / Internal / Confidential / Restricted
- **Expiration Tracking** — Alerts 30, 60, 90 days before expiration
- **Framework Linking** — Tag evidence to specific frameworks and controls
- **Search & Filter** — Full-text search, filter by type, owner, date
- **Preview** — In-app preview for PDFs, images, markdown
- **Download with Watermark** — Auto-watermark downloaded docs with recipient info
- **Audit Trail** — Track who viewed/downloaded each document

**Evidence Types:**
SOC 2 report, Incident Response Plan, Disaster Recovery Plan, Parent Bill of Rights, Vulnerability scan summary, Datacenter controls summary, Network segmentation description, Firewall architecture notes, Security policy, Backup procedure, Penetration test report, Business Continuity Plan.

### 9.6 AI Answer Assistant (AnswerForge)

**Purpose:** AI-powered drafting, refinement, and validation of questionnaire responses.

**Core Principles:**
- AI suggests. Humans approve.
- All AI suggestions are grounded in approved internal data only.
- AI never sees internal notes unless explicitly permitted.
- All AI-generated answers are flagged and require human review.

**AI Actions:**

| Action | Description |
|---|---|
| **Draft Answer** | Draft concise answer from answer library and linked evidence. Configurable length (e.g., under 500 chars). |
| **Shorten Answer** | Compress answer to fit small questionnaire fields while preserving accuracy. |
| **Customer-Friendly Rewrite** | Convert technical jargon to accessible language for non-technical reviewers. |
| **Compare to Past** | Find similar past questions and show how they were answered. |
| **Suggest Evidence** | Recommend evidence records that support this answer. |
| **Risk Review** | Flag overclaiming, infrastructure detail exposure, or conflicts with approved responses. |
| **Gap Detection** | For "No" answers, auto-create risk/remediation item with severity and recommended steps. |
| **Consistency Check** | Ensure answer aligns with other approved responses on the same topic. |
| **Framework Mapping** | Suggest which compliance frameworks and controls this question relates to. |

**AI Prompts (Examples):**

```
Draft: "Draft a concise vendor questionnaire answer using only approved 
answer library content and linked evidence. Keep under 500 characters."

Shorten: "Shorten this answer to fit in a small Excel cell while preserving 
accuracy and avoiding overclaiming."

Risk Review: "Review this answer and identify whether it overclaims, reveals 
too much infrastructure detail, or conflicts with existing approved responses."

Evidence Suggestion: "Suggest evidence records that support this answer 
from the Evidence Vault."

Gap Detection: "This answer is 'No.' Create a remediation item with severity, 
owner suggestion, and recommended next steps."
```

### 9.7 Risk & Remediation Tracker

**Purpose:** Track gaps, risks, and remediation efforts discovered during questionnaires.

**Features:**
- **Risk Register** — Centralized inventory of all risks
- **Risk Scoring** — Likelihood (1-5) × Impact (1-5) = Risk Score (1-25)
- **Heat Map** — Visual 5×5 matrix of likelihood vs. impact
- **Treatment Planning** — Mitigate, Transfer, Accept, Avoid
- **Owner Assignment** — Clear accountability with due dates
- **Status Tracking** — Open → In Progress → Mitigated → Closed
- **Residual Risk** — Track post-treatment risk levels
- **Link to Responses** — Auto-link risks to the question that triggered them
- **Executive Report** — Board-ready risk summary

### 9.8 Policy Manager (Phase 2)

**Purpose:** Manage security policies, versions, and employee acknowledgments.

**Features:**
- **Policy Templates** — 40+ pre-built policy templates (from Vanta competitive research)
- **Version Control** — Track policy versions with diff view
- **Distribution** — Assign policies to specific users or groups
- **Acknowledgment Tracking** — Monitor who has read and acknowledged each policy
- **Review Reminders** — Auto-remind owners when policies are due for review
- **Exception Management** — Track and approve policy exceptions with expiration dates
- **Framework Linking** — Map policies to compliance framework requirements

### 9.9 Audit Manager (Phase 2)

**Purpose:** Streamline external audit preparation and execution.

**Features:**
- **Audit Timeline** — Track milestones, deadlines, and deliverables
- **Auditor Portal** — Secure, time-limited access for external auditors
- **Evidence Sharing** — Package and share evidence directly with auditors
- **Finding Tracker** — Log auditor findings and track remediation
- **Readiness Score** — % complete before audit starts
- **Pre-audit Self-Assessment** — Internal review before formal audit
- **Audit Report Storage** — Centralize all audit reports and certificates

### 9.10 Trust Center (Phase 2)

**Purpose:** Proactively demonstrate compliance status to customers and prospects.

**Features:**
- **Public-Facing Page** — Custom-branded security profile
- **Real-time Badges** — Live compliance status (SOC 2, ISO 27001, etc.)
- **Document Sharing** — Share SOC 2 reports, pen tests under NDA
- **Self-Service Questionnaires** — Customers answer questions from EVI's data
- **NDA Workflow** — Digital NDA signing before accessing sensitive docs
- **Analytics** — Track who views the Trust Center and what they download
- **Custom Branding** — EVI logo, colors, and messaging

**Impact:** Reduce security questionnaire volume by 30-50% through proactive disclosure.

### 9.11 Export Center

**Purpose:** Generate customer-ready and internal reports in multiple formats.

**Export Formats:**
- Markdown — Clean, version-control-friendly format
- Excel — Customer submission format
- PDF — Formal document with cover page and table of contents
- SQL — Database dump for technical stakeholders
- Customer Response Package — Bundled export with cover letter
- Evidence Index — Catalog of supporting evidence
- Gap Report — List of identified gaps with remediation plans
- Executive Summary — CISO/board-ready one-pager

**Export Controls:**
- Exclude internal notes
- Exclude draft answers
- Exclude confidential evidence
- Exclude risk commentary
- Exclude unapproved AI-generated text
- Watermark with recipient name and date

### 9.12 Integrations Hub (Phase 3)

**Purpose:** Automate evidence collection and control monitoring.

**Planned Integrations:**
- **Cloud Providers** — AWS, Azure, GCP (pull IAM policies, encryption status, CloudTrail logs)
- **Version Control** — GitHub, GitLab (pull repository settings, branch protection rules)
- **Identity Providers** — Microsoft Entra ID, Okta (pull user access lists, MFA status)
- **Ticketing** — Jira, Azure DevOps (create remediation tickets)
- **Vulnerability Scanners** — Dependabot, Snyk, Qualys (pull scan results)
- **Communication** — Slack, Teams (alert notifications)
- **Document Storage** — SharePoint, OneDrive (sync evidence documents)

---

## 10. Compliance Frameworks

### Supported Frameworks (Roadmap)

| Framework | Phase | Notes |
|---|---|---|
| **SOC 2** | 1 | Trust Services Criteria — most requested by K-12 customers |
| **NY Ed Law 2-d** | 1 | New York education data privacy — core to EVI market |
| **FERPA** | 1 | Federal student privacy — required for all education vendors |
| **NIST CSF** | 1 | Cybersecurity Framework — widely recognized |
| **CIS Controls** | 1 | Center for Internet Security — actionable security controls |
| **CoSN K-12** | 1 | K-12 vendor assessment — direct customer requirement |
| **ISO 27001** | 2 | International security standard — expands market reach |
| **GDPR** | 2 | EU data protection — required for any EU customers |
| **HIPAA / HITRUST** | 3 | Healthcare data — if EVI serves healthcare-education hybrid |
| **PCI DSS** | 3 | Payment card industry — if EVI processes payments |
| **FedRAMP** | 3 | Federal government cloud — high-value contracts |
| **CMMC** | 3 | DoD cybersecurity maturity — defense-related education |
| **Custom Frameworks** | 3 | Customer-specific or internally defined frameworks |

### Framework Cross-Mapping

A single control can satisfy multiple frameworks. Example:

| Control | SOC 2 | ISO 27001 | NY Ed Law 2-d | NIST CSF |
|---|---|---|---|---|
| Encryption at Rest | CC6.1 | A.10.1.2 | 2-d(3) | PR.DS-1 |
| Access Control | CC6.2 | A.9.1.1 | 2-d(4) | PR.AC-1 |
| Incident Response | CC7.3 | A.16.1.1 | 2-d(7) | RS.RP-1 |

---

## 11. User Experience Direction

### Design Principles

1. **Dark Mode First** — Professional cybersecurity aesthetic
2. **Card-Based Layout** — Clean, scannable information hierarchy
3. **Search-First Workflow** — Global search bar accessible from any page
4. **Contextual AI Panel** — Right-side panel for AnswerForge suggestions
5. **Status at a Glance** — Color-coded indicators (Green/Yellow/Red)
6. **Minimal Clutter** — Progressive disclosure of advanced features
7. **Control Room Feel** — Dashboard-centric, monitoring-oriented

### Navigation Structure

```
ControlDeck
├── Dashboard
├── Assessments
│   ├── All Assessments
│   ├── Mount Pleasant CSD Vendor Assessment
│   └── Create New Assessment
├── Questionnaire Library
│   ├── All Questions
│   ├── Categories
│   └── Framework Mapping
├── Answer Library
│   ├── All Templates
│   ├── Pending Approval
│   └── Usage Analytics
├── Evidence Vault
│   ├── All Evidence
│   ├── Expiring Soon
│   └── Upload
├── Risk & Remediation
│   ├── Risk Register
│   ├── Heat Map
│   └── Remediation Tracker
├── Trust Center (Phase 2)
│   ├── Public Page Settings
│   ├── Shared Documents
│   └── Visitor Analytics
├── Audit Manager (Phase 2)
│   ├── Active Audits
│   ├── Auditor Portal
│   └── Findings
├── Policy Manager (Phase 2)
│   ├── All Policies
│   ├── Pending Acknowledgments
│   └── Templates
├── Export Center
│   ├── Quick Export
│   ├── Scheduled Exports
│   └── Templates
├── Reports & Analytics
│   ├── Executive Summary
│   ├── Program Health
│   ├── Trend Analysis
│   └── Custom Reports
└── Admin
    ├── Users & Roles
    ├── Categories
    ├── Frameworks
    ├── Integrations
    ├── Audit Logs
    └── Settings
```

---

## 12. Technology Stack

### Frontend

- **Framework:** Next.js 15 (React 19, App Router)
- **Language:** TypeScript 5.x
- **Styling:** Tailwind CSS 4.x
- **UI Components:** shadcn/ui
- **Icons:** lucide-react
- **Charts:** Recharts
- **State Management:** Zustand or React Query
- **Forms:** React Hook Form + Zod validation

### Backend

- **Framework:** ASP.NET Core 8 Web API
- **ORM:** Entity Framework Core
- **Database:** Microsoft SQL Server 2022
- **Migrations:** EF Core Migrations
- **Authentication:** Microsoft Entra ID (Azure AD) + OAuth 2.0 / OpenID Connect
- **Authorization:** Role-based access control (RBAC) + Policy-based authorization
- **API Documentation:** Swagger / OpenAPI

### AI Layer

- **Architecture:** Backend-for-Frontend (BFF) pattern
- **LLM Providers:** OpenAI GPT-4o, Anthropic Claude 3.5 Sonnet (via OpenRouter for flexibility)
- **RAG Pipeline:** Azure AI Search or local vector store (pgvector) for answer library retrieval
- **Prompt Management:** Version-controlled prompt templates in codebase
- **Guardrails:** Backend validation of all AI outputs; no direct DB access

### Infrastructure

- **Hosting:** Azure App Service or on-premises Windows Server + IIS
- **Database:** Azure SQL Database or on-premises SQL Server
- **File Storage:** Azure Blob Storage or SharePoint integration
- **CI/CD:** GitHub Actions or Azure DevOps
- **Monitoring:** Application Insights

---

## 13. Security Requirements

### Application Security

- [ ] Authentication required for all endpoints
- [ ] MFA enforced via Microsoft Entra ID
- [ ] Role-based access control (Admin, Editor, Reviewer, Viewer, Auditor)
- [ ] Audit logging for all sensitive changes (answers, evidence, policies, risks)
- [ ] Soft delete with change history for all core entities
- [ ] Separation of internal notes from exportable answers
- [ ] Evidence confidentiality labels enforced in exports
- [ ] No direct public access to internal data
- [ ] Database backups with point-in-time recovery
- [ ] Least-privilege service accounts
- [ ] No AI tools with direct write access to production database
- [ ] No production secrets in frontend code
- [ ] Input validation and parameterized queries (SQL injection prevention)
- [ ] XSS and CSRF protection
- [ ] Rate limiting on API endpoints
- [ ] Encryption at rest (TDE) and in transit (TLS 1.3)

### Data Classification

| Level | Description | Examples |
|---|---|---|
| **Public** | Safe to share with anyone | Company website, general product info |
| **Customer-shareable under NDA** | Share after NDA signed | SOC 2 report, pen test summaries |
| **Internal** | EVI employees only | Most questionnaire answers, policies |
| **Confidential** | Limited internal audience | Incident details, vulnerability findings |
| **Restricted** | Executive / legal only | Legal opinions, active incident response |

---

## 14. Success Metrics

### MVP Success Criteria (Phase 1)

- [ ] Open the Mount Pleasant CSD assessment in the app
- [ ] View all categories and questions with answers
- [ ] Search for any security topic across all assessments
- [ ] Edit and preserve answers with audit trail
- [ ] Export a clean customer-ready response file (Excel/Markdown)
- [ ] Track which answers need review
- [ ] Identify missing policies or documentation gaps
- [ ] Reuse approved answers in future questionnaires
- [ ] Upload and link evidence to responses
- [ ] Basic risk/gap tracking

### Phase 2 Success Criteria

- [ ] AI Answer Assistant drafts answers with > 70% acceptance rate
- [ ] Answer Library contains > 50 approved templates
- [ ] Evidence Vault contains all critical compliance documents
- [ ] Risk Register tracks all identified gaps with owners and due dates
- [ ] Trust Center is live and reduces incoming questionnaire volume by 30%
- [ ] Audit Manager streamlines external audit prep by 50%
- [ ] Policy Manager tracks acknowledgment for all required policies

### Phase 3+ Success Criteria

- [ ] Framework mapping across SOC 2, ISO 27001, NY Ed Law 2-d
- [ ] Integrations with AWS, GitHub, and Microsoft Entra ID
- [ ] Automated evidence collection for 5+ controls
- [ ] Vendor Risk Management tracks all critical third parties
- [ ] Executive dashboard shows real-time compliance posture
- [ ] Average questionnaire response time < 2 hours

---

## 15. Feature Roadmap

### Phase 1: Foundation (Months 1-3) — MVP

**Goal:** Make the current questionnaire usable in an application.

**Features:**
- [ ] Import normalized SQL schema
- [ ] Assessment viewer and editor
- [ ] Category and question management
- [ ] Basic search and filtering
- [ ] Header/general information storage
- [ ] Answer Library (basic templates)
- [ ] Evidence Vault (upload and link)
- [ ] Export to Markdown and Excel
- [ ] Basic dashboard
- [ ] Review status tracking
- [ ] Risk/gap tracking (basic)
- [ ] User authentication (Microsoft Entra ID)
- [ ] Role-based access control
- [ ] Audit logging

**Out of Scope:**
- Full AI answer generation
- Full document management
- Customer portal / Trust Center
- Automated questionnaire ingestion
- Workflow approvals
- Advanced risk scoring
- Multi-tenant external access

### Phase 2: Intelligence (Months 4-6)

**Goal:** Add AI assistance, audit support, and proactive trust demonstration.

**Features:**
- [ ] AI Answer Assistant (AnswerForge) — draft, shorten, rewrite, compare
- [ ] Answer Library with approval workflow and version history
- [ ] Evidence Vault with expiration alerts and watermarking
- [ ] Risk & Remediation Tracker with heat map and scoring
- [ ] Policy Manager with templates and acknowledgment tracking
- [ ] Audit Manager with auditor portal and finding tracker
- [ ] Trust Center (public-facing compliance showcase)
- [ ] Questionnaire Import (parse customer Excel files)
- [ ] Compare two assessments side-by-side
- [ ] Question similarity detection
- [ ] PDF export with professional formatting
- [ ] Executive summary export
- [ ] Scheduled report generation

### Phase 3: Scale (Months 7-9)

**Goal:** Map compliance frameworks and automate evidence collection.

**Features:**
- [ ] Framework management (SOC 2, ISO 27001, NY Ed Law 2-d, etc.)
- [ ] Control library with cross-framework mapping
- [ ] Control maturity scoring
- [ ] Automated import from Excel questionnaires
- [ ] AI mapping of questions to existing controls
- [ ] Integration Hub (AWS, Azure, GitHub, Microsoft Entra ID)
- [ ] Automated evidence collection from integrations
- [ ] Third-Party Risk Management (vendor onboarding, assessment, scoring)
- [ ] Vulnerability management integration
- [ ] Custom report builder
- [ ] API for external integrations
- [ ] Webhook support for event notifications

### Phase 4: Enterprise (Months 10-12+)

**Goal:** Continuous monitoring and enterprise-grade capabilities.

**Features:**
- [ ] Continuous control monitoring with automated tests
- [ ] Real-time compliance drift detection and alerts
- [ ] AI Agent for autonomous compliance monitoring
- [ ] Advanced analytics and benchmarking
- [ ] Multi-workspace support (multiple business units)
- [ ] Custom fields and workflow automation
- [ ] SCIM provisioning for automated user management
- [ ] Advanced SSO/SAML support
- [ ] Data retention policies
- [ ] Disaster recovery and high availability

---

## 16. Open Questions & Decisions

| # | Question | Status | Recommendation |
|---|---|---|---|
| 1 | Product name: AnswerForge vs. ControlDeck vs. TrustDesk? | **Resolved** | Use **ControlDeck** for the platform, **AnswerForge** for the AI module |
| 2 | Purely internal or eventually customer-facing? | **Pending** | Start internal-only; Trust Center in Phase 2 is customer-facing |
| 3 | Evidence storage: SQL Server, file storage, SharePoint? | **Pending** | Azure Blob Storage with SQL metadata; optional SharePoint sync |
| 4 | Who approves externally shareable answers? | **Pending** | CISO or designated security officer; workflow enforced in app |
| 5 | Should legal review be required for some categories? | **Pending** | Yes — flag legal-review-required categories in config |
| 6 | Should all questionnaire exports require approval? | **Pending** | Yes for first export per assessment; auto-approve subsequent |
| 7 | Integrate with Microsoft Entra ID? | **Resolved** | Yes — primary authentication method |
| 8 | Should AI see internal notes? | **Resolved** | No — AI only sees approved external answers and evidence |
| 9 | Separate storage for AI-generated vs. human answers? | **Resolved** | Yes — `ai_suggested` flag on responses; human approval required |
| 10 | Official review cycle for answers and evidence? | **Pending** | Annual review default; configurable per evidence type |
| 11 | Should we support custom frameworks beyond the list? | **Pending** | Yes — Phase 3 custom framework builder |
| 12 | Should the Trust Center require NDA before doc access? | **Pending** | Yes — digital NDA workflow integrated |

---

## 17. Risks & Mitigations

| Risk | Impact | Likelihood | Mitigation |
|---|---|---|---|
| **AI generates inaccurate answers** | High | Medium | Human-in-the-loop approval required; AI only uses approved data |
| **Sensitive data exposure in exports** | High | Low | Confidentiality labels enforced; export preview before download |
| **User adoption resistance** | Medium | Medium | Intuitive UX; training materials; demonstrate time savings |
| **Integration complexity** | Medium | Medium | Start with Microsoft stack; phased integration approach |
| **Scope creep to full GRC** | Medium | High | Strict phase gates; regular stakeholder alignment |
| **Data migration from spreadsheets** | Low | High | Automated import tools; manual validation workflow |
| **Performance with large assessments** | Low | Medium | Pagination; search indexing; query optimization |
| **Auditor portal security** | High | Low | Time-limited access; read-only permissions; audit logging |

---

## 18. Appendices

### Appendix A: Data Import Notes

Suggested database fields for normalized import: `category`, `control_id`, `question`, `vendor_answer`, `additional_information`, `source_questionnaire`, `last_reviewed`, `review_owner`, `notes`.

See `create_cyber_questionnaire_normalized.sql` for the complete import script.

### Appendix B: Vanta Competitive Analysis Summary

Your current PRD covers approximately 30-40% of Vanta's feature set. The biggest gaps are:

1. **Automated Compliance & 400+ Integrations** — Auto-pull evidence from cloud, GitHub, Okta, etc.
2. **Trust Center** — Public-facing compliance showcase that accelerates sales
3. **Audit Management** — Auditor portal and streamlined audit prep
4. **Policy Management** — Templates, distribution, and acknowledgment tracking
5. **Continuous GRC** — Real-time control monitoring, not point-in-time
6. **Personnel & Access Reviews** — Periodic access certifications
7. **Risk Register** — Formal risk management with heat maps and scoring
8. **Vendor Risk Management** — Assess third-party vendors, not just respond to questionnaires

This PRD now incorporates the highest-value Vanta features into EVI's phased roadmap.

### Appendix C: Glossary

| Term | Definition |
|---|---|
| **Assessment** | A customer-specific questionnaire or security review instance |
| **AnswerForge** | The AI-assisted answer drafting module inside ControlDeck |
| **Control** | A specific security requirement within a compliance framework |
| **ControlDeck** | The main application platform for compliance and questionnaire management |
| **Evidence** | A document or artifact supporting a compliance claim |
| **Framework** | A compliance standard or regulation (e.g., SOC 2, ISO 27001) |
| **GRC** | Governance, Risk, and Compliance |
| **RAG** | Retrieval-Augmented Generation (AI technique) |
| **Risk Flag** | A marker indicating a potential security gap |
| **Trust Center** | A public-facing page demonstrating compliance status |

---

*Document Version: 2.0*
*Last Updated: 2026-04-30*
*Prepared for: Educational Vistas, Inc.*
