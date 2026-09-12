# Active Task

This file is the source of truth for the current executable assignment.

## Assignment

- **Task ID:** UG-001
- **Status:** Ready
- **Project:** Unigreen
- **Owner:** Hermes
- **QC/PM reviewer:** VERIFIER
- **Priority:** High
- **Assigned:** 2026-09-12
- **Target date:** Not assigned

## Goal

Execute the governed Hermes vertical slice: **Staff Inquiry Review Workspace**.

Establish the internal staff workflow needed after public inquiry submission:
```text
Customer inquiry
      ↓
staff review
      ↓
qualification / assignment / internal notes
      ↓
later quotation creation
```

## Target

- **Repository:** `lystiger/Unigreen`
- **Pinned baseline:** `069aed0630f3d121cdf28bec03f68bc99cfb8123`
- **Scope:** Full-stack (FastAPI backend + Next.js staff admin frontend)

## Bounded Context Files

- `projects/unigreen/architecture.md`
- `projects/unigreen/constraints.md`
- `projects/unigreen/decisions.md`
- `projects/unigreen/agents.md`
- `projects/unigreen/roadmap.md`
- `operating_system/active_task.md`

## Scope

### Backend
- Staff-authorized inquiry list endpoint (`GET /api/v1/staff/inquiries`)
- Inquiry detail endpoint (`GET /api/v1/staff/inquiries/{id}`)
- Search and filtering by status, reference, or company name
- Staff-controlled operational inquiry status transitions (`new`, `qualified`, `quoted`, `won`, `lost`, `spam`, `duplicate`)
- Staff assignment to active `StaffUser` records (`assigned_staff_id`)
- Internal notes: persistent staff-authored notes stored separately from customer submission
- Audit events: emit `AuditEvent` records for all staff mutations (status changes, assignments, notes)
- Backend authorization: enforce staff session authentication and `Permission` checks (`inquiry:read`, `inquiry:write`)

### Frontend
- Staff inquiry list workspace under `/admin/inquiries` integrated into `AdminShell`
- Inquiry detail view displaying original customer submission data verbatim
- Staff operational status controls
- Staff assignment UI
- Internal notes UI (display note history and allow adding internal notes)
- Strict data separation: original customer submission remains immutable and visually distinct from staff operational metadata

## Explicit Non-Goals

UG-001 must NOT include:
- Quotation creation or quotation line editing
- Quotation pricing, margin calculations, or discounts
- Quotation PDF generation
- Customer quotation acceptance or rejection
- Purchase-order (PO) upload or processing
- Sales-order creation or conversion
- Shipment, delivery, or inventory fulfilment
- EasyBooks accounting integration
- UniOps platform/observability integration
- Autonomous AI business decisions or auto-replies
- Large architecture refactors or microservices
- New generic workflow or BPMN engines

## Acceptance Criteria

- [ ] 1. Authorized staff can list inquiries with pagination and summary data
- [ ] 2. Authorized staff can open and inspect inquiry detail
- [ ] 3. Useful search and filtering works (by status, reference, or company name)
- [ ] 4. Staff can update an operational inquiry status
- [ ] 5. Staff can assign an inquiry to a valid staff user
- [ ] 6. Staff can add internal notes without overwriting customer-submitted notes
- [ ] 7. The original customer-submitted inquiry data remains preserved and immutable
- [ ] 8. Staff mutations and endpoints are strictly authorized backend-side
- [ ] 9. Relevant mutations generate structured `AuditEvent` records
- [ ] 10. Existing public inquiry submission behavior and mailers continue to work
- [ ] 11. Existing backend and frontend quality checks remain green
- [ ] 12. OpenAPI schema and frontend generated API contracts (`lib/api/schema.d.ts`) remain synchronized

## Execution Model

```text
LysStack
   ↓
Hermes
   ↓
BUILDER
   ↓
HARDENER
   ↓
VERIFIER
   ↓
deterministic verification
   ↓
human review
```

LysStack supplies context and policy. Hermes owns execution and evidence.
Human approval is required before promotion.

## Constraints

Follow `projects/unigreen/constraints.md` and `projects/unigreen/decisions.md`.
Do not modify product source until a Hermes sprint has passed dry-run readiness (`DRY_RUN_READY`).

## Verification

Run the Unigreen quality pipelines from the target repository:

### Backend
```bash
cd backend
uv sync --all-groups
uv run ruff format --check .
uv run ruff check .
uv run mypy src tests
uv run pytest
uv run python scripts/export_openapi.py /tmp/openapi.json
diff -u ../contracts/openapi.json /tmp/openapi.json
```

### Frontend
```bash
cd frontend
npm ci
npm run format:check
npm run lint
npm run typecheck
npm run test
npm run build
npm run api:types
git diff --exit-code lib/api/schema.d.ts
```

## Blockers

- None recorded. Target repository working tree is clean and baselined at `069aed0630f3d121cdf28bec03f68bc99cfb8123`.

## Completion Record

- **Completed:** Not completed
- **Summary:** UG-001 context prepared in LysStack. Ready for Hermes sprint specification and dry-run preflight.
- **Verification results:** Not run.
- **QC/PM recommendation:** Pending execution.
- **Documentation updated:** LysStack governance updated for UG-001 baseline; predecessor milestone archived in `projects/unigreen/roadmap.md`.
