# Vanta Feature Analysis & Gap Report for AnswerForge

## Executive Summary

After scraping Vanta's website (vanta.com), I've identified **significant feature gaps** between your current AnswerForge/ControlDeck PRD and what a modern GRC/Trust Management platform offers. Vanta has evolved far beyond simple questionnaire management into a comprehensive **"Agentic Trust Platform."**

Your current PRD covers about **30-40%** of Vanta's feature set. Below is a structured breakdown of everything Vanta offers, categorized by what's **Already in your PRD**, **Partially covered**, and **Completely missing**.

---

## 1. COMPLIANCE & FRAMEWORKS (Your PRD: 3/10)

### Already in Your PRD
- SOC 2 alignment (mentioned indirectly)
- NY Ed Law 2-d
- FERPA
- NIST CSF
- CIS Controls
- CoSN K-12 Vendor Assessment

### Missing Frameworks
| Framework | Why It Matters |
|---|---|
| **ISO 27001** | International security standard; most requested alongside SOC 2 |
| **GDPR** | EU data protection; critical for any vendor with EU customers |
| **HIPAA/HITRUST** | Healthcare data protection; massive market |
| **PCI DSS** | Payment card industry; required for any payment handling |
| **FedRAMP** | US government cloud; high-value contracts |
| **CMMC** | DoD cybersecurity maturity |
| **ISO 42001** | AI governance framework (emerging) |
| **NIST AI RMF** | AI risk management |
| **CJIS** | Criminal justice information services |
| **Cyber Essentials** | UK government baseline |
| **Custom Frameworks** | Ability to create custom compliance frameworks |

### Missing Features
- **Cross-mapping controls across frameworks** (e.g., one control satisfies both SOC 2 and ISO 27001)
- **Pre-built framework templates** with required controls
- **Automated evidence collection** from integrations
- **Continuous controls monitoring** (not just point-in-time)
- **Audit readiness scoring** per framework
- **Framework gap analysis** (what's needed vs. what's implemented)

---

## 2. AUTOMATED COMPLIANCE & MONITORING (Your PRD: 1/10)

### Completely Missing
This is Vanta's **core differentiator** and entirely absent from your PRD:

| Feature | Description |
|---|---|
| **400+ Integrations** | Auto-pull data from AWS, Azure, GCP, GitHub, Jira, Okta, etc. |
| **Automated Tests** | Continuous automated compliance tests against infrastructure |
| **Evidence Collection** | Auto-gather screenshots, logs, configs from integrated tools |
| **Real-time Alerts** | Notify when controls fail or drift |
| **Policy Templates** | Pre-written security policies (40+ templates) |
| **Policy Distribution** | Track who has read/acknowledged policies |
| **Exception Management** | Track and approve policy exceptions with expiration dates |
| **Remediation Workflows** | Auto-create tickets when tests fail |
| **Vulnerability Management** | Integrate with vulnerability scanners; track remediation |

### Integration Categories Vanta Supports
- Cloud providers (AWS, Azure, GCP)
- Version control (GitHub, GitLab, Bitbucket)
- Identity providers (Okta, Google Workspace, OneLogin, JumpCloud)
- HRIS (ADP, BambooHR, etc.)
- Endpoint security
- Vulnerability scanners
- Communication (Slack, Teams)
- Task management (Jira, Asana)
- Datastores & data warehouses

---

## 3. CONTINUOUS GRC (Your PRD: 0/10)

### Completely Missing
Vanta brands this as "Continuous GRC" — moving beyond point-in-time assessments:

| Feature | Description |
|---|---|
| **Continuous Control Monitoring** | Tests run automatically on schedule |
| **Control Library** | 100+ pre-built controls mapped to frameworks |
| **Custom Controls** | Build your own controls with custom tests |
| **Control Maturity Scoring** | Track control implementation maturity |
| **Control Owner Assignment** | Assign controls to specific people |
| **Control Test History** | Historical pass/fail tracking |
| **Drift Detection** | Alert when previously passing controls fail |
| **GRC Dashboard** | Real-time program health overview |

---

## 4. THIRD-PARTY RISK MANAGEMENT (Your PRD: 2/10)

### Partially in Your PRD
- You mention vendor assessments and receiving questionnaires

### Completely Missing

| Feature | Description |
|---|---|
| **Vendor Onboarding** | Standardized vendor intake forms |
| **Vendor Risk Assessment** | Score vendors by risk level |
| **Security Scorecards** | Continuous monitoring of vendor security posture |
| **Vendor Tiering** | Classify vendors by criticality |
| **Automated Vendor Reviews** | Re-assess vendors on schedule |
| **Vendor Evidence Collection** | Request and store vendor security docs |
| **Contract/SLA Tracking** | Monitor vendor contract terms |
| **Vendor Incident Tracking** | Log vendor security incidents |
| **AI-Powered Vendor Monitoring** | Vanta acquired Riskey for this |

---

## 5. QUESTIONNAIRE AUTOMATION (Your PRD: 6/10)

### Already in Your PRD
- AI answer drafting
- Answer library
- Export to various formats
- Search prior responses

### Missing Features

| Feature | Description |
|---|---|
| **Auto-fill from Knowledge Base** | Automatically suggest answers from past responses |
| **Bulk Response** | Answer multiple similar questions at once |
| **Questionnaire Import** | Upload customer Excel/Word questionnaires |
| **AI Question Mapping** | Map customer questions to internal controls automatically |
| **Response Confidence Scoring** | AI indicates confidence in suggested answers |
| **Customer Trust Center** | Public-facing page showing compliance status |
| **NDA Gate** | Require NDA before sharing sensitive docs |
| **Document Watermarking** | Auto-watermark shared evidence |

---

## 6. AUDIT MANAGEMENT (Your PRD: 1/10)

### Completely Missing
This is a **huge gap** — Vanta streamlines the entire audit process:

| Feature | Description |
|---|---|
| **Auditor Portal** | Secure access for external auditors |
| **Evidence Sharing** | Share evidence directly with auditors |
| **Audit Timeline** | Track audit milestones and deadlines |
| **Audit Finding Tracking** | Log and remediate auditor findings |
| **Audit Readiness Score** | % ready before audit starts |
| **Pre-audit Assessment** | Self-assessment before formal audit |
| **Audit Report Storage** | Centralize all audit reports |
| **Auditor Directory** | Connect with certified auditors |

---

## 7. RISK MANAGEMENT (Your PRD: 4/10)

### Partially in Your PRD
- Risk/gap tracking mentioned
- Severity levels defined

### Missing Features

| Feature | Description |
|---|---|
| **Risk Register** | Centralized risk inventory |
| **Risk Scoring Matrix** | Customizable likelihood × impact scoring |
| **Risk Treatment Plans** | Accept, mitigate, transfer, avoid |
| **Risk Owner Assignment** | Clear accountability |
| **Residual Risk Tracking** | Post-treatment risk levels |
| **Risk Heat Map** | Visual risk prioritization |
| **Risk Reporting** | Executive risk summaries |
| **Control-Risk Mapping** | Link controls to risks they mitigate |

---

## 8. PERSONNEL & ACCESS MANAGEMENT (Your PRD: 0/10)

### Completely Missing
Vanta has an entire product module for this:

| Feature | Description |
|---|---|
| **Employee Directory** | Track all personnel |
| **Background Check Integration** | Verify employee backgrounds |
| **Access Reviews** | Periodic review of who has access to what |
| **Access Certification** | Managers certify direct reports' access |
| **Offboarding Workflows** | Ensure access removal on termination |
| **Role-based Access Templates** | Standard access by role |
| **Sensitive Access Tracking** | Flag privileged/high-risk access |
| **Security Training Tracking** | Monitor training completion |

---

## 9. TRUST CENTER (Your PRD: 0/10)

### Completely Missing
This is how Vanta customers **sell faster**:

| Feature | Description |
|---|---|
| **Public Trust Center** | Customer-facing security profile page |
| **Real-time Compliance Status** | Live badges showing SOC 2, ISO 27001, etc. |
| **Document Sharing** | Share SOC 2 reports, pen test results under NDA |
| **Self-service Questionnaires** | Customers answer their own questions from your data |
| **Custom Branding** | White-label with company branding |
| **Analytics** | See who's viewing your trust center |
| **NDA Workflow** | Digital NDA signing before doc access |

---

## 10. AI & AUTOMATION (Your PRD: 5/10)

### Already in Your PRD
- AI answer drafting
- Question comparison
- Evidence suggestions
- Gap detection
- Risk flagging

### Missing AI Features

| Feature | Description |
|---|---|
| **AI Agent** | 24/7 autonomous compliance monitoring |
| **Policy Drafting** | AI writes security policies from templates |
| **Control Test Generation** | AI suggests tests for custom controls |
| **Anomaly Detection** | AI spots unusual patterns in compliance data |
| **Natural Language Queries** | "Show me all critical risks without owners" |
| **AI-Powered Vendor Research** | Auto-gather vendor security info from web |
| **Remediation Suggestions** | AI suggests how to fix failed controls |
| **Smart Scheduling** | AI optimizes review schedules |

---

## 11. REPORTING & ANALYTICS (Your PRD: 3/10)

### Partially in Your PRD
- Basic dashboard mentioned
- Category completion status
- Export capabilities

### Missing Features

| Feature | Description |
|---|---|
| **Executive Summary Reports** | CISO/board-ready summaries |
| **Program Health Score** | Overall compliance program maturity |
| **Trend Analysis** | Compliance posture over time |
| **Benchmarking** | Compare to industry peers |
| **Custom Reports** | Build your own report templates |
| **Scheduled Reports** | Auto-email reports weekly/monthly |
| **Audit Trail Reports** | Complete change history |
| **Stakeholder Dashboards** | Role-specific views |

---

## 12. PLATFORM FEATURES (Your PRD: 2/10)

### Missing Enterprise Capabilities

| Feature | Description |
|---|---|
| **API** | REST API for custom integrations |
| **Webhooks** | Event-driven notifications |
| **SSO/SAML** | Single sign-on |
| **SCIM Provisioning** | Automated user provisioning |
| **Multi-workspace** | Manage multiple orgs/business units |
| **Custom Fields** | Extend data model |
| **Workflow Automation** | If-this-then-that automation |
| **Data Retention Policies** | Automated data lifecycle |
| **Encryption at Rest** | AES-256 encryption |
| **SOC 2 Type II / ISO 27001 Certified** | Platform itself is certified |

---

## 13. CUSTOMER COMMITMENTS (Your PRD: 0/10)

### Completely Missing
Vanta recently added this — tracking promises made to customers:

| Feature | Description |
|---|---|
| **Commitment Tracking** | Log contractual security commitments |
| **Commitment-to-Control Mapping** | Link commitments to controls |
| **Commitment Status** | Track if commitments are met |
| **Customer-specific Requirements** | Track per-customer special requirements |

---

## 14. VULNERABILITY MANAGEMENT (Your PRD: 1/10)

### Partially in Your PRD
- Vulnerability scanning mentioned briefly

### Missing Features

| Feature | Description |
|---|---|
| **Vulnerability Aggregation** | Pull from multiple scanners |
| **Prioritization** | Risk-based prioritization |
| **SLA Tracking** | Time-to-remediate tracking |
| **Exception Management** | Track accepted vulnerabilities |
| **Trend Reporting** | Vulnerability trends over time |

---

## Prioritized Feature Recommendations for AnswerForge

### Phase 1 (MVP) — You Have Most of This
- [x] Assessment management
- [x] Question/answer database
- [x] Basic dashboard
- [x] Search & filter
- [x] Export (Markdown, Excel)
- [ ] **ADD: Answer Library with approval workflow**
- [ ] **ADD: Evidence vault with document upload**
- [ ] **ADD: Basic risk/gap tracking**

### Phase 2 — High-Value Additions
- [ ] **Trust Center** (huge sales accelerator)
- [ ] **Questionnaire Import** (parse customer Excel files)
- [ ] **AI Answer Assistant** (your AnswerForge module)
- [ ] **Audit Management** (auditor portal)
- [ ] **Policy Management** (templates + distribution)
- [ ] **Integrations** (start with AWS, GitHub, Okta)

### Phase 3 — Scale & Automate
- [ ] **Continuous Control Monitoring**
- [ ] **Automated Evidence Collection**
- [ ] **Third-Party Risk Management**
- [ ] **Personnel & Access Reviews**
- [ ] **Advanced Risk Management**
- [ ] **Vulnerability Management**
- [ ] **API & Webhooks**

### Phase 4 — Enterprise
- [ ] **Multi-workspace / Multi-tenant**
- [ ] **Custom Frameworks**
- [ ] **Advanced Analytics**
- [ ] **Workflow Automation**
- [ ] **AI Agent** (autonomous monitoring)

---

## Key Insights from Vanta's Messaging

1. **"Agentic Trust Platform"** — Vanta is positioning as an AI-first platform, not just automation
2. **"Continuous"** — Everything is real-time, not point-in-time
3. **"Prove trust"** — The goal is demonstrating security, not just doing it
4. **"Scale without headcount"** — Automation replaces manual work
5. **400+ integrations** — The moat is the integration ecosystem
6. **Customer Trust Center** — This is how they differentiate from traditional GRC
7. **Auditor partnerships** — Deep relationships with audit firms

---

## Competitive Positioning Recommendation

### Your Current Position
Educational Vistas internal tool focused on **questionnaire response management**

### Vanta's Position
External-facing **trust management platform** for companies to prove security to customers

### Recommended Evolution Path
1. **Short-term**: Build the best internal questionnaire management tool (your Phase 1)
2. **Medium-term**: Add Trust Center + AI Answer Assistant to help EVI respond to customers faster
3. **Long-term**: Consider whether to productize for other K-12 vendors (small Vanta competitor)

---

## Most Critical Missing Features

If you want to build something that truly competes with or replaces Vanta's capabilities for EVI:

1. **Automated Evidence Collection** — Integrations that pull data automatically
2. **Continuous Monitoring** — Not just storing answers, but actively testing controls
3. **Trust Center** — Public-facing compliance showcase
4. **Audit Management** — Streamline the actual audit process
5. **Policy Management** — Track policy acknowledgments and versions
6. **Risk Register** — Formal risk management, not just gap tracking
7. **Vendor Risk Management** — Assess vendors, not just respond to questionnaires
8. **Personnel Access Reviews** — Periodic access certifications

---

*Generated from analysis of vanta.com on 2026-04-30*
