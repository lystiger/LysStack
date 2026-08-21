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

The relevant implemented module is `catalogue/`. The first new business module
is `inquiries/`.

## Repository Boundary

Product source lives in `lystiger/Unigreen`. LysStack stores only context,
policy, decisions, task state, and lessons. Hermes performs execution against
the product repository.

## First Experiment Scope

The first Hermes experiment is backend only. It includes no frontend work.
