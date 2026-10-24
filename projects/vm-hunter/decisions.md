# VM Hunter — Decisions

## 2026-10-23 — Starting decisions

| # | Decision | Why |
|---|---|---|
| D1 | Both jobs: claim scarce free capacity and watch for offers. | Lystiger's choice. |
| D2 | First claim target: Oracle Cloud Always Free, `VM.Standard.A1.Flex`. | The best-known free VM that is hard to get; more providers come as separate skills. |
| D3 | Notifications go to a Discord webhook; Telegram later if wanted. | Lystiger accepts either; a webhook needs no bot. |
| D4 | First watch sources: the `ripienaar/free-for-dev` list (new entries in its server sections) and the LowEndBox RSS feed (posts that say "free"). | Public, stable, allowed to read; no scraping. |
| D5 | Workflows live in the repository as exported JSON; the VM's n8n is a copy. | Reviewable changes, and the VM can be rebuilt. |
| D6 | "Seen" offers and claim state live in n8n workflow static data, not an extra database. | Keeps the VM to one service. |
| D7 | Secrets never appear in workflow JSON or the repository. Workflows read them from n8n credentials or environment variables named in `.env.example`. | Workflow JSON is committed and shared. |
| D8 | Agents never deploy. Lystiger installs n8n on the VM and imports workflows. | Matches the role rules: Lystiger merges and deploys. |
| D9 | A cost guard runs before every create request: free shape only, within the free limits. | A bug must not be able to cost money. |
| D10 | Claim polling waits at least 60 seconds between attempts, with jitter, and stops after success. | Respect provider limits and avoid account flags. |

## 2026-10-23 — Discord forum and monitoring

| # | Decision | Why |
|---|---|---|
| D11 | The webhook posts into a Discord **forum**, so every message names a thread (`thread_id`). One room for now (`HUNTER_DISCORD_THREAD_ID`); optional per-kind rooms (`HUNTER_DISCORD_THREAD_OFFERS`, `_CLAIMS`, `_FAILURES`, `_SUMMARY`) fall back to it. | Discord rejects forum posts without a thread; Lystiger will add rooms later. |
| D12 | Monitoring as proposed: each workflow counts its outcomes in its static data, posts its own daily summary line at 09:00 (local), and reports alert conditions at once. The thresholds are in the `monitoring` skill. | Static data is per workflow, so no workflow can read another's counters. |
| D13 | No outside heartbeat service (healthchecks.io skipped). A dead n8n or VM stays silent; the missing 09:00 summary is the signal. | Lystiger's choice: no extra external service. |

## 2026-10-24 — Signing settled

| # | Decision | Why |
|---|---|---|
| D14 | O1 settled: Oracle requests are signed in a Code node with `require('crypto')`; the VM sets `NODE_FUNCTION_ALLOW_BUILTIN=crypto`. | Tested on the pinned n8n 1.123.87: RSA-SHA256 signing works with the setting and fails with `Cannot find module 'crypto'` without it. |

## Open questions

- **O2 — Which n8n version to pin** for the local check environment and the VM. Set by the first job.
