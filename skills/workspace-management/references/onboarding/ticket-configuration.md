# Ticket configuration

Task ID: `ticket_configuration`

Read `../workspace-management/references/workspace-settings.md`. Call `z360-read-search-ticket-settings` to inspect current ticket types, priorities, statuses, ownership defaults, and routing behavior before proposing changes.

Explain the current lifecycle in plain language and configure only the requested settings. Fetch the fresh schema for the narrowest matching action: `z360-write-create-ticket-setting`, `z360-write-update-ticket-setting`, `z360-write-set-default-ticket-setting`, or `z360-write-reorder-ticket-statuses`. Confirm shared workflow changes, then call `z360-read-search-ticket-settings` again to verify the saved configuration before marking the task done.

If an onboarding preset was selected, follow [Onboarding presets](presets.md) for its ticket-type resources, then verify the resulting configuration through the workflow above.
