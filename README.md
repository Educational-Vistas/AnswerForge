# AnswerForge

> AI-assisted cybersecurity questionnaire and compliance response platform for Educational Vistas, Inc.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

---

## What is AnswerForge?

AnswerForge is an internal application that centralizes cybersecurity questionnaire responses, vendor security answers, compliance evidence, assessment history, and reusable security language for Educational Vistas, Inc.

It helps EVI answer future vendor/security questionnaires **faster, more consistently, and with better accuracy** — while identifying weak areas in the organization's security and compliance maturity.

### Key Capabilities

- **Assessment Management** — Store and manage customer security questionnaires
- **Answer Library** — Reusable approved answers for common security topics
- **Evidence Vault** — Central document library for compliance artifacts
- **AI Answer Assistant** — Draft responses grounded in approved internal data
- **Risk & Gap Tracking** — Identify missing policies, plans, or controls
- **Export Center** — Generate customer-ready responses in multiple formats

---

## Quick Start

### Prerequisites

- Python 3.10+
- Node.js 18+
- Microsoft SQL Server (or Azure SQL Database)
- Git

### Installation

```bash
# Clone the repository
git clone https://github.com/Educational-Vistas/AnswerForge.git
cd AnswerForge

# Backend setup
cd backend

# Create virtual environment (recommended)
python -m venv venv

# Activate virtual environment
# Windows:
venv\Scripts\activate
# macOS/Linux:
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Configure environment
cp .env.example .env
# Edit .env with your database credentials

# Start the backend API
python -m uvicorn main:app --reload --port 8000
```

The API will be available at `http://localhost:8000`.

**View interactive API documentation:**
- Swagger UI: http://localhost:8000/docs
- ReDoc: http://localhost:8000/redoc

---

## Project Structure

```
AnswerForge/
├── backend/                    # ASP.NET Core / Python FastAPI backend
│   ├── api/                    # API routes and controllers
│   ├── models/                 # Database models and schemas
│   ├── services/               # Business logic and AI integration
│   ├── scripts/                # Database setup and migration scripts
│   └── tests/                  # Backend unit and integration tests
├── frontend/                   # Next.js React frontend
│   ├── app/                    # Next.js App Router pages
│   ├── components/             # Reusable UI components
│   ├── hooks/                  # Custom React hooks
│   ├── lib/                    # Utility functions and API clients
│   └── tests/                  # Frontend tests
├── database/                   # SQL scripts and migrations
│   ├── schema/                 # Table creation scripts
│   ├── migrations/             # Versioned migrations
│   └── seeds/                  # Initial data imports
├── docs/                       # Documentation
│   ├── PRD.md                  # Product Requirements Document
│   ├── ARCHITECTURE.md         # System architecture
│   └── API.md                  # API documentation
├── scripts/                    # Utility scripts
├── .github/                    # GitHub Actions CI/CD
├── README.md                   # This file
└── LICENSE                     # MIT License
```

---

## Technology Stack

### Backend
- **Framework:** Python FastAPI (or ASP.NET Core Web API)
- **ORM:** SQLAlchemy (or Entity Framework Core)
- **Database:** Microsoft SQL Server
- **Authentication:** Microsoft Entra ID (Azure AD)
- **AI Integration:** OpenAI API / Anthropic Claude via OpenRouter

### Frontend
- **Framework:** Next.js 15 (React 19)
- **Language:** TypeScript
- **Styling:** Tailwind CSS
- **UI Components:** shadcn/ui
- **State Management:** Zustand / React Query

### Infrastructure
- **Hosting:** On-premises Windows Server + IIS (or Azure App Service if preferred)
- **File Storage:** Local file system (or Azure Blob Storage if preferred)
- **CI/CD:** GitHub Actions

---

## Features

### Core Features (MVP)

- [x] **Assessment Viewer** — View and edit customer questionnaires
- [x] **Category Navigation** — Browse questions by section
- [x] **Search & Filter** — Find questions by keyword, control ID, or answer
- [x] **Answer Status Tracking** — Draft, Approved, Needs Review, Outdated
- [x] **Answer Library** — Reusable approved templates
- [x] **Evidence Vault** — Upload and link compliance documents
- [x] **Export Center** — Markdown, Excel, PDF exports
- [x] **Risk/Gap Flagging** — Track missing policies or controls
- [x] **Dashboard** — Program health overview

### Phase 2 Features

- [ ] **AI Answer Assistant** — Draft, shorten, and refine responses
- [ ] **Questionnaire Import** — Parse customer Excel files
- [ ] **Audit Manager** — Streamline external audit preparation
- [ ] **Policy Manager** — Track policy distribution and acknowledgments
- [ ] **Trust Center** — Public-facing compliance showcase

### Phase 3+ Features

- [ ] **Framework Mapping** — Cross-map controls across SOC 2, ISO 27001, etc.
- [ ] **Integrations** — AWS, GitHub, Microsoft Entra ID
- [ ] **Vendor Risk Management** — Assess third-party security posture
- [ ] **Continuous Monitoring** — Automated control testing

---

## Database Schema

The application uses a normalized relational schema with the following core tables:

- `cyber_assessments` — Questionnaire metadata
- `cyber_categories` — Questionnaire sections
- `cyber_headers` — General vendor information
- `cyber_questions` — Master question list
- `cyber_responses` — Assessment-specific answers
- `cyber_evidence` — Compliance artifacts
- `cyber_answer_library` — Reusable answer templates
- `cyber_risks` — Tracked gaps and remediation items

See `database/schema/` for full SQL scripts.

---

## Development

### Running Tests

```bash
# Backend tests
pytest backend/tests/

# Run a single test file
pytest backend/tests/test_assessments.py

# Run a single test
pytest backend/tests/test_assessments.py::TestAssessmentCreate::test_create_assessment

# Frontend tests
npm test --prefix frontend
```

### Code Style

- Python: PEP 8, Black formatter, 88-100 character line length
- TypeScript: ESLint + Prettier
- Commits: Conventional Commits format

### Environment Variables

Create a `.env` file in the project root:

```env
# Database
# SQL Server connection string (standard .NET format)
DATABASE_URL=server=sql02.edvistas.local,51433;database=AnswerForge;uid=webapp;pwd=your-password;Connection Timeout=150;max pool size=200
```

---

## Deployment

### On-Premises (IIS) — Default

```bash
# Build frontend
cd frontend && npm run build

# Deploy backend as Windows Service
# See docs/DEPLOYMENT.md for detailed instructions
```

### Azure App Service (Optional)

If you prefer cloud hosting:

```bash
# Build and deploy via GitHub Actions
# See .github/workflows/deploy.yml for CI/CD pipeline

# Manual deployment
az webapp up --name answerforge --resource-group evi-rg --runtime "PYTHON:3.11"
```

---

## Security

- Authentication via Microsoft Entra ID (Azure AD) with MFA — *optional, configure if using Azure*
- Role-based access control (Admin, Editor, Reviewer, Viewer)
- Audit logging for all sensitive changes
- Evidence confidentiality labels (Public, NDA, Internal, Confidential, Restricted)
- Encryption at rest (TDE) and in transit (TLS 1.3)
- No AI tools have direct write access to production database
- All AI-generated answers require human approval

---

## Contributing

This is an internal project for Educational Vistas, Inc. External contributions are not currently accepted.

For internal contributors:

1. Create a feature branch: `git checkout -b feature/your-feature-name`
2. Make your changes with tests
3. Run the test suite: `pytest` and `npm test`
4. Submit a pull request for review

---

## License

MIT License — Copyright (c) 2026 Educational Vistas, Inc.

---

## Support

For questions or issues, contact:

- **IT/Security:** Robert Roelle, Director of Technology, Assessment and Data — rroelle@mtplcsd.org
- **Product:** Pete Cooper, National Sales Manager — pcooper@edvistas.com

---

## Acknowledgments

- Built for Educational Vistas, Inc.
- Inspired by the need to streamline K-12 education vendor security assessments
- Competitive research informed by Vanta (vanta.com) trust management platform

---

*AnswerForge — Forge better answers, build stronger trust.*
