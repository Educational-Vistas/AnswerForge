-- Educational Vistas Vendor Security Questionnaire - Normalized Relational Import
-- Target platform: Microsoft SQL Server / SQL Server Management Studio
-- Purpose:
--   1) Replaces the original flat dbo.cyber_questions table if detected.
--   2) Creates normalized cyber_* tables.
--   3) Upserts questionnaire metadata, headers, categories, questions, and responses.
--
-- Main tables:
--   dbo.cyber_assessments  = questionnaire instance / customer assessment metadata
--   dbo.cyber_headers      = general/header information from the spreadsheet
--   dbo.cyber_categories   = questionnaire sections/categories
--   dbo.cyber_questions    = reusable question/control definitions
--   dbo.cyber_responses    = EVI's answers and additional information for this assessment

SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

BEGIN TRANSACTION;

--------------------------------------------------------------------------------
-- If the prior flat-table version of dbo.cyber_questions exists, drop it so the
-- normalized version can be created cleanly.
--------------------------------------------------------------------------------
IF OBJECT_ID(N'dbo.cyber_questions', N'U') IS NOT NULL
   AND COL_LENGTH(N'dbo.cyber_questions', N'question_text') IS NULL
BEGIN
    DROP TABLE dbo.cyber_questions;
END;

--------------------------------------------------------------------------------
-- Create normalized tables
--------------------------------------------------------------------------------
IF OBJECT_ID(N'dbo.cyber_assessments', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.cyber_assessments
    (
        assessment_id INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_cyber_assessments PRIMARY KEY,
        assessment_key NVARCHAR(100) NOT NULL,
        source_questionnaire NVARCHAR(255) NOT NULL,
        institution_name NVARCHAR(255) NULL,
        vendor_name NVARCHAR(255) NULL,
        product_name NVARCHAR(500) NULL,
        assessment_date DATE NULL,
        last_reviewed DATE NULL,
        review_owner NVARCHAR(255) NULL,
        notes NVARCHAR(MAX) NULL,
        created_at DATETIME2(0) NOT NULL CONSTRAINT DF_cyber_assessments_created_at DEFAULT SYSUTCDATETIME(),
        updated_at DATETIME2(0) NULL
    );
END;

IF OBJECT_ID(N'dbo.cyber_categories', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.cyber_categories
    (
        category_id INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_cyber_categories PRIMARY KEY,
        assessment_id INT NOT NULL,
        category_name NVARCHAR(255) NOT NULL,
        sort_order INT NOT NULL,
        created_at DATETIME2(0) NOT NULL CONSTRAINT DF_cyber_categories_created_at DEFAULT SYSUTCDATETIME(),
        updated_at DATETIME2(0) NULL,
        CONSTRAINT FK_cyber_categories_assessments
            FOREIGN KEY (assessment_id) REFERENCES dbo.cyber_assessments(assessment_id)
    );
END;

IF OBJECT_ID(N'dbo.cyber_headers', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.cyber_headers
    (
        header_id INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_cyber_headers PRIMARY KEY,
        assessment_id INT NOT NULL,
        header_key NVARCHAR(50) NOT NULL,
        header_label NVARCHAR(255) NOT NULL,
        header_value NVARCHAR(MAX) NULL,
        additional_information NVARCHAR(MAX) NULL,
        sort_order INT NOT NULL,
        last_reviewed DATE NULL,
        review_owner NVARCHAR(255) NULL,
        notes NVARCHAR(MAX) NULL,
        created_at DATETIME2(0) NOT NULL CONSTRAINT DF_cyber_headers_created_at DEFAULT SYSUTCDATETIME(),
        updated_at DATETIME2(0) NULL,
        CONSTRAINT FK_cyber_headers_assessments
            FOREIGN KEY (assessment_id) REFERENCES dbo.cyber_assessments(assessment_id)
    );
END;

IF OBJECT_ID(N'dbo.cyber_questions', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.cyber_questions
    (
        question_id INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_cyber_questions PRIMARY KEY,
        category_id INT NOT NULL,
        control_id NVARCHAR(50) NOT NULL,
        question_text NVARCHAR(MAX) NOT NULL,
        sort_order INT NOT NULL,
        is_active BIT NOT NULL CONSTRAINT DF_cyber_questions_is_active DEFAULT (1),
        created_at DATETIME2(0) NOT NULL CONSTRAINT DF_cyber_questions_created_at DEFAULT SYSUTCDATETIME(),
        updated_at DATETIME2(0) NULL,
        CONSTRAINT FK_cyber_questions_categories
            FOREIGN KEY (category_id) REFERENCES dbo.cyber_categories(category_id)
    );
END;

IF OBJECT_ID(N'dbo.cyber_responses', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.cyber_responses
    (
        response_id INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_cyber_responses PRIMARY KEY,
        assessment_id INT NOT NULL,
        question_id INT NOT NULL,
        vendor_answer NVARCHAR(255) NULL,
        additional_information NVARCHAR(MAX) NULL,
        last_reviewed DATE NULL,
        review_owner NVARCHAR(255) NULL,
        notes NVARCHAR(MAX) NULL,
        created_at DATETIME2(0) NOT NULL CONSTRAINT DF_cyber_responses_created_at DEFAULT SYSUTCDATETIME(),
        updated_at DATETIME2(0) NULL,
        CONSTRAINT FK_cyber_responses_assessments
            FOREIGN KEY (assessment_id) REFERENCES dbo.cyber_assessments(assessment_id),
        CONSTRAINT FK_cyber_responses_questions
            FOREIGN KEY (question_id) REFERENCES dbo.cyber_questions(question_id)
    );
END;

--------------------------------------------------------------------------------
-- Indexes
--------------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'UX_cyber_assessments_assessment_key' AND object_id = OBJECT_ID(N'dbo.cyber_assessments'))
    CREATE UNIQUE INDEX UX_cyber_assessments_assessment_key ON dbo.cyber_assessments(assessment_key);

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'UX_cyber_categories_assessment_category' AND object_id = OBJECT_ID(N'dbo.cyber_categories'))
    CREATE UNIQUE INDEX UX_cyber_categories_assessment_category ON dbo.cyber_categories(assessment_id, category_name);

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_cyber_categories_assessment_sort' AND object_id = OBJECT_ID(N'dbo.cyber_categories'))
    CREATE INDEX IX_cyber_categories_assessment_sort ON dbo.cyber_categories(assessment_id, sort_order);

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'UX_cyber_headers_assessment_key' AND object_id = OBJECT_ID(N'dbo.cyber_headers'))
    CREATE UNIQUE INDEX UX_cyber_headers_assessment_key ON dbo.cyber_headers(assessment_id, header_key);

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_cyber_headers_assessment_sort' AND object_id = OBJECT_ID(N'dbo.cyber_headers'))
    CREATE INDEX IX_cyber_headers_assessment_sort ON dbo.cyber_headers(assessment_id, sort_order);

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'UX_cyber_questions_category_control' AND object_id = OBJECT_ID(N'dbo.cyber_questions'))
    CREATE UNIQUE INDEX UX_cyber_questions_category_control ON dbo.cyber_questions(category_id, control_id);

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_cyber_questions_control_id' AND object_id = OBJECT_ID(N'dbo.cyber_questions'))
    CREATE INDEX IX_cyber_questions_control_id ON dbo.cyber_questions(control_id);

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_cyber_questions_category_sort' AND object_id = OBJECT_ID(N'dbo.cyber_questions'))
    CREATE INDEX IX_cyber_questions_category_sort ON dbo.cyber_questions(category_id, sort_order);

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'UX_cyber_responses_assessment_question' AND object_id = OBJECT_ID(N'dbo.cyber_responses'))
    CREATE UNIQUE INDEX UX_cyber_responses_assessment_question ON dbo.cyber_responses(assessment_id, question_id);

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_cyber_responses_vendor_answer' AND object_id = OBJECT_ID(N'dbo.cyber_responses'))
    CREATE INDEX IX_cyber_responses_vendor_answer ON dbo.cyber_responses(vendor_answer);

--------------------------------------------------------------------------------
-- Source data staging
--------------------------------------------------------------------------------
IF OBJECT_ID(N'tempdb..#source_rows', N'U') IS NOT NULL
    DROP TABLE #source_rows;

CREATE TABLE #source_rows
(
    sort_order INT NOT NULL,
    category_name NVARCHAR(255) NOT NULL,
    control_id NVARCHAR(50) NOT NULL,
    question_text NVARCHAR(MAX) NOT NULL,
    vendor_answer NVARCHAR(255) NULL,
    additional_information NVARCHAR(MAX) NULL,
    source_questionnaire NVARCHAR(255) NOT NULL,
    last_reviewed DATE NOT NULL,
    review_owner NVARCHAR(255) NULL,
    notes NVARCHAR(MAX) NULL
);

INSERT INTO #source_rows
(
    sort_order,
    category_name,
    control_id,
    question_text,
    vendor_answer,
    additional_information,
    source_questionnaire,
    last_reviewed,
    review_owner,
    notes
)
VALUES
    (1, N'General Information', N'DATE-01', N'Date', N'4/30/2026', N'Questionnaire completion date.', N'Mount Pleasant CSD Vendor Assessment Tool / CoSN K-12 Vendor Assessment Lite', '2026-04-30', N'Educational Vistas, Inc.', NULL),
    (2, N'General Information', N'GNRL-01', N'Vendor Name', N'Educational Vistas', NULL, N'Mount Pleasant CSD Vendor Assessment Tool / CoSN K-12 Vendor Assessment Lite', '2026-04-30', N'Educational Vistas, Inc.', NULL),
    (3, N'General Information', N'GNRL-02', N'Product Name', N'DataMate, StaffTrac, EduView, Portfolio(+)', NULL, N'Mount Pleasant CSD Vendor Assessment Tool / CoSN K-12 Vendor Assessment Lite', '2026-04-30', N'Educational Vistas, Inc.', NULL),
    (4, N'General Information', N'GNRL-03', N'Product Description', N'Student and staff data management, assessment reporting, evaluation, and educational tools for K-12 districts.', NULL, N'Mount Pleasant CSD Vendor Assessment Tool / CoSN K-12 Vendor Assessment Lite', '2026-04-30', N'Educational Vistas, Inc.', NULL),
    (5, N'General Information', N'GNRL-04', N'Web Link to Product Privacy Notice', N'https://edvistas.com/data-security-privacy-statement/', NULL, N'Mount Pleasant CSD Vendor Assessment Tool / CoSN K-12 Vendor Assessment Lite', '2026-04-30', N'Educational Vistas, Inc.', NULL),
    (6, N'General Information', N'GNRL-05', N'Vendor Contact Name', N'Pete Cooper', NULL, N'Mount Pleasant CSD Vendor Assessment Tool / CoSN K-12 Vendor Assessment Lite', '2026-04-30', N'Educational Vistas, Inc.', NULL),
    (7, N'General Information', N'GNRL-06', N'Vendor Contact Title', N'National Sales Manager', NULL, N'Mount Pleasant CSD Vendor Assessment Tool / CoSN K-12 Vendor Assessment Lite', '2026-04-30', N'Educational Vistas, Inc.', NULL),
    (8, N'General Information', N'GNRL-07', N'Vendor Contact Email', N'pcooper@edvistas.com', NULL, N'Mount Pleasant CSD Vendor Assessment Tool / CoSN K-12 Vendor Assessment Lite', '2026-04-30', N'Educational Vistas, Inc.', NULL),
    (9, N'General Information', N'GNRL-08', N'Vendor Contact Phone Number', N'518-344-7022', NULL, N'Mount Pleasant CSD Vendor Assessment Tool / CoSN K-12 Vendor Assessment Lite', '2026-04-30', N'Educational Vistas, Inc.', NULL),
    (10, N'General Information', N'GNRL-09', N'Vendor Data Zone', N'United States / New York', NULL, N'Mount Pleasant CSD Vendor Assessment Tool / CoSN K-12 Vendor Assessment Lite', '2026-04-30', N'Educational Vistas, Inc.', NULL),
    (11, N'General Information', N'GNRL-10', N'Institution Data Zone', N'United States / New York', NULL, N'Mount Pleasant CSD Vendor Assessment Tool / CoSN K-12 Vendor Assessment Lite', '2026-04-30', N'Educational Vistas, Inc.', NULL),
    (12, N'General Information', N'GNRL-11', N'School Organization Security Analyst/Engineer', N'Robert Roelle, Director of Technology, Assessment and Data', N'Institution-provided contact.', N'Mount Pleasant CSD Vendor Assessment Tool / CoSN K-12 Vendor Assessment Lite', '2026-04-30', N'Educational Vistas, Inc.', NULL),
    (13, N'General Information', N'GNRL-12', N'Assessment Contact', N'rroelle@mtplcsd.org', N'Institution-provided contact.', N'Mount Pleasant CSD Vendor Assessment Tool / CoSN K-12 Vendor Assessment Lite', '2026-04-30', N'Educational Vistas, Inc.', NULL),
    (14, N'Documentation', N'DOCU-01', N'Have you undergone a SSAE 18 audit?', N'Yes', N'EVI''s hosting provider maintains a SOC 2 Type II report, performed under AICPA/SSAE 18 attestation standards, covering security, availability, and confidentiality. Report may be made available upon request under appropriate confidentiality or NDA requirements.', N'Mount Pleasant CSD Vendor Assessment Tool / CoSN K-12 Vendor Assessment Lite', '2026-04-30', N'Educational Vistas, Inc.', NULL),
    (15, N'Documentation', N'DOCU-02', N'Are you a covered entity under the NYS Cybersecurity Regulation (23NYCRR 500)?', N'No', N'EVI is not a covered entity under 23 NYCRR 500 and does not hold a license issued by the NYS Department of Financial Services.', N'Mount Pleasant CSD Vendor Assessment Tool / CoSN K-12 Vendor Assessment Lite', '2026-04-30', N'Educational Vistas, Inc.', NULL),
    (16, N'Documentation', N'DOCU-03', N'If you are a covered entity, have you filed your annual certificate of compliance with the NYS Dept of Financial Services?', N'No / N/A', N'Not applicable; EVI is not a covered entity under the NYS DFS Cybersecurity Regulation.', N'Mount Pleasant CSD Vendor Assessment Tool / CoSN K-12 Vendor Assessment Lite', '2026-04-30', N'Educational Vistas, Inc.', NULL),
    (17, N'Documentation', N'DOCU-04', N'Do you conform with a specific industry standard security framework?', N'Yes', N'EVI aligns its security practices with SOC 2 Trust Services Criteria, NIST Cybersecurity Framework principles, and New York Education Law 2-d / K-12 data privacy requirements where applicable.', N'Mount Pleasant CSD Vendor Assessment Tool / CoSN K-12 Vendor Assessment Lite', '2026-04-30', N'Educational Vistas, Inc.', NULL),
    (18, N'Documentation', N'DOCU-05', N'Are you compliant with FISMA standards?', N'No', N'EVI is not currently FISMA compliant and does not currently plan to pursue FISMA compliance unless required by a federal contract or customer requirement. EVI currently prioritizes K-12 security, privacy, SOC 2-aligned, and NY Ed Law 2-d requirements.', N'Mount Pleasant CSD Vendor Assessment Tool / CoSN K-12 Vendor Assessment Lite', '2026-04-30', N'Educational Vistas, Inc.', NULL),
    (19, N'Documentation', N'DOCU-06', N'Would you sign the Mount Pleasant CSD Data Privacy - Parent Bill of Rights Agreement?', N'Yes', N'EVI is willing to review and sign the Mount Pleasant CSD Data Privacy / Parent Bill of Rights Agreement, subject to normal contract/legal review and execution by an authorized representative.', N'Mount Pleasant CSD Vendor Assessment Tool / CoSN K-12 Vendor Assessment Lite', '2026-04-30', N'Educational Vistas, Inc.', NULL),
    (20, N'Company Overview', N'COMP-01', N'Describe your organization''s business background and ownership structure.', N'N/A', N'Educational Vistas is a privately held, for-profit K-12 education company based in New York. Founded in 1993, Educational Vistas has been in business for 33 years. The company provides software products, assessment services, data services, reporting tools, professional development, and related educational services to schools, districts, BOCES, RICs, and other educational agencies. Educational Vistas'' software offerings include products such as DataMate, StaffTrac, EduView, Portfolio+, Report+, SurVate, EduForm, AIMS, SafeSchools, MTSS-P, and DataSync. Educational Vistas does not operate under a parent company or known multinational ownership structure. Its services are focused primarily on K-12 educational agencies and related educational data management needs.', N'Mount Pleasant CSD Vendor Assessment Tool / CoSN K-12 Vendor Assessment Lite', '2026-04-30', N'Educational Vistas, Inc.', NULL),
    (21, N'Company Overview', N'COMP-02', N'Describe how long your organization has conducted business in this product area.', N'N/A', N'Educational Vistas was founded in 1993 and has conducted business in the K-12 education software, assessment, reporting, and data services space for 33 years.', N'Mount Pleasant CSD Vendor Assessment Tool / CoSN K-12 Vendor Assessment Lite', '2026-04-30', N'Educational Vistas, Inc.', NULL),
    (22, N'Company Overview', N'COMP-03', N'Do you have existing K-12 customers?', N'Yes', N'Educational Vistas does business with over 1,000 schools, districts, BOCES, and RICs.', N'Mount Pleasant CSD Vendor Assessment Tool / CoSN K-12 Vendor Assessment Lite', '2026-04-30', N'Educational Vistas, Inc.', NULL),
    (23, N'Company Overview', N'COMP-04', N'Have you had a significant cybersecurity incident that has disrupted availability for longer than 8 hours?', N'No', N'EVI experienced a ransomware incident in February 2026 that primarily affected the HQ internal server stack and internal network file share. Customer-facing data center services were not taken down, and EVI maintained 99.997% uptime.', N'Mount Pleasant CSD Vendor Assessment Tool / CoSN K-12 Vendor Assessment Lite', '2026-04-30', N'Educational Vistas, Inc.', NULL),
    (24, N'Company Overview', N'COMP-05', N'Have you had a security event in the last 5 years that impacted privacy, operations, data, customers, and what steps did you take to handle the incident?', N'Yes', N'In February 2026, EVI experienced a ransomware/security event affecting internal HQ systems, primarily internal file shares. EVI isolated affected systems, investigated and remediated the issue, restored from backups, reviewed controls, and maintained customer-facing hosted service availability. There is no indication that datacenter-hosted customer applications were taken offline.', N'Mount Pleasant CSD Vendor Assessment Tool / CoSN K-12 Vendor Assessment Lite', '2026-04-30', N'Educational Vistas, Inc.', NULL),
    (25, N'Company Overview', N'COMP-06', N'Do you have a formal risk management and cybersecurity program in place?', N'Yes', N'EVI maintains cybersecurity and risk management practices including incident response planning, monitoring, backups, vulnerability review, access controls, and leadership/technical review. The program continues to mature and be formalized.', N'Mount Pleasant CSD Vendor Assessment Tool / CoSN K-12 Vendor Assessment Lite', '2026-04-30', N'Educational Vistas, Inc.', NULL),
    (26, N'Company Overview', N'COMP-07', N'If applicable, do you have dedicated customer support and product management?', N'Yes', N'EVI maintains dedicated customer support and product management functions. Support requests are handled through existing support, account management, and administrative communication channels, with product and technical teams engaged as needed.', N'Mount Pleasant CSD Vendor Assessment Tool / CoSN K-12 Vendor Assessment Lite', '2026-04-30', N'Educational Vistas, Inc.', NULL),
    (27, N'Company Overview', N'COMP-08', N'If applicable, do you have dedicated software and systems development teams?', N'Yes', N'EVI maintains dedicated software development and systems/administration teams responsible for application development, maintenance, infrastructure, and support.', N'Mount Pleasant CSD Vendor Assessment Tool / CoSN K-12 Vendor Assessment Lite', '2026-04-30', N'Educational Vistas, Inc.', NULL),
    (28, N'Company Overview', N'COMP-09', N'Share information about your environment that will assist the assessment.', N'N/A', N'EVI''s customer-facing applications are hosted in secure U.S.-based datacenter environments with logical tenant segmentation, role-based access, encryption in transit and at rest where applicable, backup and disaster recovery practices, administrative controls, monitoring, and vulnerability review. Customer data is used only to deliver contracted services.', N'Mount Pleasant CSD Vendor Assessment Tool / CoSN K-12 Vendor Assessment Lite', '2026-04-30', N'Educational Vistas, Inc.', NULL),
    (29, N'Application / Service Security', N'HLAP-01', N'Does your system support various permission levels for end users?', N'Yes', N'The system supports multiple permission levels and role-based access controls for end users. Access can be configured by district roles and responsibilities.', N'Mount Pleasant CSD Vendor Assessment Tool / CoSN K-12 Vendor Assessment Lite', '2026-04-30', N'Educational Vistas, Inc.', NULL),
    (30, N'Application / Service Security', N'HLAP-02', N'Do you enforce additional security controls for privileged access users?', N'Yes', N'Privileged and system administrator access is limited to authorized personnel and protected with additional controls, including role-based permissions, authentication requirements, MFA where supported, restricted administrative access, logging, and review.', N'Mount Pleasant CSD Vendor Assessment Tool / CoSN K-12 Vendor Assessment Lite', '2026-04-30', N'Educational Vistas, Inc.', NULL),
    (31, N'Application / Service Security', N'HLAP-03', N'Can employees access protected or sensitive data remotely?', N'Yes', N'Customer-facing systems are online, and authorized users/employees may access systems remotely as required. Remote access is controlled through authentication, authorization, MFA/VPN or secure administrative channels where applicable, and role-based access controls.', N'Mount Pleasant CSD Vendor Assessment Tool / CoSN K-12 Vendor Assessment Lite', '2026-04-30', N'Educational Vistas, Inc.', NULL),
    (32, N'Application / Service Security', N'HLAP-04', N'Is an audit log of access maintained by the system?', N'Yes', N'Audit logs are maintained for system/application access and activity. Logs are reviewed on an as-needed basis for support, troubleshooting, security review, and incident investigation.', N'Mount Pleasant CSD Vendor Assessment Tool / CoSN K-12 Vendor Assessment Lite', '2026-04-30', N'Educational Vistas, Inc.', NULL),
    (33, N'Application / Service Security', N'HLAP-05', N'If necessary would you be willing to share systems schematics, diagrams, data flow diagrams, etc.?', N'Yes', N'EVI is willing to share system diagrams, schematics, or data-flow information when available and appropriate, subject to confidentiality/NDA and relevance to the assessment.', N'Mount Pleasant CSD Vendor Assessment Tool / CoSN K-12 Vendor Assessment Lite', '2026-04-30', N'Educational Vistas, Inc.', NULL),
    (34, N'Application / Service Security', N'HLAP-06', N'Has your system been tested for input validation errors and do you have appropriate error messaging?', N'Yes', N'EVI applications are tested for input validation and error handling as part of development, QA, troubleshooting, and security review. Controls include server-side validation, permissions checks, and appropriate error messaging to prevent unauthorized access or data exposure.', N'Mount Pleasant CSD Vendor Assessment Tool / CoSN K-12 Vendor Assessment Lite', '2026-04-30', N'Educational Vistas, Inc.', NULL),
    (35, N'Application / Service Security', N'HLAP-07', N'Is district data appropriately segmented and secured from other organization''s data or access and can you demonstrate through reports?', N'Yes', N'Customer/district data is logically segmented using tenant/district boundaries, role-based access, and application/database controls. Reports and permissions are restricted to the authorized district/tenant.', N'Mount Pleasant CSD Vendor Assessment Tool / CoSN K-12 Vendor Assessment Lite', '2026-04-30', N'Educational Vistas, Inc.', NULL),
    (36, N'Application / Service Security', N'HLAP-08', N'Do you have a quality multi tenancy environment with good reporting?', N'Yes', N'EVI operates a multi-tenant environment with logical tenant segmentation. Each tenant/district is isolated from other tenants and cannot interact with or access another tenant''s data. Reporting is restricted accordingly.', N'Mount Pleasant CSD Vendor Assessment Tool / CoSN K-12 Vendor Assessment Lite', '2026-04-30', N'Educational Vistas, Inc.', NULL),
    (37, N'Authentication, Authorization, and Accounting', N'HLAA-01', N'Do you have strong authentication in place including MFA and additional controls for privileged access accounts?', N'Yes', N'Privileged access accounts are limited to authorized personnel and protected with additional controls, including role-based permissions, authentication requirements, and MFA.', N'Mount Pleasant CSD Vendor Assessment Tool / CoSN K-12 Vendor Assessment Lite', '2026-04-30', N'Educational Vistas, Inc.', NULL),
    (38, N'Authentication, Authorization, and Accounting', N'HLAA-02', N'Does your web-based interface support authentication, including standards-based single-sign-on?', N'Yes', N'EVI supports authenticated access and single sign-on for supported authentication services. SSO availability may vary by product and customer configuration.', N'Mount Pleasant CSD Vendor Assessment Tool / CoSN K-12 Vendor Assessment Lite', '2026-04-30', N'Educational Vistas, Inc.', NULL),
    (39, N'Authentication, Authorization, and Accounting', N'HLAA-03', N'Does the system support external authentication services in place of local authentication?', N'Yes', N'EVI server and infrastructure administration can use external authentication services such as directory-based authentication in place of local-only accounts where configured.', N'Mount Pleasant CSD Vendor Assessment Tool / CoSN K-12 Vendor Assessment Lite', '2026-04-30', N'Educational Vistas, Inc.', NULL),
    (40, N'Authentication, Authorization, and Accounting', N'HLAA-04', N'Do organization staff have access to audit logs that allow them to see actions and activities taken by their users?', N'Yes', N'Authorized EVI staff have access to audit logs for support, troubleshooting, security review, and incident investigation. Access to audit logs is limited to appropriate personnel.', N'Mount Pleasant CSD Vendor Assessment Tool / CoSN K-12 Vendor Assessment Lite', '2026-04-30', N'Educational Vistas, Inc.', NULL),
    (41, N'Authentication, Authorization, and Accounting', N'HLAA-05', N'Do all information systems require passwords with minimum length, complexity, and regular password changes?', N'Yes', N'EVI''s native authentication supports password complexity requirements. For SSO/federated authentication, password policies are governed by the customer''s identity provider.', N'Mount Pleasant CSD Vendor Assessment Tool / CoSN K-12 Vendor Assessment Lite', '2026-04-30', N'Educational Vistas, Inc.', NULL),
    (42, N'Business Continuity Plan', N'HLBC-01', N'Do you have a documented Business Continuity Plan (BCP)?', N'No', N'EVI does not currently maintain a formal BCP. EVI does maintain disaster recovery practices, including backups, recovery procedures, monitoring, and operational response processes for hosted services.', N'Mount Pleasant CSD Vendor Assessment Tool / CoSN K-12 Vendor Assessment Lite', '2026-04-30', N'Educational Vistas, Inc.', NULL),
    (43, N'Business Continuity Plan', N'HLBC-02', N'Is there a documented communication plan in your BCP for impacted clients?', N'No', N'EVI does not currently maintain a formal BCP communication plan. Service-impacting client communications are handled through existing support, account management, and administrative notification channels.', N'Mount Pleasant CSD Vendor Assessment Tool / CoSN K-12 Vendor Assessment Lite', '2026-04-30', N'Educational Vistas, Inc.', NULL),
    (44, N'Business Continuity Plan', N'HLBC-03', N'Are all components of the BCP reviewed at least annually and updated as needed to reflect change?', N'No', N'EVI does not currently maintain a formal BCP review cycle. Disaster recovery and operational procedures are reviewed and updated as needed.', N'Mount Pleasant CSD Vendor Assessment Tool / CoSN K-12 Vendor Assessment Lite', '2026-04-30', N'Educational Vistas, Inc.', NULL),
    (45, N'Business Continuity Plan', N'HLBC-04', N'Does your organization regularly test the failover or recovery of production environment for the purposes of BCP and continuity?', N'Yes', N'EVI tests backup, recovery, and restoration procedures as part of normal operations, maintenance, and incident response activities. Last test was on February 23, 2026.', N'Mount Pleasant CSD Vendor Assessment Tool / CoSN K-12 Vendor Assessment Lite', '2026-04-30', N'Educational Vistas, Inc.', NULL),
    (46, N'Change Management', N'HLCH-01', N'Do you have a documented and currently followed change management process for standard and emergency changes?', N'No', N'EVI does not currently maintain a formally documented Change Management Process. Standard and emergency changes are handled through internal operational review, testing, implementation, and post-change review.', N'Mount Pleasant CSD Vendor Assessment Tool / CoSN K-12 Vendor Assessment Lite', '2026-04-30', N'Educational Vistas, Inc.', NULL),
    (47, N'Change Management', N'HLCH-02', N'Will the district be notified of changes to your environment that could impact the district''s security posture or service availability?', N'Yes', N'EVI will notify impacted districts of material changes that could reasonably affect services. Notifications are handled through existing support, account management, and administrative communication channels.', N'Mount Pleasant CSD Vendor Assessment Tool / CoSN K-12 Vendor Assessment Lite', '2026-04-30', N'Educational Vistas, Inc.', NULL),
    (48, N'Change Management', N'HLCH-03', N'Do you have policy and procedure guiding how known vulnerabilities and zero day attack risks are mitigated until patches are available and applied?', N'Yes', N'EVI monitors security advisories, threat intelligence sources, current attack information, and known vulnerability announcements through automated internal Slack/n8n-based notifications. Security alerts, including zero-day and actively exploited vulnerabilities, are distributed to the technical team for review, prioritization, mitigation, and patching as needed.', N'Mount Pleasant CSD Vendor Assessment Tool / CoSN K-12 Vendor Assessment Lite', '2026-04-30', N'Educational Vistas, Inc.', NULL),
    (49, N'Data', N'HLDA-01', N'Do you logically separate institution''s data from that of other customers?', N'Yes', N'Institution/customer data is logically separated through tenant/district access boundaries, role-based permissions, and application/database access controls. Users are restricted to authorized district data only.', N'Mount Pleasant CSD Vendor Assessment Tool / CoSN K-12 Vendor Assessment Lite', '2026-04-30', N'Educational Vistas, Inc.', NULL),
    (50, N'Data', N'HLDA-02', N'Is sensitive data encrypted in transport?', N'Yes', N'Sensitive data is encrypted in transit using secure protocols such as HTTPS/TLS and secure file transfer methods where applicable.', N'Mount Pleasant CSD Vendor Assessment Tool / CoSN K-12 Vendor Assessment Lite', '2026-04-30', N'Educational Vistas, Inc.', NULL),
    (51, N'Data', N'HLDA-03', N'Is sensitive data encrypted in storage?', N'Yes', N'Sensitive data is protected at rest using encryption and access controls for hosted systems, storage, and backups where applicable.', N'Mount Pleasant CSD Vendor Assessment Tool / CoSN K-12 Vendor Assessment Lite', '2026-04-30', N'Educational Vistas, Inc.', NULL),
    (52, N'Data', N'HLDA-04', N'Do backups containing institution data ever leave the United States, either physically or via network routing?', N'No', N'EVI does not intentionally transfer or store institution backup data outside the United States. Hosted services and backup processes are maintained in U.S.-based environments.', N'Mount Pleasant CSD Vendor Assessment Tool / CoSN K-12 Vendor Assessment Lite', '2026-04-30', N'Educational Vistas, Inc.', NULL),
    (53, N'Data', N'HLDA-05', N'Do you have a media handling process that is documented and currently implemented, including end-of-life, repurposing, and data sanitization procedures?', N'No', N'EVI does not currently maintain a standalone formal media handling policy. Physical media handling for hosted infrastructure is managed through secure datacenter/provider controls, and internal data disposal is handled through operational procedures.', N'Mount Pleasant CSD Vendor Assessment Tool / CoSN K-12 Vendor Assessment Lite', '2026-04-30', N'Educational Vistas, Inc.', NULL),
    (54, N'Data', N'HLDA-06', N'Is any organization data visible in system administration modules/tools?', N'Yes', N'Limited institution data may be visible to authorized EVI personnel within administrative tools as needed for support, troubleshooting, maintenance, and authorized service delivery. Access is restricted to authorized personnel based on role and need.', N'Mount Pleasant CSD Vendor Assessment Tool / CoSN K-12 Vendor Assessment Lite', '2026-04-30', N'Educational Vistas, Inc.', NULL),
    (55, N'Database', N'HLDB-01', N'Does the database implement encryption of specified data elements in storage consistent with current encryption standards?', N'Yes', N'Sensitive data stored in databases is protected through encryption at rest, access controls, and restricted administrative access. Backups containing sensitive data are also protected through encryption and access controls.', N'Mount Pleasant CSD Vendor Assessment Tool / CoSN K-12 Vendor Assessment Lite', '2026-04-30', N'Educational Vistas, Inc.', NULL),
    (56, N'Datacenter', N'HLDC-01', N'Will any institution data leave the United States?', N'No', N'Institution data is hosted, stored, processed, and backed up within U.S.-based environments. EVI does not intentionally transfer institution data outside the United States.', N'Mount Pleasant CSD Vendor Assessment Tool / CoSN K-12 Vendor Assessment Lite', '2026-04-30', N'Educational Vistas, Inc.', NULL),
    (57, N'Datacenter', N'HLDC-02', N'Does your company own the physical data center where the institution''s data will reside?', N'No', N'EVI does not own the physical datacenter facility. Customer-facing hosted services are maintained in a secure third-party U.S.-based datacenter environment with physical and environmental controls managed by the hosting provider.', N'Mount Pleasant CSD Vendor Assessment Tool / CoSN K-12 Vendor Assessment Lite', '2026-04-30', N'Educational Vistas, Inc.', NULL),
    (58, N'Datacenter', N'HLDC-03', N'Does the hosting provider have a SOC 2 Type 2 report available?', N'Yes', N'EVI''s hosting provider maintains a SOC 2 Type II report. The report may be made available upon request under appropriate confidentiality or NDA requirements.', N'Mount Pleasant CSD Vendor Assessment Tool / CoSN K-12 Vendor Assessment Lite', '2026-04-30', N'Educational Vistas, Inc.', NULL),
    (59, N'Disaster Recovery Plan', N'HLDR-01', N'Do you have a Disaster Recovery Plan (DRP)?', N'Yes', N'EVI maintains a documented Disaster Recovery Plan covering hosted services, backup and restoration practices, recovery roles, disaster declaration criteria, customer communication, recovery systems, and annual review expectations.', N'Mount Pleasant CSD Vendor Assessment Tool / CoSN K-12 Vendor Assessment Lite', '2026-04-30', N'Educational Vistas, Inc.', NULL),
    (60, N'Disaster Recovery Plan', N'HLDR-02', N'Are any disaster recovery locations outside the institution''s of the United States?', N'No', N'Disaster recovery systems and backups are maintained in U.S.-based environments. EVI does not intentionally use disaster recovery locations outside the United States.', N'Mount Pleasant CSD Vendor Assessment Tool / CoSN K-12 Vendor Assessment Lite', '2026-04-30', N'Educational Vistas, Inc.', NULL),
    (61, N'Disaster Recovery Plan', N'HLDR-03', N'Are all components of the DRP reviewed at least annually and updated as needed to reflect change?', N'Yes', N'EVI''s Disaster Recovery Plan is scheduled for review at least annually and after material changes to infrastructure, hosting, applications, security posture, or recovery procedures.', N'Mount Pleasant CSD Vendor Assessment Tool / CoSN K-12 Vendor Assessment Lite', '2026-04-30', N'Educational Vistas, Inc.', NULL),
    (62, N'Firewalls, IDS, IPS, and Networking', N'HLFI-01', N'Are you utilizing a web application firewall (WAF) and/or a stateful packet inspection (SPI) firewall?', N'Yes', N'EVI uses firewall protections for both internal and hosted environments. HQ/internal services are protected by a Ubiquiti UDM-Pro, while customer-facing hosted services in the datacenter are protected by SonicWall firewall controls and hosting provider network controls.', N'Mount Pleasant CSD Vendor Assessment Tool / CoSN K-12 Vendor Assessment Lite', '2026-04-30', N'Educational Vistas, Inc.', NULL),
    (63, N'Firewalls, IDS, IPS, and Networking', N'HLFI-02', N'Do you have a documented policy for firewall change requests?', N'No', N'EVI does not currently maintain a formally documented firewall change request policy. Firewall changes are handled through internal operational review, testing, implementation, and post-change review as appropriate.', N'Mount Pleasant CSD Vendor Assessment Tool / CoSN K-12 Vendor Assessment Lite', '2026-04-30', N'Educational Vistas, Inc.', NULL),
    (64, N'Firewalls, IDS, IPS, and Networking', N'HLFI-03', N'Do you have automated threat monitoring and notification systems enabled?', N'Yes', N'EVI uses automated threat monitoring and notification processes, including internal Slack/n8n-based workflows that aggregate security advisories, threat intelligence, current attack information, zero-day alerts, and known vulnerability notices for technical team review.', N'Mount Pleasant CSD Vendor Assessment Tool / CoSN K-12 Vendor Assessment Lite', '2026-04-30', N'Educational Vistas, Inc.', NULL),
    (65, N'Firewalls, IDS, IPS, and Networking', N'HLFI-04', N'Is there a 24x7x365 monitoring and response process in place for intrusions?', N'No', N'EVI does not currently maintain a formal 24x7x365 security operations center for intrusion response. EVI uses firewall controls, monitoring, alerting, datacenter/provider controls, and technical staff review to identify and respond to security concerns.', N'Mount Pleasant CSD Vendor Assessment Tool / CoSN K-12 Vendor Assessment Lite', '2026-04-30', N'Educational Vistas, Inc.', NULL),
    (66, N'Physical Security', N'HLPH-01', N'Does your organization have physical security controls and policies in place?', N'Yes', N'EVI maintains physical security controls for its HQ/internal environment, including RFID card-based access controls. Customer-facing hosted systems are located in a secure third-party Latham datacenter with controlled physical access and rigorous visitor check-in/check-out procedures.', N'Mount Pleasant CSD Vendor Assessment Tool / CoSN K-12 Vendor Assessment Lite', '2026-04-30', N'Educational Vistas, Inc.', NULL),
    (67, N'Physical Security', N'HLPH-02', N'Are employees allowed to access or transport customer data, copy/store customer data on personally owned devices, or physically remove data from the protected infrastructure?', N'No', N'EVI does not allow employees to store customer data on personally owned devices or physically remove customer data from protected infrastructure as part of normal operations. Access to customer data is limited to authorized systems and personnel based on role and business need.', N'Mount Pleasant CSD Vendor Assessment Tool / CoSN K-12 Vendor Assessment Lite', '2026-04-30', N'Educational Vistas, Inc.', NULL),
    (68, N'Policies, Procedures, and Processes', N'HLPP-02', N'Are information security principles designed into the product lifecycle?', N'Yes', N'EVI incorporates information security principles into product development and system operations, including access controls, tenant separation, secure authentication, encryption, logging, patching, and review practices.', N'Mount Pleasant CSD Vendor Assessment Tool / CoSN K-12 Vendor Assessment Lite', '2026-04-30', N'Educational Vistas, Inc.', NULL),
    (69, N'Policies, Procedures, and Processes', N'HLPP-03', N'Do you have a formal, documented incident response plan that covers physical and cyber incident response and defined severity levels?', N'Yes', N'EVI maintains an internal Incident Response Plan that covers identification, triage, containment, eradication, recovery, notification, and post-incident review. The plan includes defined incident severity levels and applies to cybersecurity and related operational incidents.', N'Mount Pleasant CSD Vendor Assessment Tool / CoSN K-12 Vendor Assessment Lite', '2026-04-30', N'Educational Vistas, Inc.', NULL),
    (70, N'Systems Management & Configuration', N'HLSY-01', N'Do you employ network and administrative segmentation in the management of this service?', N'Yes', N'EVI uses network and administrative segmentation to separate systems and device classes, including internal systems, hosted/server infrastructure, VoIP, IoT, guest access, and administrative access. Access to management interfaces and sensitive systems is restricted to authorized personnel.', N'Mount Pleasant CSD Vendor Assessment Tool / CoSN K-12 Vendor Assessment Lite', '2026-04-30', N'Educational Vistas, Inc.', NULL),
    (71, N'Systems Management & Configuration', N'HLSY-02', N'Do you have standard hardened configurations for servers, appliances and mobile devices?', N'Yes', N'EVI applies standard secure configuration practices for servers and appliances, including restricted administrative access, MFA where supported, access controls, firewall rules, patching, logging/monitoring, encrypted backup keys, and secure backup handling.', N'Mount Pleasant CSD Vendor Assessment Tool / CoSN K-12 Vendor Assessment Lite', '2026-04-30', N'Educational Vistas, Inc.', NULL),
    (72, N'Systems Management & Configuration', N'HLSY-03', N'Do you encrypt company owned mobile devices?', N'No', N'EVI does not currently issue company-owned mobile devices. Access to company systems from mobile devices is controlled through authentication, authorization, and applicable application-level security controls.', N'Mount Pleasant CSD Vendor Assessment Tool / CoSN K-12 Vendor Assessment Lite', '2026-04-30', N'Educational Vistas, Inc.', NULL),
    (73, N'Vulnerability Scanning', N'HLVU-01', N'Have your systems and applications had a third party security assessment completed in the last year?', N'No', N'No third-party security assessment has been completed for customer-facing commercial applications in the last year. A security assessment/scan of internal applications was completed on March 25, 2026.', N'Mount Pleasant CSD Vendor Assessment Tool / CoSN K-12 Vendor Assessment Lite', '2026-04-30', N'Educational Vistas, Inc.', NULL),
    (74, N'Vulnerability Scanning', N'HLVU-02', N'Are your applications scanned for vulnerabilities?', N'Yes', N'EVI applications are scanned/reviewed for vulnerabilities, including recent implementation of AI-assisted vulnerability scanning for commercial applications. Findings are reviewed by technical staff.', N'Mount Pleasant CSD Vendor Assessment Tool / CoSN K-12 Vendor Assessment Lite', '2026-04-30', N'Educational Vistas, Inc.', NULL),
    (75, N'Vulnerability Scanning', N'HLVU-03', N'Are remediation efforts prioritized and completed according to risk severity?', N'Yes', N'Remediation is prioritized according to risk severity. Critical and high-risk findings are treated as highest priority and remediated/refactored promptly; lower-risk issues are scheduled based on impact and business risk.', N'Mount Pleasant CSD Vendor Assessment Tool / CoSN K-12 Vendor Assessment Lite', '2026-04-30', N'Educational Vistas, Inc.', NULL);

--------------------------------------------------------------------------------
-- Assessment metadata
--------------------------------------------------------------------------------
DECLARE @assessment_key NVARCHAR(100) = N'MTPLCSD_2026_VENDOR_SECURITY';
DECLARE @assessment_id INT;

MERGE dbo.cyber_assessments AS tgt
USING
(
    SELECT
        @assessment_key AS assessment_key,
        MAX(source_questionnaire) AS source_questionnaire,
        N'Mount Pleasant CSD' AS institution_name,
        MAX(CASE WHEN control_id = N'GNRL-01' THEN vendor_answer END) AS vendor_name,
        MAX(CASE WHEN control_id = N'GNRL-02' THEN vendor_answer END) AS product_name,
        CONVERT(DATE, N'2026-04-30') AS assessment_date,
        MAX(last_reviewed) AS last_reviewed,
        MAX(review_owner) AS review_owner,
        N'Normalized import generated from completed Educational Vistas vendor security questionnaire responses.' AS notes
    FROM #source_rows
) AS src
ON tgt.assessment_key = src.assessment_key
WHEN MATCHED THEN
    UPDATE SET
        source_questionnaire = src.source_questionnaire,
        institution_name = src.institution_name,
        vendor_name = src.vendor_name,
        product_name = src.product_name,
        assessment_date = src.assessment_date,
        last_reviewed = src.last_reviewed,
        review_owner = src.review_owner,
        notes = src.notes,
        updated_at = SYSUTCDATETIME()
WHEN NOT MATCHED THEN
    INSERT
    (
        assessment_key,
        source_questionnaire,
        institution_name,
        vendor_name,
        product_name,
        assessment_date,
        last_reviewed,
        review_owner,
        notes
    )
    VALUES
    (
        src.assessment_key,
        src.source_questionnaire,
        src.institution_name,
        src.vendor_name,
        src.product_name,
        src.assessment_date,
        src.last_reviewed,
        src.review_owner,
        src.notes
    );

SELECT @assessment_id = assessment_id
FROM dbo.cyber_assessments
WHERE assessment_key = @assessment_key;

--------------------------------------------------------------------------------
-- General/header information
--------------------------------------------------------------------------------
MERGE dbo.cyber_headers AS tgt
USING
(
    SELECT
        @assessment_id AS assessment_id,
        control_id AS header_key,
        question_text AS header_label,
        vendor_answer AS header_value,
        additional_information,
        sort_order,
        last_reviewed,
        review_owner,
        notes
    FROM #source_rows
    WHERE category_name = N'General Information'
) AS src
ON tgt.assessment_id = src.assessment_id
AND tgt.header_key = src.header_key
WHEN MATCHED THEN
    UPDATE SET
        header_label = src.header_label,
        header_value = src.header_value,
        additional_information = src.additional_information,
        sort_order = src.sort_order,
        last_reviewed = src.last_reviewed,
        review_owner = src.review_owner,
        notes = src.notes,
        updated_at = SYSUTCDATETIME()
WHEN NOT MATCHED THEN
    INSERT
    (
        assessment_id,
        header_key,
        header_label,
        header_value,
        additional_information,
        sort_order,
        last_reviewed,
        review_owner,
        notes
    )
    VALUES
    (
        src.assessment_id,
        src.header_key,
        src.header_label,
        src.header_value,
        src.additional_information,
        src.sort_order,
        src.last_reviewed,
        src.review_owner,
        src.notes
    );

--------------------------------------------------------------------------------
-- Categories
--------------------------------------------------------------------------------
MERGE dbo.cyber_categories AS tgt
USING
(
    SELECT
        @assessment_id AS assessment_id,
        category_name,
        MIN(sort_order) AS sort_order
    FROM #source_rows
    WHERE category_name <> N'General Information'
    GROUP BY category_name
) AS src
ON tgt.assessment_id = src.assessment_id
AND tgt.category_name = src.category_name
WHEN MATCHED THEN
    UPDATE SET
        sort_order = src.sort_order,
        updated_at = SYSUTCDATETIME()
WHEN NOT MATCHED THEN
    INSERT
    (
        assessment_id,
        category_name,
        sort_order
    )
    VALUES
    (
        src.assessment_id,
        src.category_name,
        src.sort_order
    );

--------------------------------------------------------------------------------
-- Question/control definitions
--------------------------------------------------------------------------------
MERGE dbo.cyber_questions AS tgt
USING
(
    SELECT
        c.category_id,
        sr.control_id,
        sr.question_text,
        sr.sort_order
    FROM #source_rows sr
    INNER JOIN dbo.cyber_categories c
        ON c.assessment_id = @assessment_id
       AND c.category_name = sr.category_name
    WHERE sr.category_name <> N'General Information'
) AS src
ON tgt.category_id = src.category_id
AND tgt.control_id = src.control_id
WHEN MATCHED THEN
    UPDATE SET
        question_text = src.question_text,
        sort_order = src.sort_order,
        is_active = 1,
        updated_at = SYSUTCDATETIME()
WHEN NOT MATCHED THEN
    INSERT
    (
        category_id,
        control_id,
        question_text,
        sort_order,
        is_active
    )
    VALUES
    (
        src.category_id,
        src.control_id,
        src.question_text,
        src.sort_order,
        1
    );

--------------------------------------------------------------------------------
-- Answers/responses
--------------------------------------------------------------------------------
MERGE dbo.cyber_responses AS tgt
USING
(
    SELECT
        @assessment_id AS assessment_id,
        q.question_id,
        sr.vendor_answer,
        sr.additional_information,
        sr.last_reviewed,
        sr.review_owner,
        sr.notes
    FROM #source_rows sr
    INNER JOIN dbo.cyber_categories c
        ON c.assessment_id = @assessment_id
       AND c.category_name = sr.category_name
    INNER JOIN dbo.cyber_questions q
        ON q.category_id = c.category_id
       AND q.control_id = sr.control_id
    WHERE sr.category_name <> N'General Information'
) AS src
ON tgt.assessment_id = src.assessment_id
AND tgt.question_id = src.question_id
WHEN MATCHED THEN
    UPDATE SET
        vendor_answer = src.vendor_answer,
        additional_information = src.additional_information,
        last_reviewed = src.last_reviewed,
        review_owner = src.review_owner,
        notes = src.notes,
        updated_at = SYSUTCDATETIME()
WHEN NOT MATCHED THEN
    INSERT
    (
        assessment_id,
        question_id,
        vendor_answer,
        additional_information,
        last_reviewed,
        review_owner,
        notes
    )
    VALUES
    (
        src.assessment_id,
        src.question_id,
        src.vendor_answer,
        src.additional_information,
        src.last_reviewed,
        src.review_owner,
        src.notes
    );

COMMIT TRANSACTION;
GO

--------------------------------------------------------------------------------
-- Verification queries
--------------------------------------------------------------------------------
SELECT 'cyber_assessments' AS table_name, COUNT(*) AS row_count FROM dbo.cyber_assessments
UNION ALL
SELECT 'cyber_headers', COUNT(*) FROM dbo.cyber_headers
UNION ALL
SELECT 'cyber_categories', COUNT(*) FROM dbo.cyber_categories
UNION ALL
SELECT 'cyber_questions', COUNT(*) FROM dbo.cyber_questions
UNION ALL
SELECT 'cyber_responses', COUNT(*) FROM dbo.cyber_responses;
GO

-- Main application-friendly view of the completed questionnaire.
SELECT
    a.assessment_key,
    a.institution_name,
    a.vendor_name,
    a.product_name,
    c.category_name,
    q.sort_order,
    q.control_id,
    q.question_text,
    r.vendor_answer,
    r.additional_information,
    r.last_reviewed,
    r.review_owner
FROM dbo.cyber_assessments a
INNER JOIN dbo.cyber_categories c
    ON c.assessment_id = a.assessment_id
INNER JOIN dbo.cyber_questions q
    ON q.category_id = c.category_id
INNER JOIN dbo.cyber_responses r
    ON r.assessment_id = a.assessment_id
   AND r.question_id = q.question_id
WHERE a.assessment_key = N'MTPLCSD_2026_VENDOR_SECURITY'
ORDER BY c.sort_order, q.sort_order;
GO
