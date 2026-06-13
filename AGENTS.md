# AGENTS.md

This is the auto-loaded entry point for AI coding agents working in LysStack.

LysStack is a **brain / config repo**. It holds the workflow, agent roles,
planning documents, and long-term memory. It does **not** hold the source code
for product projects (AOI, SilentVoix, HASC, and similar). Those live in their
own repositories. Run the coding workflow inside the relevant project repo; run
planning and coordination here.

## Core Rule

**AI assists. Humans decide.** No agent merges anything. Human approval is
always required before merge.

## AI Coding Workflow

LysStack runs a GitHub issue-to-PR pipeline with one agent per stage:

| Stage | Agent | Role file |
| --- | --- | --- |
| Write the issue | Claude | [agents/claude-issue-writer.md](agents/claude-issue-writer.md) |
| Plan the implementation | DeepSeek | [agents/deepseek-planner.md](agents/deepseek-planner.md) |
| Write the code locally | Qwen + Aider | [agents/qwen-coder.md](agents/qwen-coder.md) |
| Review the change | Codex | [agents/codex-reviewer.md](agents/codex-reviewer.md) |
| Merge | Lystiger (human) | final authority — no agent merges |

The full step-by-step process and example commands are in
[operating_system/github-issue-to-pr.md](operating_system/github-issue-to-pr.md).

Helper scripts:

- [scripts/start-qwen-aider.sh](scripts/start-qwen-aider.sh) — launch Aider with a local Qwen model
- [scripts/review-diff.sh](scripts/review-diff.sh) — produce a diff and changed-file list for review

## Standing Roles vs Workflow Roles

The role files above define **workflow stage** responsibilities for the
coding pipeline. The broader LysStack team model and standing project roles
(design, engineering, research, QC) live in [docs/team.md](docs/team.md) and
[agents/](agents/). They complement each other: an agent may wear a standing
role on a project and a stage role in the coding pipeline.

## Before You Start

Read the startup protocol in [docs/start_here.md](docs/start_here.md) and the
working rules in [docs/instructions.md](docs/instructions.md). Confirm the
assignment in [operating_system/active_task.md](operating_system/active_task.md)
before implementing.

## Hard Constraints

- Never commit secrets or API keys.
- Never auto-merge; open a PR and stop.
- Keep this repo markdown-first and config-only — no product source code here.
- Do not add heavy agent frameworks (CrewAI, AutoGen, LangGraph, MCP) without
  an explicit decision recorded in `memory/decisions.md`.
