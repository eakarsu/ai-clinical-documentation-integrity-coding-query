CREATE TABLE IF NOT EXISTS app_users(
  id BIGSERIAL PRIMARY KEY,email TEXT UNIQUE NOT NULL,name TEXT NOT NULL,role TEXT NOT NULL,password_hash TEXT NOT NULL,created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE TABLE IF NOT EXISTS workflow_cases(
  id BIGSERIAL PRIMARY KEY,workflow_id TEXT NOT NULL,reference TEXT UNIQUE NOT NULL,subject TEXT NOT NULL,owner TEXT NOT NULL,state TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,payload JSONB NOT NULL DEFAULT '{}'::jsonb,created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE TABLE IF NOT EXISTS audit_events(
  id BIGSERIAL PRIMARY KEY,event_time TIMESTAMPTZ NOT NULL DEFAULT NOW(),actor TEXT NOT NULL,action TEXT NOT NULL,object_type TEXT NOT NULL,object_reference TEXT NOT NULL,detail TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS saved_analyses(
  id BIGSERIAL PRIMARY KEY,workflow_id TEXT NOT NULL,actor TEXT NOT NULL,analysis_type TEXT NOT NULL,inputs JSONB NOT NULL,result JSONB NOT NULL,provider TEXT NOT NULL,model TEXT,created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE TABLE IF NOT EXISTS integration_state(
  id TEXT PRIMARY KEY,name TEXT NOT NULL,category TEXT NOT NULL,mode TEXT NOT NULL,status TEXT NOT NULL,last_tested TIMESTAMPTZ
);
CREATE INDEX IF NOT EXISTS idx_workflow_cases_workflow ON workflow_cases(workflow_id);
CREATE INDEX IF NOT EXISTS idx_workflow_cases_due ON workflow_cases(due_date);
CREATE INDEX IF NOT EXISTS idx_audit_events_time ON audit_events(event_time DESC);

CREATE TABLE IF NOT EXISTS "op_prebill"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_encounterId" TEXT NOT NULL,
  "data_serviceLine" TEXT NOT NULL,
  "data_proposedCodes" TEXT NOT NULL,
  "data_clinicalSummary" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_prebill_due ON "op_prebill"(due_date);

CREATE TABLE IF NOT EXISTS "op_query"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_provider" TEXT NOT NULL,
  "data_encounterId" TEXT NOT NULL,
  "data_clinicalIndicators" TEXT NOT NULL,
  "data_clarificationNeeded" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_query_due ON "op_query"(due_date);

CREATE TABLE IF NOT EXISTS "op_denial_risk"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_payer" TEXT NOT NULL,
  "data_procedure" TEXT NOT NULL,
  "data_documentationGap" TEXT NOT NULL,
  "data_riskLevel" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_denial_risk_due ON "op_denial_risk"(due_date);

CREATE TABLE IF NOT EXISTS "op_drg"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_encounterId" TEXT NOT NULL,
  "data_assignedDrg" TEXT NOT NULL,
  "data_principalDiagnosis" TEXT NOT NULL,
  "data_validationNotes" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_drg_due ON "op_drg"(due_date);

CREATE TABLE IF NOT EXISTS "op_quality"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_measure" TEXT NOT NULL,
  "data_encounterId" TEXT NOT NULL,
  "data_requiredEvidence" TEXT NOT NULL,
  "data_evidenceStatus" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_quality_due ON "op_quality"(due_date);

CREATE TABLE IF NOT EXISTS "op_provider_education"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_provider" TEXT NOT NULL,
  "data_specialty" TEXT NOT NULL,
  "data_pattern" TEXT NOT NULL,
  "data_educationGoal" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_provider_education_due ON "op_provider_education"(due_date);

CREATE TABLE IF NOT EXISTS "op_appeal"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_denialId" TEXT NOT NULL,
  "data_denialReason" TEXT NOT NULL,
  "data_amount" NUMERIC(16,2) NOT NULL,
  "data_appealEvidence" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_appeal_due ON "op_appeal"(due_date);

CREATE TABLE IF NOT EXISTS "op_analytics"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_period" TEXT NOT NULL,
  "data_serviceLine" TEXT NOT NULL,
  "data_encounterCount" NUMERIC(16,2) NOT NULL,
  "data_analysisQuestion" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_analytics_due ON "op_analytics"(due_date);

CREATE TABLE IF NOT EXISTS "op_provider_roster"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_provider" TEXT NOT NULL,
  "data_npi" TEXT NOT NULL,
  "data_specialty" TEXT NOT NULL,
  "data_queryResponseRate" NUMERIC(16,2) NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_provider_roster_due ON "op_provider_roster"(due_date);

CREATE TABLE IF NOT EXISTS "op_payer_policies"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_payer" TEXT NOT NULL,
  "data_policyId" TEXT NOT NULL,
  "data_service" TEXT NOT NULL,
  "data_effectiveDate" DATE NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_payer_policies_due ON "op_payer_policies"(due_date);

CREATE TABLE IF NOT EXISTS "op_query_templates"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_template" TEXT NOT NULL,
  "data_scenario" TEXT NOT NULL,
  "data_queryType" TEXT NOT NULL,
  "data_approvedLanguage" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_query_templates_due ON "op_query_templates"(due_date);

CREATE TABLE IF NOT EXISTS "op_denial_reasons"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_reasonCode" TEXT NOT NULL,
  "data_category" TEXT NOT NULL,
  "data_appealDays" NUMERIC(16,2) NOT NULL,
  "data_requiredEvidence" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_denial_reasons_due ON "op_denial_reasons"(due_date);
