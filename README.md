# LysStack

LysStack is the engineering knowledge and brief repository for the Hermes
stack: project policy, decisions, constraints, lessons, human-authored task
briefs, and long-term memory. It does not execute agents or schedule jobs, and
it contains no product source code.

Hermes is the execution runtime. It takes a brief, runs the sprint's phases
against a product repository, and records job and task state and run evidence.
Each phase has a role (BUILDER, HARDENER, VERIFIER or SECURITY) set in the
sprint spec; roles belong to phases, not to agents. LysControl presents Hermes
through its REST/SSE API and shows each job's phases by role on a run timeline.

```text
Human
  ↓
LysStack (brief)
  ↓
Hermes
  ↓
Phases, each with a role (BUILDER, HARDENER, VERIFIER, SECURITY)
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
