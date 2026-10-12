# Business profile and AI basics

Task ID: `business_profile_ai_basics`

Read `../workspace-management/references/workspace-settings.md`, then review `/memories/org/AGENTS.md`. Use the Z360 action group and fetch a fresh schema before every action.

1. Use `z360-read-get-organization-details` and `z360-read-get-agent-config` to read the supported application settings. Ask only for missing or uncertain information.
2. Confirm the organization name, industry, website, phone, email, what the business does, its main customers, and the outcomes expected from Z360. Use `z360-write-update-organization-details` only when the confirmed organization name must change; keep the remaining concise business facts in `/memories/org/AGENTS.md`.
3. Explain briefly that the agent name is customer-facing. Ask the user to choose a name or explicitly accept the default `Z`; do not silently skip this choice.
4. When the name changes, use `z360-write-update-agent-config` with the complete required payload and preserve all three current channel defaults from the read result.
5. Read the organization and agent configuration back, then reread the saved memory before marking the task done.

Do not infer an industry from the organization name or overwrite reliable existing context without confirmation.
