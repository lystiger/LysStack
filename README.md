# LysStack

My personal AI-agent orchestration system for engineering, research, and long-term project memory.

LysStack helps coordinate coding agents, preserve decisions, document projects, and turn AI tools into a reusable engineering workflow.

## Purpose

- Preserve project memory
- Coordinate Claude, Codex, Gemini, and future local agents
- Standardize prompts and roles
- Track architecture decisions
- Build an external brain for long-term engineering growth

## Core Idea

AI assists. Humans decide.

## Start Here

New agents should begin with [`docs/start_here.md`](docs/start_here.md), then
follow the active assignment in
[`operating_system/active_task.md`](operating_system/active_task.md).

AI coding agents should read [`AGENTS.md`](AGENTS.md) for the entry point.

## AI Coding Workflow

LysStack runs a GitHub issue-to-PR pipeline, one agent per stage:

| Stage | Agent |
| --- | --- |
| Write the issue | Claude |
| Plan the implementation | DeepSeek |
| Write the code locally | Qwen + Aider |
| Review the change | Codex |
| Merge | Lystiger (human, final authority) |

The process and example commands are in
[`operating_system/github-issue-to-pr.md`](operating_system/github-issue-to-pr.md).
Helper scripts live in [`scripts/`](scripts/).

**AI assists. Humans decide.** No agent merges — human approval is always
required before merge.
