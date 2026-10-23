# VM Hunter — Roadmap

Each step is one Hermes goal job, smallest first. Each must pass the repository checks before merge.

1. **Check environment.** A static checker for workflow JSON (valid structure, connections point at
   real nodes, no secrets, cost-guard rules) with its own tests, and a local n8n (pinned, Docker) that
   imports every workflow. One command runs it all.
2. **Notifications.** A reusable "notify Discord" workflow, and an error workflow that reports any
   failed workflow to Discord.
3. **Offer watcher.** Reads the D4 sources on a schedule, keeps new offers only, reports each once.
4. **Oracle A1 claimer.** Signed launch request, cost guard, 60-second-plus polling with jitter,
   "out of capacity" handled as a normal retry, stop and report on success. Settles O1.
5. **VM setup guide.** How Lystiger installs the pinned n8n on their VM, sets the environment, and
   imports the workflows. Lystiger runs it; agents do not.

Later: more providers (one skill each), Telegram, a weekly summary.
