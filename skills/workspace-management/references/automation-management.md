---
name: automation-management
description: "Create, inspect, run, update, pause, and delete Z360 AI Studio automations that run the main agent on a schedule or an application event. Read this reference when repeatable work should start without a new chat or when an existing automation needs management."
---

# Automation management

Read `../product-model/references/automations.md` for the product definition and `../product-model/contrasts/skills-vs-automations.md` or `../product-model/contrasts/automations-vs-reminders.md` when the requested behavior could be a different object. Use the Z360 action catalog for current action groups, automation records, trigger options, schemas, permissions, and connected accounts. The catalog is the source of truth when its current response differs from this reference.

This reference covers automation management, lifecycle decisions, current trigger and schedule constraints, and tool-specific execution. The product-model reference covers what an automation means; keep that conceptual definition separate from this operational workflow.

## Supported automation types

### Schedules

A schedule runs the main agent according to `schedule_rrule` in the required IANA `schedule_timezone`. The service calculates `next_run_at` for an active schedule. A paused schedule has no next run.

The schedule options returned by `get-automation-options` include these current presets:

| Preset | RRULE |
| --- | --- |
| `hourly` | `FREQ=HOURLY` |
| `daily` | `FREQ=DAILY;BYHOUR=9;BYMINUTE=0` |
| `weekly` | `FREQ=WEEKLY;BYDAY=MO,WE,FR;BYHOUR=9;BYMINUTE=0` |
| `monthly` | `FREQ=MONTHLY;BYMONTHDAY=1;BYHOUR=9;BYMINUTE=0` |

Use a valid RRULE string returned by the schedule options or supplied by the user. The service accepts an optional `RRULE:` prefix. The schedule options also return the day codes `SU`, `MO`, `TU`, `WE`, `TH`, `FR`, and `SA`.

The scheduler checks due schedules every 15 minutes and dispatches up to 100 due schedules in one pass. A run can therefore start within the scheduler's polling window rather than at the exact RRULE boundary. The live service validates the schedule and reports the next occurrence.

The default active-automation limit is 20 per organization. Active schedules must be at least 15 minutes apart by their next occurrence. These values are configurable, so treat a validation response as authoritative when the live organization has different limits.

### Event triggers

An event trigger starts an active automation when an event arrives from Z360 or from a connected application. The trigger is selected together with the action group that owns the event source. The selected trigger and action group must belong to the same integration.

The built-in Z360 trigger options are:

| Trigger | Value | Configuration |
| --- | --- | --- |
| Contact created | `contact.created` | None. Use `{}`. |
| Conversation created | `conversation.created` | None. Use `{}`. |
| Conversation tag applied | `conversation.tag_applied` | Optional `tags` array. |
| Inquiry created | `inquiry.created` | None. Use `{}`. |
| Note created | `note.created` | None. Use `{}`. |
| Reminder created | `reminder.created` | None. Use `{}`. |
| Ticket created | `ticket.created` | None. Use `{}`. |

The conversation-tag trigger accepts selected string tag names. An empty `tags` array means that any conversation tag starts the automation. Get the current tag options from `get-automation-trigger-config`; do not invent tag values or pass numeric tags.

Connected-application triggers are dynamic. The option list can include an event such as a new Gmail message when a connected Gmail action group is available. Do not hardcode the external trigger list. Use the current option row, account label, and returned trigger schema.

Internal Z360 triggers do not register an external provider. A connected-app trigger can create or update a provider subscription as part of its lifecycle. The provider identifier is server-managed and is returned only in detailed automation output.

## Ownership, access, and agent policies

Every automation has one of these ownership values:

| Value | Meaning |
| --- | --- |
| `organization` | Shared with the organization. |
| `user_private` | Visible only to the current user. |

`search-automations` returns the organization-shared and private automations available in the current context. Changing ownership changes visibility, so confirm that change with the user.

The `approval_policy` controls how the automation's agent run handles tool approval:

| Value | Use |
| --- | --- |
| `ask` | Ask for approval before write tools. Use for sensitive work. |
| `auto` | Run low-risk tools automatically and ask when approval is needed. |
| `full` | Run all tools without asking. Use only for a fully trusted routine. |

The default is `auto`. An `ask` policy can leave an unattended run waiting for human approval, so do not choose it when the automation must complete without intervention.

The `reasoning_mode` controls the agent's reasoning effort:

| Value | Meaning |
| --- | --- |
| `low` | Everyday work. This is the default. |
| `medium` | More complex planning and execution. |
| `high` | The most demanding work. |

Use the lowest mode that can handle the task. Raise it when the automation must plan across several records or branches, and explain the cost or latency tradeoff when that choice matters.

## Automation lifecycle

Use this sequence for every automation request.

1. Decide whether an automation is the right product object. Use a skill for a reusable procedure, a wakeup to resume this thread, a reminder to tell a teammate to act later, a ticket to own work beyond the conversation, and a note to record what happened. Use an automation only when the work must start on a schedule or application event.
2. Define the outcome and boundary. Identify what starts the run, which records or contacts it may affect, what success means, what actions are allowed, when it must stop, when a human must take over, and how it handles missing, duplicate, stale, or already complete records.
3. Search existing automations before creating one. Check title, type, ownership, status, trigger source, schedule, and instructions for duplicates or overlapping runs. Follow pagination before claiming that no matching automation exists.
4. Choose the type and discover current configuration. Use a schedule for time-based work or a trigger for a Z360 or connected-application event. For a trigger, select one option row and fetch its configuration schema. For a schedule, read the presets and confirm the user's timezone and recurrence.
5. Draft the instructions and settings. Include the objective, event payload or scheduled context, decision rules, allowed actions, duplicate protection, stop conditions, failure handling, and the result to report. Choose ownership, approval, reasoning, and active state. Use organization ownership only for shared work. Use a paused automation for a draft or a configuration that needs review.
6. Show the exact proposal and get confirmation. Include the title, type, instructions, ownership, policy, schedule and timezone or trigger and configuration. Confirm before creating, activating, changing active behavior, changing a trigger or schedule, changing ownership, or deleting an automation.
7. Write, read back, and observe. Use only fields from the fresh schema. Report the returned ID and state after create or update. A successful write proves that the configuration was saved. A manual run proves dispatch only, so check run metadata or agent history before claiming completion. To pause, update `is_active` to `false`. To change the type or trigger source, create and confirm a replacement before deleting the old automation. To stop future runs because behavior is not ready or a provider is unavailable, pause the automation.
8. Delete only after the exact record is read and the user confirms the hard-delete consequence. Existing run history remains, so report what was deleted without saying that past runs were removed.

### Write good automation instructions

Write instructions for repeated execution, not a description of the feature. The agent needs enough information to make the same safe decision every time. Cover these questions:

- What is the business outcome?
- What event or scheduled context does the run receive?
- Which records, fields, contacts, and action groups are in scope?
- What evidence allows each action?
- What must the agent do when the record is missing, duplicated, stale, or already complete?
- What must it never send, change, delete, or promise?
- When must it stop, retry, create a ticket, or ask a human?
- What short result should the run leave in its history?

Make the instructions idempotent. Tell the agent to search for an existing result before creating a duplicate ticket, note, reminder, message, or contact. Event delivery and queued execution can repeat, so a successful first action is not enough protection against a second run.

## Discover and execute the catalog tools

The application layer exposes the automation classes as direct MCP tools. The internal Z360 action group exposes those same tools as virtual actions. The root agent uses this discovery path:

1. Call `search-action-groups` and select the authenticated Z360 group.
2. Call `search-actions` with that `group_id` and search for the automation operation.
3. Call `get-action-schema` for the exact returned `action_slug` immediately before every execution.
4. Call `execute-action` with the same `group_id`, the exact `action_slug`, and an `arguments` object shaped by the fresh schema.

The direct MCP name and catalog action slug are different names. Use the catalog slug in `execute-action`:

| Operation | Direct MCP name | Catalog action slug |
| --- | --- | --- |
| Search | `search-automations` | `z360-read-search-automations` |
| Get details | `get-automation` | `z360-read-get-automation` |
| Get options | `get-automation-options` | `z360-read-get-automation-options` |
| Get trigger schema | `get-automation-trigger-config` | `z360-read-get-automation-trigger-config` |
| Create | `create-automation` | `z360-write-create-automation` |
| Update | `update-automation` | `z360-write-update-automation` |
| Delete | `delete-automation` | `z360-write-delete-automation` |
| Run now | `run-automation` | `z360-write-run-automation` |

The catalog can change with a deployment or connection. Treat the returned `action_slug`, schema, and action-group ID as authoritative. Never invent an automation ID, integration trigger ID, action-group ID, trigger field, or enum.

### Search automations

Use `z360-read-search-automations` to find existing automations or to check for duplicates. Its inputs are optional except that normal pagination rules apply:

- `query` searches titles.
- `type` accepts `schedule` or `trigger`.
- `ownership_type` accepts `organization` or `user_private`.
- `status` accepts `active` or `paused`.
- `per_page` accepts 1 through 50 and defaults to 15.
- `page` defaults to 1.

The result is paginated and compact. It includes identity, type, title, ownership, policies, active state, schedule metadata, trigger names, account labels, and timestamps. It does not include the full instructions or trigger configuration. If the result spans pages, follow the pagination data before claiming that the organization has no matching automation.

### Get an automation

Use `z360-read-get-automation` with the numeric `automation_id` returned by search. The result includes the complete configuration, including instructions, trigger and action-group IDs, `trigger_config`, `config_schema`, schedule metadata, and the server-managed provider identifier when one exists.

### Get automation options

Use `z360-read-get-automation-options` with no arguments. It returns:

- `ownership_types` with the current ownership values and labels.
- `schedule` with the default RRULE, presets, timezone guidance, and day codes.
- `triggers` with compact trigger and action-group pairings.

Use this tool before creating a trigger. Do not use a trigger name alone when the option row supplies both `integration_trigger_id` and `ai_action_group_id`.

### Get a trigger configuration schema

Use `z360-read-get-automation-trigger-config` with the `integration_trigger_id` and `ai_action_group_id` from the same option row. It returns the selected trigger, action-group details, and the current `config_schema`. Build `trigger_config` from that schema.

For a trigger with no properties, pass `trigger_config: {}`. For `conversation.tag_applied`, pass a string array such as `{"tags": ["VIP"]}` only when `VIP` is one of the current options. Pass `{"tags": []}` to match every conversation tag.

### Create an automation

Use `z360-write-create-automation` for the confirmed proposal. Its common required fields are:

- `type`: `schedule` or `trigger`.
- `title`: user-facing title, up to 255 characters.
- `instructions`: complete instructions for the main agent, up to 12,000 characters.
- `is_active`: `true` or `false`.
- `ownership_type`: `organization` or `user_private`.

For a schedule, also pass `schedule_rrule` and `schedule_timezone`. For a trigger, also pass `integration_trigger_id`, `ai_action_group_id`, and the schema-shaped `trigger_config`. Do not send fields for the other automation type. Do not send `last_run_at`, `next_run_at`, `composio_trigger_id`, or any other server-managed field.

A successful response contains a message and a detailed `automation` payload. Read that payload and report the returned ID, type, ownership, active state, schedule or trigger, and any returned next-run information.

Creation can fail when the user lacks `manage_agent` permission, the active automation limit is reached, the schedule is invalid or too close to another active schedule, the trigger or action group is unavailable, or the trigger configuration does not match its schema. Surface the returned validation error. Do not retry with guessed values.

### Update an automation

Use `z360-write-update-automation` with the required `automation_id` and only the mutable fields that the user wants to change. Omitted fields keep their current values.

The updateable fields are `title`, `instructions`, `approval_policy`, `reasoning_mode`, `is_active`, `ownership_type`, `schedule_rrule`, `schedule_timezone`, and `trigger_config`, subject to the automation's fixed type. The `instructions` value replaces the entire existing instruction text; it is not a patch. Read the old instructions before replacing them.

There is no separate pause tool. Set `is_active` to `false` with this update action to pause an automation.

The automation `type`, `integration_trigger_id`, and `ai_action_group_id` are immutable. Do not send them to update. To change a schedule into a trigger, or to change a trigger source, create a new automation and then delete the old one only after the replacement is confirmed.

For a schedule, update the recurrence or timezone with the schedule fields. For a trigger, update only its schema-shaped `trigger_config`. When a connected-app trigger configuration changes, the application may replace its provider subscription. Confirm the resulting trigger and account, and read the detailed response back before reporting success.

The service revalidates active schedule limits and spacing. Pausing clears the schedule's `next_run_at`.

### Run an automation now

Use `z360-write-run-automation` only when the exact automation is a schedule, is active, and has a valid RRULE. It accepts only `automation_id`. It rejects trigger automations, paused schedules, and invalid schedules.

The action dispatches an asynchronous run and returns `Automation run started.` That response proves dispatch only. Check run history or the returned automation metadata before claiming that the agent completed its work.

Manual execution does not replace the schedule's next occurrence. Treat a manual run as externally visible and get confirmation unless the user explicitly asked to run the automation now.

Do not use this tool to test a trigger. To test a trigger, use the real event path with a narrowly scoped active automation, then inspect the resulting run and pause it when testing is complete.

### Delete an automation

Use `z360-write-delete-automation` with the exact numeric `automation_id`. It hard-deletes the automation configuration. Existing run threads remain in global agent history. A connected-app provider subscription is cleaned up when the deleted trigger is no longer used.

Tell the user the exact title and ID, explain the hard-delete consequence, and get confirmation before calling the action. Report the returned deleted automation payload. Do not describe deletion as a pause, and do not claim that past runs were removed.

## Safety and failure rules

- Read the exact automation before an update, pause, activation, manual run, ownership change, or delete. Search first when the ID is not in context. If a write fails, read the record again before retrying because a provider may have accepted the request.
- Get a fresh action schema immediately before every `execute-action`, including reads. Get fresh trigger options and a fresh trigger configuration schema before creating a trigger. Keep the IDs from one option row together and use only returned fields, IDs, and enum values.
- Confirm persistent or externally visible behavior before creating, activating, changing active behavior, changing a trigger or schedule, changing ownership, or deleting an automation. Use a paused draft when the instruction, trigger configuration, or output is not clear. Choose `ask` or narrower instructions when a routine sends messages, places calls, creates or deletes records, or performs bulk work.
- Put duplicate protection and stop conditions in the instructions. Event delivery and queued execution can repeat, so do not rely on the queue or provider to make a business action idempotent. Do not enable an unreviewed behavior just to test it.
- Do not guess a trigger, account, schedule, timezone, record ID, provider identifier, or other business value. Report validation, permission, provider errors, and warnings exactly. A dispatched run is not a completed run.
- Keep credentials, API keys, and provider secrets out of automation instructions and user-facing responses.
