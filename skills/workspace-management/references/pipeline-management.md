---
name: pipeline-management
description: Find, inspect, create, update, configure, or delete Z360 lead pipelines and their outbound outreach cadence. Read this reference when the user wants to define how leads progress, when contacts should be contacted, or what should happen after each stage.
---

# Pipeline management

Read `../product-model/references/pipelines.md` for the pipeline definition. Use the authenticated Z360 action catalog for pipeline reads and writes, and the common `render-ui` tool for the Pipeline UI card.

## Choose the organization's mode

Before creating a pipeline or choosing status transitions, read `../product-model/contrasts/work-items-vs-inquiries.md`. If a known inquiry or Work Item already establishes the mode for a record-specific task, use that mode. Otherwise, call `z360-read-get-organization-pipeline-mode` as described below. Follow only the matching section when writing a goal or interpreting statuses. Action names that contain `inquiry` do not determine the mode.

## Write a pipeline goal

Use this section when the fresh create or update schema accepts `goal`. If it does not, follow the schema guidance below and use the Z360 Pipeline UI for the AI flow.

### Define the goal

Read `../workspace-management/references/skill-management.md` before writing or substantially revising a goal. Ask the user for the pipeline's purpose, target context, stages, stage-transition evidence, messages and channels, follow-up cadence, business actions, stop conditions, terminal outcomes, and exception handling. Ask about missing business rules instead of assuming them. Before saving, confirm the trigger, intended outcome, and what success means. Write a declarative, business-readable goal that answers:

- What happens when an inquiry or Work Item enters the pipeline?
- Which message, action, or channel applies at each step, and when does a follow-up occur?
- Which stage or status changes, and what evidence triggers the change?
- What happens when a contact replies, does not reply, cannot be reached, or provides incomplete information?
- When does the cadence pause, stop, complete, or require a user decision?
- How are retries, duplicate events, conflicting records, and tool failures handled?

Use explicit conditions and stop criteria. State that achieving the pipeline's purpose requires moving to its defined final stage and setting the completion status for the organization's mode. Keep unrelated workflows out of one pipeline, and do not invent identifiers or tool schemas in the goal. For a large lifecycle, use labeled phases or branches within the field's supported size. Create a separate pipeline only when the business needs a distinct cadence.

Read the current stage and status together. A stage name alone does not prove completion or failure. Apply the final stage and completion status defined for the resolved mode.

### Inquiry mode

Read `../product-model/references/inquiries.md`. Write the goal and example flow around the inquiry's stages and statuses. When the pipeline goal is achieved, use its final stage and set the inquiry status to `Secured`. `Secured` means the goal was achieved, not necessarily that a new customer was acquired. Use `Dropped`, `Declined`, or `Idle` only when the goal, conversation, user, or product state establishes that outcome.

### Work mode

Read `../product-model/references/work-items.md`. Write the goal and example flow around the Work Item's stages, stakeholders, and statuses. When the pipeline goal is achieved, use its final stage and set the Work Item status to `completed`. Use `failed` only when the goal's failure or stop condition is confirmed. Do not use inquiry statuses in a Work goal.

#### Configure sender channels

When the fresh create or update schema exposes `goal` but omits `pipeline_channel_type` and `pipeline_channels`, put sender channels in the goal's YAML frontmatter instead of pipeline channel settings. Resolve active email and texting channel IDs with the organization channel-search actions. Confirm the senders with the user and include each approved sender as a typed entry before the Markdown goal:

```yaml
---
channels:
  - type: email
    id: 123
---
```

Replace `123` with an active channel ID returned by search. The list is the Work agent's sender allowlist. Do not invent IDs or include unapproved channels.

### Review and confirm the goal

Once the goal is drafted, show the user the exact goal text and a short example flow in the main chat—for example, entry trigger → first outreach → reply/no-reply branch → stage transition → scheduled follow-up → completion status for the active execution mode. Treat this as a review step: invite corrections, revise the goal, and get final confirmation before creating or updating the pipeline.


## Resolve pipeline actions and context

### Discover actions and organization context

Resolve the Z360 action group and the specific action instead of guessing IDs. Use `search-action-groups`, then `search-actions`. The current application action slugs retain the word `inquiry` for API compatibility, even though this reference and the user-facing concept are lead pipelines:

- `z360-read-search-inquiry-pipelines`
- `z360-read-get-inquiry-pipeline`
- `z360-read-get-organization-pipeline-mode`
- `z360-write-create-inquiry-pipeline`
- `z360-write-update-inquiry-pipeline`
- `z360-write-update-inquiry-pipeline-intake-field`
- `z360-write-delete-inquiry-pipeline`

Resolve organization-specific pipeline context through the reusable Z360 actions:

- `z360-read-search-team-members` for assignee IDs.
- `z360-read-search-phone-numbers` for phone channel IDs. Filter to active numbers. Because collection-assigned numbers require a collection filter, use `z360-read-search-phone-collections` first and search each relevant collection when needed.
- `z360-read-search-email-accounts` for email channel IDs. Filter to active accounts. Because collection-assigned accounts require a collection filter, use `z360-read-search-email-collections` first and search each relevant collection when needed.

### Check action schemas

Before every pipeline create or update, fetch the exact write action schema and treat it as the source of truth for fixed choices and numeric limits, including drop-lead actions, form and iframe submit actions, and outbound-call concurrency. Use only IDs returned by the context searches and values allowed by that fresh schema. Never infer or invent a user ID, channel ID, enum value, or limit. If a required option cannot be resolved, explain what is missing and ask the user instead of attempting the write.

Before every Z360 `execute-action`, including pipeline reads and writes, call `get-action-schema` for that exact action and use only fields present in the returned schema. Fetch it fresh even if the schema was retrieved earlier in the conversation. When the mode is unknown, resolve `z360-read-get-organization-pipeline-mode`, fetch its schema, and execute it once before choosing a workflow. Do not infer organization mode from create or update schemas.

Use the fresh create or update schema to determine which fields the action accepts:

- If the schema contains `goal`, collect and send `goal` when the request needs it. Never send `ai_flow`.
- If the schema does not contain `goal`, never send either `goal` or `ai_flow`. Explain only that the AI flow must be completed in the Z360 Pipeline UI. Do not name or explain another implementation.

### Preserve intake fields

Treat the intake flow returned by `z360-read-get-inquiry-pipeline` as the current source of truth. Preserve every system contact field and its protected identity, type, required state, and visibility. Change only metadata the user requested and the current action accepts. When a write supplies an intake page or field collection, build the complete desired collection from the current flow plus the requested changes.

### Inspect action results

After every `execute-action`, inspect the inner action response, not only the outer tool result. Surface `ai_status` and every string in `warnings` when present. Do not turn a warning into a success claim or omit it.

## Find or inspect pipelines

Use `search-actions` to resolve the search/get actions. Before executing the search action, call `get-action-schema` for `z360-read-search-inquiry-pipelines`, then call `execute-action` to discover a pipeline. Before executing the get action, call `get-action-schema` for `z360-read-get-inquiry-pipeline`, then call `execute-action` for its current details. Fetch each schema again before any later read execution. Distinguish an empty result from a failed search and report the identifiers and current lifecycle details returned by the action.

## Create a pipeline

1. Resolve the create action and call `get-action-schema` for `z360-write-create-inquiry-pipeline`.
2. Collect the supported required fields. Use the resolved organization mode for the workflow and the fresh schema for supported fields. If the request includes a cadence and the schema accepts `goal`, conduct the goal-definition and review flow above. If it requests a cadence but the schema omits `goal`, explain that the AI flow must be completed in the Z360 Pipeline UI.
3. Call `execute-action` with the exact create slug and supported arguments.
4. Inspect and report the inner `ai_status` and `warnings`.
5. After a successful create with a returned pipeline ID, call common `render-ui` with `component: pipeline` and `props: {pipeline_id: <returned id>}`. This renders the read-only **View Pipeline** card. Full editing belongs in the Z360 Pipeline UI.

## Update a pipeline

1. Search for the pipeline, then get its current details before proposing a change. Never guess the ID or current values.
2. Choose the narrowest update action:
   - For one intake field, use `z360-write-update-inquiry-pipeline-intake-field`. Pass the stable field ID returned by the get action and only the requested field changes in `patch`.
   - For any broader pipeline change, use `z360-write-update-inquiry-pipeline` and put only the requested pipeline changes in `changes`. Omitted values remain unchanged and nested objects merge. A supplied array replaces that collection, so construct it from the current value plus the requested change.
3. Compare the request with the selected schema and current values. Never execute an empty update. If changing `goal` and the schema accepts it, conduct the goal-definition and review flow above. Show the user what lifecycle behavior and final status handling will change, and get confirmation.
4. For a general pipeline update involving the goal or AI flow, apply the schema field check:
   - When `goal` is absent, for a mixed request containing supported changes plus an unsupported canvas or AI flow change, execute only the supported changes. Explain from the schema that the AI flow must be completed in the Z360 Pipeline UI even when `warnings` may be absent because unsupported fields were not sent. Surface the inner warning if one is returned.
   - For an AI-only canvas request when `goal` is absent, do not call the update action. State clearly that nothing changed, explain that the AI flow must be completed in the Z360 Pipeline UI, and call common `render-ui` for the existing pipeline.
5. After a successful update, inspect and report `ai_status` and `warnings`, then call common `render-ui` with `component: pipeline` and the pipeline ID so the read-only **View Pipeline** card is available. Full editing belongs in the Z360 Pipeline UI.

## Delete a pipeline

1. Search for the pipeline and get its current details first.
2. Explain that deletion is a hard delete: the pipeline and its associated execution records are deleted in a cascade, and the operation is irreversible.
3. Ask the user to confirm the exact pipeline.
4. After confirmation, resolve the delete action and call `get-action-schema` for `z360-write-delete-inquiry-pipeline` immediately before `execute-action`.
5. Execute the exact delete action. Report its action-specific message and the deleted pipeline ID and name. Also surface `warnings` if unexpectedly present.
