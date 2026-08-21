# LysStack

LysStack is a control-plane repository for engineering context, policy, task
state, decisions, and long-term memory. It does not execute coding agents or
contain product source code.

Hermes is the execution runtime. It consumes a bounded selection of LysStack
context, governs workers and Git activity in target product repositories, and
records verification evidence.

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
