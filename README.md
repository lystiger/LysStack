# LysStack

LysStack is the engineering knowledge and brief repository for the Hermes
stack: project policy, decisions, constraints, lessons, human-authored task
briefs, and long-term memory. It does not execute agents or schedule jobs, and
it contains no product source code.

Hermes is the execution runtime. It takes a brief, runs the BUILDER, HARDENER
and VERIFIER phases against a product repository, and records job and task
state and run evidence. LysControl presents Hermes through its REST/SSE API.

```text
Human
  ↓
LysStack (brief)
  ↓
Hermes
  ↓
Workers (BUILDER, HARDENER, VERIFIER)
  ↓
Product repositories
```

**LysStack never executes agents. Hermes executes agents.** Human review and
approval remain required before merge.

## Start Here

Read [`AGENTS.md`](AGENTS.md) first. It holds the rules, roles, task lifecycle,
and decision recording. Then read
[`operating_system/current_focus.md`](operating_system/current_focus.md) and
[`operating_system/active_task.md`](operating_system/active_task.md).

The delivery process is in
[`operating_system/hermes-delivery.md`](operating_system/hermes-delivery.md).

Older planning documents, the legacy issue-to-PR workflow, the old agent role
files, and the four inactive projects are in [`archive/`](archive/).
