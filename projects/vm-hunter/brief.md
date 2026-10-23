# VM Hunter — Brief

**Owner:** Lystiger · **Built by:** Hermes (goal-planned jobs) · **Started:** 2026-10-23
**Repository:** `lystiger/vm-hunter` (`~/Projects/vm-hunter`)

## What it is

An always-on set of n8n workflows, running on Lystiger's own VM, that does two jobs:

1. **Claim:** keeps trying to create scarce free-tier VMs in Lystiger's own cloud accounts until one
   succeeds. The first target is Oracle Cloud's Always Free Ampere A1 shape, which usually fails with
   "Out of host capacity".
2. **Watch:** watches public sources for new free server or VM offers and reports the new ones.

Both send their results to Discord (a webhook). Telegram can be added later.

## Why n8n

Lystiger wants a workflow they can see and change in the n8n editor on their VM, not a hidden script.
The repository is still the source of truth: workflows are stored as exported JSON, reviewed in pull
requests, and imported into the VM's n8n by Lystiger.

## Success

- A claim attempt runs on a schedule, survives a provider error, and stops once a VM exists.
- Nothing the hunter does can cost money: only free-tier shapes and sizes, checked before every request.
- A new offer is reported once, with its source link, and never again.
- Every failure of a workflow reaches Discord, so a silent stop is impossible.
- Every workflow passes the repository's checks before it is merged.
- Lystiger gets one daily summary line per workflow at 09:00; a missing line means something is down.

## Out of scope

- Paid resources of any kind, or anything that changes an account's billing.
- Agents touching the VM: Lystiger installs n8n there and imports reviewed workflows.
- Scraping that breaks a site's terms; sources are feeds and public APIs.
- Using other people's accounts or bypassing a provider's limits.

## Context

This is also the first project Hermes builds from repository instructions (`AGENTS.md` and skills)
instead of hand-written prompt files. Every Hermes problem met while building it goes into
`error-log.md` in this folder.
