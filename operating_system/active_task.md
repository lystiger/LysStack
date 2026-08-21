# Active Task

This file is the source of truth for the current executable assignment.

## Assignment

- **Status:** Ready
- **Project:** Unigreen
- **Owner:** Hermes
- **QC/PM reviewer:** VERIFIER
- **Priority:** High
- **Assigned:** 2026-08-21
- **Target date:** Not assigned

## Goal

Execute the first governed Hermes vertical slice: **Core Public Inquiry
Submission**.

## Target

- **Repository:** `lystiger/Unigreen`
- **Pinned baseline:** `16b1b30579b788e3502874b3c54bde7a601e5404`
- **Scope:** Backend only

## Acceptance Criteria

- [ ] `POST /api/v1/public/inquiries` returns HTTP 201
- [ ] An inquiry requires one or more lines
- [ ] Quantities are greater than zero
- [ ] Only existing, published products may be referenced
- [ ] A human-readable inquiry reference is generated
- [ ] Inquiry and lines persist atomically
- [ ] Repeated `Idempotency-Key` use does not create duplicates
- [ ] New behavior has automated tests
- [ ] Existing checks remain green
- [ ] The OpenAPI contract remains synchronized

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

Follow `projects/unigreen/constraints.md`. Do not modify product source until a
Hermes sprint has passed dry-run readiness.

## Verification

Run the existing Unigreen backend quality pipeline from the target repository:

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

## Blockers

- None recorded.

## Completion Record

- **Completed:** Not completed
- **Summary:** Hermes execution has not begun.
- **Verification results:** Not run.
- **QC/PM recommendation:** Not available.
- **Documentation updated:** Unigreen context prepared in LysStack.
