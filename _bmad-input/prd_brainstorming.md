# PRD Brainstorming: Security Questionnaire & Compliance Response Platform

**Working document:** prd_brainstorming.md  
**Status:** Brainstorming / early product definition  
**Audience:** Educational Vistas internal IT, security, compliance, leadership, and product stakeholders  
**Prepared for:** Educational Vistas, Inc.

---

## 1. Working Product Names

The product should feel professional, trustworthy, and modern, while still having a light “AI-powered” identity.

### Top Name Candidates

| Name | Positioning | Notes |
|---|---|---|
| **AnswerForge** | AI-assisted answer generation and questionnaire response management | Strongest “AI productivity” feel. Suggests creating polished, reusable answers. |
| **ControlDeck** | Security controls, compliance status, and evidence dashboard | Strongest cybersecurity/control-room feel. Good for a dashboard-driven application. |
| **TrustDesk** | Vendor trust, compliance requests, questionnaires, and evidence management | Strongest customer-facing/vendor trust feel. Sounds approachable and support-oriented. |

### Current Recommendation

**Best overall:** `AnswerForge`  
**Best AI/productivity name:** `ControlDeck`  
**Best trust/compliance name:** `TrustDesk`

A strong naming approach could be:

> **ControlDeck**  
> with an AI module called **AnswerForge**

Example:

> **ControlDeck** is the internal security questionnaire and compliance response platform.  
> **AnswerForge** is the AI-assisted answer drafting engine inside ControlDeck.

This gives the application a serious compliance/security identity while still giving the AI feature a memorable name.

---

## 2. Product Vision

Build an internal application that centralizes cybersecurity questionnaire responses, vendor security answers, compliance evidence, assessment history, and reusable security language.

The platform should make it easy for Educational Vistas to answer future vendor/security questionnaires faster, more consistently, and with better accuracy.

The application should also help identify weak areas in the organization’s security/compliance maturity, such as missing formal policies, plans, review cycles, or third-party testing.

---

## 3. Problem Statement

Educational Vistas receives vendor security questionnaires from school districts and other education customers. These questionnaires often contain repeated or similar questions about cybersecurity, privacy, business continuity, disaster recovery, access controls, encryption, datacenter security, vulnerability management, and compliance.

Currently, answering these questionnaires requires manual effort, institutional memory, and one-off drafting. This creates several problems:

- Answers can be inconsistent across questionnaires.
- Security gaps are discovered during questionnaire completion instead of being tracked centrally.
- Evidence documents are not always linked directly to the answers they support.
- General company information, questionnaire questions, categories, and responses are mixed together.
- Future application development requires a better relational database model.
- AI assistance could help draft answers, but should be grounded in approved internal data.

---

## 4. Goals

The platform should:

1. Store all questionnaire questions, categories, answers, and supporting notes in a normalized database.
2. Separate general vendor/header information from individual questionnaire responses.
3. Maintain reusable standard answers for common security questions.
4. Track which answers are approved, draft, outdated, or need review.
5. Provide a searchable interface for prior questions and responses.
6. Support future AI-assisted answer drafting.
7. Track evidence documents, such as SOC 2 reports, Incident Response Plans, Disaster Recovery Plans, policies, diagrams, and assessment results.
8. Show readiness/completion status by category.
9. Allow exporting responses to Markdown, Excel, SQL, PDF, or customer-specific formats.
10. Help identify gaps where EVI lacks formal documentation or needs remediation.

---

## 5. Non-Goals for Initial Version

The first version should not attempt to become a full GRC platform.

Initial non-goals:

- No direct production customer data access.
- No automated submission into third-party questionnaire portals.
- No direct write access to production SQL Server from AI tools.
- No replacement for legal review.
- No replacement for formal cybersecurity audits.
- No autonomous AI approval of questionnaire answers.
- No storage of customer PII unless explicitly required and approved.

---

## 6. Primary Users

### IT / Security Administrator

Responsible for maintaining answers, evidence, technical accuracy, and security posture.

Needs:

- Fast search across prior answers.
- Ability to update responses.
- Ability to flag questions needing review.
- Ability to attach or reference evidence.
- Ability to identify missing controls or policy gaps.

### Executive / Leadership Reviewer

Responsible for reviewing risk exposure and approving sensitive answers.

Needs:

- High-level dashboard.
- Open risks/gaps.
- Questionnaire completion status.
- Recently changed answers.
- Items requiring executive/legal review.

### Sales / Account Management

Responsible for responding to customer security requests.

Needs:

- Approved answer library.
- Export-ready responses.
- Customer-specific questionnaire records.
- Clear indication of what can be shared externally.

### Product / Development Team

Responsible for technical remediation and application security improvements.

Needs:

- Vulnerability-related question tracking.
- Remediation notes.
- Product-specific security answers.
- Application-specific gaps.

---

## 7. Core Concepts

### Assessment

A customer-specific questionnaire or security review.

Example:

- Mount Pleasant CSD Vendor Assessment
- CoSN K-12 Vendor Assessment Lite
- NY Ed Law 2-d Security Review

### Category

A questionnaire section.

Examples:

- Documentation
- Company Overview
- Application / Service Security
- Authentication, Authorization, and Accounting
- Business Continuity
- Change Management
- Data
- Database
- Datacenter
- Disaster Recovery
- Firewall / Intrusion Detection
- Physical Security
- Policies, Procedures, and Processes
- Systems Management and Configuration
- Vulnerability Scan

### Question

A specific control/question from the questionnaire.

Example:

- `HLAP-01`: Does your system support various permission levels, for example role-based access control, for end users?

### Response

EVI’s answer to a question for a specific assessment.

Fields may include:

- Vendor answer
- Additional information
- Internal notes
- Review status
- Evidence links
- Last reviewed date
- Approved by
- Risk/gap flag

### Evidence

A document, link, or artifact supporting an answer.

Examples:

- SOC 2 Type II report from hosting provider
- Incident Response Plan
- Disaster Recovery Plan
- Network diagram
- Vulnerability scan summary
- Security policy
- Backup procedure
- Datacenter security documentation

---

## 8. Proposed Database Model

Existing proposed tables:

- `cyber_assessments`
- `cyber_headers`
- `cyber_categories`
- `cyber_questions`
- `cyber_responses`

Recommended future tables:

- `cyber_evidence`
- `cyber_response_evidence`
- `cyber_answer_library`
- `cyber_risks`
- `cyber_review_history`
- `cyber_products`
- `cyber_customers`
- `cyber_users`
- `cyber_tags`

### Suggested Table Responsibilities

#### `cyber_assessments`

Stores questionnaire/customer assessment metadata.

Example fields:

- `assessment_id`
- `assessment_name`
- `customer_name`
- `source_questionnaire`
- `assessment_date`
- `review_date`
- `status`
- `created_at`
- `updated_at`

#### `cyber_headers`

Stores general vendor/header fields that do not belong in the question table.

Example fields:

- `header_id`
- `assessment_id`
- `field_code`
- `field_name`
- `field_value`
- `additional_information`

#### `cyber_categories`

Stores section/category names.

Example fields:

- `category_id`
- `category_name`
- `category_description`
- `display_order`

#### `cyber_questions`

Stores the master list of questionnaire questions.

Example fields:

- `question_id`
- `category_id`
- `control_id`
- `question_text`
- `guidance_text`
- `answer_type`
- `display_order`
- `is_active`

#### `cyber_responses`

Stores assessment-specific answers.

Example fields:

- `response_id`
- `assessment_id`
- `question_id`
- `vendor_answer`
- `additional_information`
- `internal_notes`
- `status`
- `risk_flag`
- `last_reviewed_date`
- `approved_by`
- `created_at`
- `updated_at`

#### `cyber_evidence`

Stores reusable evidence records.

Example fields:

- `evidence_id`
- `evidence_name`
- `evidence_type`
- `description`
- `file_path_or_url`
- `confidentiality_level`
- `owner`
- `review_date`
- `expiration_date`
- `created_at`
- `updated_at`

#### `cyber_response_evidence`

Many-to-many relationship between answers and evidence.

Example fields:

- `response_id`
- `evidence_id`

#### `cyber_answer_library`

Stores reusable approved answer templates.

Example fields:

- `answer_template_id`
- `category_id`
- `topic`
- `standard_answer`
- `approved_external_answer`
- `internal_notes`
- `status`
- `last_reviewed_date`

#### `cyber_risks`

Tracks gaps discovered during questionnaires.

Example fields:

- `risk_id`
- `assessment_id`
- `question_id`
- `risk_title`
- `risk_description`
- `severity`
- `owner`
- `target_date`
- `status`
- `remediation_notes`

---

## 9. Recommended Application Features

### 9.1 Dashboard

The dashboard should show:

- Total assessments
- Open assessments
- Questions answered
- Questions needing review
- Gaps by severity
- Recently updated answers
- Evidence nearing expiration
- Categories with weak maturity

Example dashboard cards:

- “92% Complete”
- “6 Answers Need Review”
- “3 Policy Gaps”
- “2 Evidence Documents Expiring Soon”
- “Last Updated: Today”

### 9.2 Questionnaire Viewer

A structured view of an assessment.

Features:

- Left sidebar category navigation
- Control ID search
- Keyword search
- Filter by answer: Yes / No / N/A / Partially
- Filter by status: Draft / Approved / Needs Review
- Expandable question cards
- Inline editing
- Evidence attachment area
- Internal notes hidden from export

### 9.3 Answer Library

Reusable approved answers for common topics.

Examples:

- Encryption at rest
- Encryption in transit
- Role-based access control
- Tenant segmentation
- Incident response
- Disaster recovery
- Firewall controls
- Physical security
- Vulnerability remediation
- NY Ed Law 2-d

### 9.4 Evidence Vault

Central document library for compliance artifacts.

Evidence examples:

- SOC 2 report
- Incident Response Plan
- Disaster Recovery Plan
- Parent Bill of Rights language
- Vulnerability scan summary
- Datacenter controls summary
- Network segmentation description
- Firewall architecture notes

Evidence records should support:

- Confidential / internal / shareable classification
- Expiration or review date
- Owner
- Related categories
- Linked responses

### 9.5 AI Answer Assistant

The AI assistant should help draft responses, but only from trusted internal data.

Possible AI actions:

- Draft a concise answer.
- Rewrite answer to fit a small questionnaire box.
- Convert technical answer to customer-friendly language.
- Compare new question to past questions.
- Suggest related evidence.
- Flag risky wording.
- Identify whether the current answer overclaims.
- Generate a gap/remediation item from a “No” answer.

Important rule:

> AI should suggest. Humans approve.

### 9.6 Export Center

Supported exports:

- Markdown
- Excel
- SQL
- PDF
- Customer response package
- Evidence index
- Gap report
- Executive summary

Exports should allow excluding:

- Internal notes
- Draft answers
- Confidential evidence
- Risk commentary
- Unapproved AI-generated text

---

## 10. AI Vibe / User Experience Direction

The application should feel like a modern cybersecurity command center, but not gimmicky.

Recommended visual direction:

- Dark mode first
- Clean card-based layout
- Subtle glow accents
- Category status indicators
- Search-first workflow
- AI assistant panel on the right
- Strong typography
- Minimal clutter
- “Control room” feel

Possible design language:

- Cybersecurity dashboard
- Compliance cockpit
- Vendor trust workspace
- Evidence command center

Suggested UI modules:

- **Assessment Builder**
- **Questionnaire Library**
- **Control Matrix**
- **Evidence Vault**
- **AI Answer Assistant**
- **Risk & Remediation Tracker**
- **Export Center**

---

## 11. Recommended Technology Stack

### Frontend

Recommended:

- React
- Next.js
- TypeScript
- Tailwind CSS
- shadcn/ui
- lucide-react icons
- Recharts for dashboards

### Backend

Recommended options:

Option A:

- ASP.NET Core Web API
- Entity Framework Core
- SQL Server

Option B:

- Node.js / Express or NestJS
- Prisma or Knex
- SQL Server

Given EVI’s Microsoft SQL Server environment, ASP.NET Core would be a strong enterprise-friendly choice.

### Database

- Microsoft SQL Server
- Normalized relational schema
- Indexed foreign keys
- Migration scripts
- Read-only reporting views

### AI Layer

AI should sit behind the backend API.

Recommended model-provider approach:

- OpenAI API, Anthropic Claude API, or OpenRouter
- Backend-controlled prompts
- No direct database credentials exposed to AI tools
- No production secrets in prompts
- Retrieval limited to approved internal records

### Authentication

Recommended:

- Microsoft Entra ID / SSO
- Role-based access control
- Admin, Editor, Reviewer, Viewer roles
- Audit logging for sensitive changes

---

## 12. Security Requirements

Because the app stores security questionnaire answers and internal security posture details, it should be treated as sensitive.

Requirements:

- Authentication required
- MFA through SSO where possible
- Role-based access
- Audit logs for answer changes
- Soft delete or change history for responses
- Separation of internal notes from exportable answers
- Evidence confidentiality labels
- No direct public access
- Database backups
- Least-privilege service accounts
- No AI tools with direct write access to production
- No production secrets in frontend code

---

## 13. MVP Scope

The MVP should focus on making the current questionnaire usable in an application.

### MVP Features

- Import normalized SQL schema
- View assessments
- View categories
- View questions and answers
- Edit answers
- Search questions
- Filter by category and answer
- Store general header info separately
- Export Markdown
- Export Excel
- Basic dashboard
- Basic evidence link field
- Review status field

### MVP Exclusions

- Full AI answer generation
- Full document management
- Customer portal
- Automated questionnaire ingestion
- Workflow approvals
- Advanced risk scoring
- Multi-tenant external access

---

## 14. Version 2 Features

- AI-assisted answer drafting
- Evidence Vault
- Answer Library
- Risk and remediation tracking
- Review and approval workflow
- Compare two assessments
- Suggested answer matching from prior questionnaires
- Question similarity detection
- Expiring evidence alerts
- Policy gap dashboard
- PDF export
- Executive summary export

---

## 15. Version 3 Features

- Customer-specific response packages
- Automated import from Excel questionnaires
- AI mapping of questions to existing controls
- Control maturity scoring
- Integration with ticketing/project management
- Integration with vulnerability scan results
- Integration with document storage
- Compliance framework mapping:
  - NY Ed Law 2-d
  - FERPA
  - NIST CSF
  - CIS Controls
  - SOC 2 Trust Services Criteria
  - CoSN K-12 Vendor Assessment

---

## 16. Example Application Navigation

```text
ControlDeck
├── Dashboard
├── Assessments
│   ├── Mount Pleasant CSD Vendor Assessment
│   └── Future Assessments
├── Questionnaire Library
├── Answer Library
├── Evidence Vault
├── Risk & Remediation
├── Export Center
├── Reports
└── Admin
    ├── Categories
    ├── Users
    ├── Products
    └── Settings
```

---

## 17. Example Status Values

### Response Status

- Draft
- Needs Review
- Approved
- Needs Evidence
- Outdated
- Do Not Use

### Evidence Confidentiality

- Public
- Customer-shareable under NDA
- Internal only
- Confidential
- Restricted

### Risk Severity

- Critical
- High
- Medium
- Low
- Informational

---

## 18. Key Design Principle

The system should separate:

- What we tell customers
- What we know internally
- What evidence supports the answer
- What needs improvement

This distinction is critical.

An answer may be safe to share externally, while the internal notes may explain limitations, gaps, or remediation plans.

---

## 19. Example AI Assistant Prompts

### Draft Answer

> Draft a concise vendor questionnaire answer using only approved answer library content and linked evidence. Keep the answer under 500 characters.

### Shorten Answer

> Shorten this answer to fit in a small Excel cell while preserving accuracy and avoiding overclaiming.

### Risk Review

> Review this answer and identify whether it overclaims, reveals too much infrastructure detail, or conflicts with existing approved responses.

### Evidence Suggestion

> Suggest evidence records that support this answer.

### Gap Detection

> This answer is “No.” Create a remediation item with severity, owner suggestion, and recommended next steps.

---

## 20. Open Questions

1. Which product name should be selected: AnswerForge, ControlDeck, or TrustDesk?
2. Should this be purely internal, or eventually customer-facing?
3. Should evidence files be stored in SQL Server, file storage, SharePoint, Nextcloud, or another document repository?
4. Who approves externally shareable answers?
5. Should legal review be required for some categories?
6. Should all questionnaire exports require approval?
7. Should this app integrate with Microsoft Entra ID?
8. Should the AI assistant be allowed to see internal notes?
9. Should AI-generated answers be stored separately from approved human-authored answers?
10. What is the official review cycle for answers and evidence?

---

## 21. Recommended Next Step

Start with **ControlDeck** as the application name and define **AnswerForge** as the AI answer assistant module.

Recommended product framing:

> **ControlDeck** is an internal cybersecurity questionnaire and compliance response platform for managing assessments, answers, evidence, risks, and exports.  
> **AnswerForge** is the AI assistant inside ControlDeck that helps draft, refine, and validate questionnaire responses using approved internal data.

---

## 22. Initial Success Criteria

The first version is successful if EVI can:

- Open the Mount Pleasant CSD assessment in the app.
- View all categories and questions.
- Search for any security topic.
- Edit and preserve answers.
- Export a clean response file.
- Track which answers need review.
- Identify missing policies or documentation gaps.
- Reuse approved answers in future questionnaires.

---

## 23. Long-Term Vision

The platform can eventually become an internal security knowledge base and compliance operations tool.

Long-term, it could support:

- Security questionnaires
- Vendor assessments
- Compliance audits
- Evidence management
- Risk tracking
- Policy review
- AI-assisted response generation
- Executive cybersecurity readiness reporting

The end goal is to reduce questionnaire response time, improve answer consistency, and give Educational Vistas a clearer view of its cybersecurity and compliance maturity.
