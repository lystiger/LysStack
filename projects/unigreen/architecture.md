# Unigreen Architecture

## Product Position

Uni-Green v1 is a **B2B catalogue + quotation-to-order platform**. It is not
generic ecommerce, a checkout/payment platform, an ERP, or a microservices
system.

```text
Catalogue → Inquiry → Sales Review → Quotation → Customer Decision
          → Purchase Order → Sales Order → Fulfilment
```

## Backend

The current stack is Python 3.12, FastAPI, Pydantic v2, SQLAlchemy 2.x,
Alembic, PostgreSQL 16, Redis, Dramatiq/background worker, and Docker with
Docker Compose.

The architecture is a modular monolith:

- Modules own their tables and business behavior.
- API routers remain thin; business rules belong in services/domain logic.
- ORM models are not returned directly as API contracts.
- Cross-module access and transactions remain explicit.
- External providers sit behind adapters.
- Database changes use migrations.
- The backend remains contract-first.

Implemented modules include:
- Backend: `catalogue/`, `auth/`, `staff/`, `audit/`, `media/`, and `inquiries/`
  (public submission, snapshots, reference generation, mailers).
- Frontend: Next.js (App Router), TypeScript, Tailwind CSS, TanStack Query,
  bilingual routing (`/vi`, `/en`), inquiry basket, public inquiry flow, and
  staff admin foundation (`/admin/products`, `/admin/categories`).

## Repository Boundary

Product source lives in `lystiger/Unigreen`. LysStack stores only context,
policy, decisions, task state, and lessons. Hermes performs execution against
the product repository.

## Current Slice Scope (UG-001)

`UG-001` is a full-stack slice:
- Backend: staff-authorized inquiry list, detail, filtering/search, status
  transitions, staff assignment, internal notes, and audit events.
- Frontend: staff inquiry review workspace under `/admin/inquiries` hosted in
  `AdminShell`.

