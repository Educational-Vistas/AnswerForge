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
git clone https://github.com/EducationalVistas/AnswerForge.git
cd AnswerForge

# Install backend dependencies
pip install -r requirements.txt

# Install frontend dependencies
cd frontend
npm install

# Set up the database
python scripts/setup_database.py

# Run database migrations
python scripts/migrate.py

# Import initial questionnaire data
python scripts/import_questionnaire.py --file data/mount_pleasant_csd_2026.sql

# Start the development servers
# Terminal 1: Backend
cd backend
python -m uvicorn main:app --reload --port 8000

# Terminal 2: Frontend
cd frontend
npm run dev
```

The application will be available at `http://localhost:3000`.

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
- **Hosting:** Azure App Service (or on-premises IIS)
- **File Storage:** Azure Blob Storage
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
DATABASE_URL=mssql+pyodbc://user:password@server/AnswerForge?driver=ODBC+Driver+17+for+SQL+Server

# Authentication
AZURE_CLIENT_ID=your-azure-client-id
AZURE_TENANT_ID=your-azure-tenant-id
AZURE_CLIENT_SECRET=your-azure-client-secret

# AI
OPENAI_API_KEY=your-openai-api-key
# or
OPENROUTER_API_KEY=your-openrouter-api-key

# Storage
AZURE_STORAGE_CONNECTION_STRING=your-storage-connection-string
```

---

## Deployment

### Azure App Service (Recommended)

```bash
# Build and deploy via GitHub Actions
# See .github/workflows/deploy.yml for CI/CD pipeline

# Manual deployment
az webapp up --name answerforge --resource-group evi-rg --runtime "PYTHON:3.11"
```

### On-Premises (IIS)

```bash
# Build frontend
cd frontend && npm run build

# Deploy backend as Windows Service
# See docs/DEPLOYMENT.md for detailed instructions
```

---

## Security

- Authentication via Microsoft Entra ID with MFA
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
