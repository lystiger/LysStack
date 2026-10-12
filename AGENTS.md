# AGENTS.md

This is the auto-loaded entry point for AI coding agents working with LysStack.

LysStack is the engineering knowledge and bounded-context repository. It
stores project policy, decisions, constraints, human-authored task briefs,
lessons, and long-term memory. Product source code lives in separate
repositories. Hermes owns canonical job/task execution state and scheduling.

## Core Invariant

**LysStack does not execute agents or schedule runtime jobs. Hermes owns
engineering execution and its canonical job/task state.**

Human approval is always required before merge.

## Canonical Governed Delivery Workflow

```text
Human-authored task brief in LysStack
         ↓
bounded project context
         ↓
Hermes
  ├── BUILDER
  ├── HARDENER
  └── VERIFIER
         ↓
deterministic verification
         ↓
Human review
```

Hermes owns execution, job/task state, scheduling, Git governance, phase
handoffs, verification, and run evidence in the target product repository.
Workflow roles describe responsibilities; they are not tied permanently to a model or provider.

The canonical process is documented in
[operating_system/hermes-delivery.md](operating_system/hermes-delivery.md).

## Legacy and Optional Workflows

The Claude issue writer, DeepSeek planner, Qwen/Aider coder, Codex reviewer,
and their helper scripts remain available as optional specialist or legacy
workflows. They are not the canonical execution pipeline.

- [Legacy issue-to-PR workflow](operating_system/github-issue-to-pr.md)
- [Qwen/Aider launcher](scripts/start-qwen-aider.sh)
- [Diff review helper](scripts/review-diff.sh)

## Before You Start

Read the startup protocol in [docs/start_here.md](docs/start_here.md) and the
working rules in [docs/instructions.md](docs/instructions.md). Confirm the
assignment in [operating_system/active_task.md](operating_system/active_task.md)
before implementation begins.

## Hard Constraints

- Never commit secrets, credentials, PII, or private business data.
- Never auto-merge; human approval is required before promotion.
- Keep this repository Markdown-first and config-only; product source belongs
  in its product repository.
- Do not add heavy agent frameworks without an explicit decision recorded in
  `memory/decisions.md`.
