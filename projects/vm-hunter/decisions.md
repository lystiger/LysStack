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

## Open questions

- **O1 — Signing Oracle requests inside n8n.** The plan is a Code node using Node's `crypto`, which needs
  `NODE_FUNCTION_ALLOW_BUILTIN=crypto`, with the key passed in by environment variable. The first claim
  job should confirm this works on the pinned n8n version, or propose the alternative (the OCI CLI in a
  custom n8n image).
- **O2 — Which n8n version to pin** for the local check environment and the VM. Set by the first job.
