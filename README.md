# LysStack

LysStack is the engineering knowledge and bounded-context repository for
project policy, decisions, constraints, human-authored task briefs, lessons,
and long-term memory. It does not execute agents or schedule runtime jobs, and
it does not contain product source code.

Hermes is the authoritative engineering execution runtime. It consumes a
bounded selection of LysStack context and owns job/task state, orchestration,
agent execution, worktrees, verification, event history, recovery, and provider
capacity handling. LysControl presents Hermes through its REST/SSE API.

```text
Human
  ↓
LysStack
  ↓
Hermes
  ↓
Workers
  ↓
Product repositories
```

**LysStack never executes agents. Hermes executes agents.** Human review and
approval remain required before merge.

## Start Here

Begin with [`AGENTS.md`](AGENTS.md), then follow
[`docs/start_here.md`](docs/start_here.md) and the assignment in
[`operating_system/active_task.md`](operating_system/active_task.md).

The canonical governed delivery process is documented in
[`operating_system/hermes-delivery.md`](operating_system/hermes-delivery.md).

The earlier Claude → DeepSeek → Qwen/Aider → Codex issue-to-PR process and its
helper scripts remain available as an
[`optional legacy workflow`](operating_system/github-issue-to-pr.md).
