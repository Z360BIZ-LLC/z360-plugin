---
name: workspace-settings
description: "Inspect and change Z360 organization, account, team, channel, product, compliance, billing, and AI Studio agent settings through the authenticated action catalog. Read this reference when a workspace setting or its related configuration must be discovered, changed, or verified."
---

# Workspace settings

Read `../product-model/SKILL.md` before interpreting Z360 terminology, then open only the direct product-model reference needed for the setting: [team members](../../product-model/references/team-members.md), [inbox](../../product-model/references/inbox.md), [inquiries](../../product-model/references/inquiries.md), [pipelines](../../product-model/references/pipelines.md), or [integrations](../../product-model/references/integrations.md). Read this reference when the request concerns configuration that changes how the organization, its users, channels, products, or AI Studio agent behave. The authenticated Z360 action catalog and the fresh action schemas remain authoritative when the live application differs from this reference.

## Contents

- [Scope and boundaries](#scope-and-boundaries)
- [Discover and execute settings tools](#discover-and-execute-settings-tools)
- [Settings lifecycle](#settings-lifecycle)
- [AI Studio agent settings](#ai-studio-agent-settings)
- [User notification preferences](#user-notification-preferences)
- [Organization, team, and invitations](#organization-team-and-invitations)
- [Billing and usage](#billing-and-usage)
- [Email settings](#email-settings)
- [Phone settings and number purchase](#phone-settings-and-number-purchase)
- [A2P 10DLC settings](#a2p-10dlc-settings)
- [Product settings](#product-settings)
- [Safety and failure rules](#safety-and-failure-rules)
- [Related references and boundaries](#related-references-and-boundaries)

## Scope and boundaries

A workspace setting is configuration for the current Z360 organization or user. Settings can affect future records, routing, team access, customer-facing channels, AI behavior, provider subscriptions, compliance status, or billing. Treat organization-level settings as shared changes even when the request comes from one user.

The settings catalog covers four permission scopes. Use the narrowest matching scope and let the live action enforce the exact authorization.

| Scope | Settings covered |
| --- | --- |
| `manage_account_settings` | Organization details, team members, invitations, email accounts and collections, phone numbers and collections, phone-number purchases, and A2P 10DLC submissions. |
| `manage_product_settings` | Live chat, inquiry pipelines, ticket settings, and contact custom fields. |
| `manage_billing` | Billing prices and usage logs. The live service applies its billing authorization rules. |
| `manage_agent` | AI Studio agent configuration, including General settings and voice settings for the feature-enabled agent. |

Notification preferences apply to the current user and are not an organization-wide setting. Use the action's authorization and returned error as the source of truth.

Settings tools do not replace record tools. Use contact, conversation, ticket, inquiry, company, note, reminder, and lead actions for records. Use automation management for automation lifecycle operations, skill management for reusable procedures, and expert management for AI Studio Experts. A pipeline is a product setting here, but its lead-goal and outreach lifecycle needs the deeper pipeline reference.

## Discover and execute settings tools

The Z360 action group exposes the internal application-layer MCP tools as virtual actions. If the authenticated `group_id` is not already known, call `search-action-groups` and select the authenticated Z360 group. Then call `search-actions` with that group and the requested operation. Before every `execute-action`, including a read, call `get-action-schema` for the exact returned action slug and build the arguments from that fresh schema.

Call `execute-action` with the same `group_id`, the exact catalog `action_slug`, and an `arguments` object. Do not pass a direct MCP name as the catalog slug. The direct name is useful only when invoking the application-layer MCP tool directly. Read the inner action response and warnings instead of treating an outer transport success as proof that the setting changed.

The current settings inventory is below. The catalog slug is derived from the catalog title and the read or write classification. `get-a2p-registration` is the one current naming exception: the direct MCP tool is `get-a2p-registration-details`, while its catalog slug is `z360-read-get-a2p-registration`. The agent-config actions in the first table expose the feature-enabled General settings path. The voice actions are listed with them because the feature-enabled voice settings use separate actions.

### AI Studio agent actions

| Operation | Direct MCP name | Catalog action slug |
| --- | --- | --- |
| Get agent configuration | `get-agent-config` | `z360-read-get-agent-config` |
| Update agent configuration | `update-agent-config` | `z360-write-update-agent-config` |
| Get voice configuration | `get-voice-config` | `z360-read-get-voice-config` |
| Update voice configuration | `update-voice-config` | `z360-write-update-voice-config` |

### Notification preferences

| Operation | Direct MCP name | Catalog action slug |
| --- | --- | --- |
| Get current-user preferences | `get-notification-preferences` | `z360-read-get-notification-preferences` |
| Get preference options | `get-notification-preference-options` | `z360-read-get-notification-preference-options` |
| Update current-user preferences | `update-notification-preferences` | `z360-write-update-notification-preferences` |

### Organization, team, and invitations

| Operation | Direct MCP name | Catalog action slug |
| --- | --- | --- |
| Get organization details | `get-organization-details` | `z360-read-get-organization-details` |
| Update organization details | `update-organization-details` | `z360-write-update-organization-details` |
| Search team members | `search-team-members` | `z360-read-search-team-members` |
| Update team-member role | `update-team-member-role` | `z360-write-update-team-member-role` |
| Remove team member | `remove-team-member` | `z360-write-remove-team-member` |
| Search pending invitations | `search-pending-invitations` | `z360-read-search-pending-invitations` |
| Invite, update, or resend invitation | `manage-invitation` | `z360-write-manage-invitation` |
| Delete invitation | `delete-invitation` | `z360-write-delete-invitation` |

### Billing

| Operation | Direct MCP name | Catalog action slug |
| --- | --- | --- |
| Get billing prices | `get-billing-prices` | `z360-read-get-billing-prices` |
| Search usage logs | `search-usage-logs` | `z360-read-search-usage-logs` |

### Email

| Operation | Direct MCP name | Catalog action slug |
| --- | --- | --- |
| Search email accounts | `search-email-accounts` | `z360-read-search-email-accounts` |
| Search email collections | `search-email-collections` | `z360-read-search-email-collections` |
| Create email collection | `create-email-collection` | `z360-write-create-email-collection` |
| Update email account | `update-email-account` | `z360-write-update-email-account` |

### Phone numbers and purchase

| Operation | Direct MCP name | Catalog action slug |
| --- | --- | --- |
| Search phone numbers | `search-phone-numbers` | `z360-read-search-phone-numbers` |
| Search phone collections | `search-phone-collections` | `z360-read-search-phone-collections` |
| Get phone-number availability | `get-phone-number-availability` | `z360-read-get-phone-number-availability` |
| Create phone collection | `create-phone-collection` | `z360-write-create-phone-collection` |
| Update phone number | `update-phone-number` | `z360-write-update-phone-number` |
| Search numbers to buy | `search-phone-numbers-to-buy` | `z360-read-search-phone-numbers-to-buy` |
| Buy phone number | `buy-phone-number` | `z360-write-buy-phone-number` |

### A2P 10DLC

| Operation | Direct MCP name | Catalog action slug |
| --- | --- | --- |
| Get registration and options | `get-a2p-registration-details` | `z360-read-get-a2p-registration` |
| Submit brand | `submit-a2p-brand` | `z360-write-submit-a2p-brand` |
| Submit campaign | `submit-a2p-campaign` | `z360-write-submit-a2p-campaign` |
| Appeal campaign | `appeal-a2p-campaign` | `z360-write-appeal-a2p-campaign` |

### Product live chat, pipelines, tickets, and contacts

| Operation | Direct MCP name | Catalog action slug |
| --- | --- | --- |
| Get live chat settings | `get-live-chat-settings` | `z360-read-get-live-chat-settings` |
| Update live chat settings | `update-live-chat-settings` | `z360-write-update-live-chat-settings` |
| Get organization pipeline mode | `get-organization-pipeline-mode` | `z360-read-get-organization-pipeline-mode` |
| Search inquiry pipelines | `search-inquiry-pipelines` | `z360-read-search-inquiry-pipelines` |
| Get inquiry pipeline | `get-inquiry-pipeline` | `z360-read-get-inquiry-pipeline` |
| Create inquiry pipeline | `create-inquiry-pipeline` | `z360-write-create-inquiry-pipeline` |
| Update inquiry pipeline | `update-inquiry-pipeline` | `z360-write-update-inquiry-pipeline` |
| Update pipeline intake field | `update-inquiry-pipeline-intake-field` | `z360-write-update-inquiry-pipeline-intake-field` |
| Delete inquiry pipeline | `delete-inquiry-pipeline` | `z360-write-delete-inquiry-pipeline` |
| Search ticket settings | `search-ticket-settings` | `z360-read-search-ticket-settings` |
| Create ticket setting | `create-ticket-setting` | `z360-write-create-ticket-setting` |
| Update ticket setting | `update-ticket-setting` | `z360-write-update-ticket-setting` |
| Delete ticket setting | `delete-ticket-setting` | `z360-write-delete-ticket-setting` |
| Set default ticket setting | `set-default-ticket-setting` | `z360-write-set-default-ticket-setting` |
| Reorder ticket statuses | `reorder-ticket-statuses` | `z360-write-reorder-ticket-statuses` |
| Create contact custom field | `create-contact-custom-field` | `z360-write-create-contact-custom-field` |
| Update contact custom field | `update-contact-custom-field` | `z360-write-update-contact-custom-field` |
| Delete contact custom field | `delete-contact-custom-field` | `z360-write-delete-contact-custom-field` |

## Settings lifecycle

Use this sequence for every settings request.

1. Classify the request as a current-user preference, account setting, communication channel setting, product setting, agent setting, billing read, compliance submission, or record operation. If it is a record operation or automation, skill, or expert lifecycle request, use the matching tool and reference instead.
2. Identify the current organization, the user or agent affected, the setting record or collection, the requested outcome, and any shared, customer-facing, provider, compliance, billing, or access impact. Ask for missing business facts rather than guessing them.
3. Discover the authenticated Z360 action group and the narrowest action. Follow search pagination and use IDs returned by the current organization. Do not reuse a name, ID, enum, collection, pipeline, user, agent, or provider value from another tenant.
4. Read current state before a write. Use the search action to resolve an ID, then the get or detail action when one exists. Read current settings before partial updates, array replacements, routing changes, deletes, role changes, ticket defaults, or compliance submissions.
5. Fetch the exact action schema immediately before execution. Use only its current fields, required branches, enum values, limits, and descriptions. Dynamic options such as notification keys, ledger units, contact-field presets, agent voices, A2P values, and organization IDs must come from the live response or schema.
6. Construct the smallest valid payload. Preserve omitted values when the tool documents partial behavior. When an array replaces a collection or a full order is required, merge the current collection with the requested change and send the complete desired array.
7. Show the exact shared or external effect and get confirmation before consequential writes. This includes changing access or roles, removing members, changing customer-facing routing, changing AI behavior, activating pipeline outreach, buying numbers, sending A2P submissions, changing billing-related behavior, or deleting settings or pipelines.
8. Execute with the exact catalog slug and inspect the inner response, warnings, returned IDs, and status before the read back. A message such as an update success proves only that the application accepted that update; it does not prove provider health, campaign approval, pipeline performance, or downstream delivery.
9. Read back the setting or resource with the appropriate read action. Verify the fields that changed, the preserved fields that matter, server-normalized values, next-run or provider metadata when applicable, and any warning. Report the returned state and distinguish saved configuration from an external process that is still pending.
10. If a write fails or times out, read the current state before retrying. The application or an external provider may have accepted part of the request. Surface validation, permission, provider, billing, and compliance errors exactly and do not retry with invented values.

## AI Studio agent settings

The AI Studio Agent page selects its settings model with the `customer-facing-deep-agent` feature flag. Feature-enabled organizations use the General page and the voice settings described here. Organizations without the flag use the legacy page. This reference covers the feature-enabled path only.

### General page

The `get-agent-config` action takes no arguments and returns `agent_name` plus `deep_agent_default_email`, `deep_agent_default_sms`, and `deep_agent_default_livechat`. Each channel default contains `reasoning` and `approval_policy`.

The `update-agent-config` action requires the complete `agent_name` and all three channel-default objects. `agent_name` must be a string of at most 50 characters. Each channel default requires `reasoning` set to `low`, `medium`, or `high` and `approval_policy` set to `ask`, `auto`, or `full`. The action validates the same General settings contract as the AI Studio page and writes only these four settings.

Email conversations use the email default, phone conversations use the SMS default, and live-chat conversations use the live-chat default. The dispatcher applies the selected reasoning effort and approval policy only when it initializes an inbox conversation thread. Later runs on the same thread keep their existing settings.

Both actions require `manage_agent` and the `customer-facing-deep-agent` feature flag. The action catalog hides them for organizations without the flag. Do not send the old `sections`, `details`, `availability`, or `personalization` fields to these actions. Read the General settings before an update when you need to preserve current values. Send all four required fields. Read the result back.

The feature-enabled UI write remains available at the `ai-studio.agent.general.store` route. Use `update-agent-config` for application-layer MCP mutations.

Changing a surface default changes the reasoning effort and approval behavior of future initialized inbox threads. It does not change an already initialized thread. Confirm the affected surfaces and the resulting policy before saving shared organization settings.

### Voice settings

The `get-voice-config` action takes no arguments and returns `voice`, `personality`, `agent_introduction_instructions`, `multilingual_enabled`, `primary_language`, and `allowed_languages`.

The `update-voice-config` action replaces the complete voice and personalization setting. It requires all six fields. `voice` accepts built-in voice IDs and voice clones selectable by the current organization. `personality` and language values must come from the current action schema. `agent_introduction_instructions` is limited to 1000 characters. When multilingual support is enabled, `allowed_languages` must include `primary_language`. The action writes only the voice and personalization setting.

Both voice actions require `manage_agent` and the `customer-facing-deep-agent` feature flag. Use them for the feature-enabled voice page. Do not use the old personalization branch of `update-agent-config` for voice changes. Read the current voice settings before a replacement update and read them back after saving.

## User notification preferences

`get-notification-preferences` reads the current user's preferences. `get-notification-preference-options` returns the current notification types and the supported preference-key structure. Build keys as `notify_{type}_via_{channel}` using the current options and the channels `mail`, `in_app`, and `push`; do not hardcode a stale type list.

`update-notification-preferences` accepts `enable` and `disable` arrays. At least one side is required, each array is deduplicated, an empty array after deduplication is rejected, and the same key cannot occur in both arrays. The change applies only to the current user and returns a success message. Read back the preferences when the exact resulting state matters.

## Organization, team, and invitations

`get-organization-details` returns the current organization ID, name, and avatar path. `update-organization-details` accepts the required organization `name`, which must be unique within the current organization and no longer than 255 characters. Avatar upload is not supported by this MCP action. Renaming an organization is shared and should be confirmed.

`search-team-members` supports an optional name or email `search`, including `regex:<pattern>`, an `include` array for `email` and `role`, `per_page` from 1 through 50 with a default of 15, `page`, and opt-in `includes` such as `total_count`. It returns integer user IDs and the requested fields. Use those returned IDs for role, routing, assignee, and invitation operations.

`update-team-member-role` requires `user_id` and a `role` of `owner`, `admin`, or `member`. A user cannot change their own role. Admins cannot update an owner, and only an owner can assign the owner role. Moving a member away from `member` clears the stored member permission blob. Confirm the exact member and resulting access before execution.

`remove-team-member` requires `user_id`. A user cannot remove themselves and an admin cannot remove an owner. Removal also cleans this organization's phone-number assignments and IVR triggers for the member and deletes that member's private automations, experts, and skills in the organization. Organization-owned automations remain. Treat this as a multi-resource destructive change and confirm the exact member first.

`search-pending-invitations` supports search over email, role, or inviter, including `regex:<pattern>`, pagination from 1 through 50 with a default of 15, and opt-in `total_count`. It returns only pending invitations with their IDs, email, role, inviter, expiry, and acceptance state. Use it before changing or deleting an invitation.

`manage-invitation` requires an `action` and a matching `params` object. The `invite` branch requires `email` and `role`; `update_role` requires `invitation_id` and `role`; `resend` requires `invitation_id`. The current roles are `owner`, `admin`, and `member`. Duplicate pending invitations are rejected, only owners can invite or assign an owner, accepted or expired invitations cannot be role-updated, and a role other than `member` clears the invitation permission blob. Resending sends the pending invitation again. Confirm the recipient, role, or resend effect.

`delete-invitation` requires the integer `invitation_id` and deletes the invitation. Read it first and confirm because the operation changes the invitation workflow and cannot be treated as a read or a pause.

## Billing and usage

`get-billing-prices` returns the current price catalog, usage descriptions, and billing units. Do not reproduce prices from memory. The live service controls billing authorization; current tests and runtime behavior treat this as an owner-level operation.

`search-usage-logs` supports `view: detailed` or `aggregated`, defaulting to aggregated, metadata search with normal or `regex:<pattern>` matching, `sort_by` values `newest`, `oldest`, `amount-asc`, `amount-desc`, `quantity-asc`, and `quantity-desc`, a top-level `date_range` in `YYYY-MM-DD..YYYY-MM-DD` format, and `filters` containing current `unit` values. Detailed results are paginated ledger rows; aggregated results group totals by unit and use amount or quantity ordering where the view supports it. Use `per_page` from 1 through 50, `page`, and opt-in `includes: [total_count]` where supported. Use the current schema for ledger units because billing categories can change.

## Email settings

`search-email-collections` accepts optional label search with fuzzy matching or `regex:<pattern>` and returns the current organization's email collections. `create-email-collection` requires a unique label of at most 255 characters and creates an email collection. Read the collection list after a write when the returned identity is needed.

`search-email-accounts` accepts search, `sort_by` values `newest`, `oldest`, `email-asc`, and `email-desc`, and filters for `collection_id`, `status`, and `api_type`. Status values are `active`, `paused`, and `expired`; provider values are `gmail` and `outlook`. Use `per_page` from 1 through 50, `page`, and opt-in `includes` such as `total_count` and `conversations_count`. To search or return collection-assigned accounts, supply the collection filter. The action does not provide a generic email OAuth connect or disconnect operation.

`update-email-account` requires the integer `email_account_id`. Optional fields are `from_name` up to 100 characters, nullable `channel_collection_id` for an email collection, `default_assignees`, and `daily_proactive_messages_limit` with a minimum of 1. Missing fields preserve current values. Assignee IDs must belong to the current organization and may include the AI agent sentinel `0`. Read active outreach pipelines before removing the AI agent from an account's default assignees because the service rejects that change when the account is in use. Read the current account before changing collection, assignee, or proactive-message behavior and confirm customer-facing impact.

## Phone settings and number purchase

`search-phone-collections` accepts optional collection-label search with fuzzy matching or `regex:<pattern>` and returns the current organization's phone collections. `create-phone-collection` requires a label up to 255 characters and creates a phone collection.

`search-phone-numbers` accepts search, `sort_by` values `newest`, `oldest`, `number-asc`, and `number-desc`, and filters for `collection_id`, `status`, and `health_status`. Current status values are `order_placed`, `active`, `failed`, and `porting`; health values are `not_configured`, `unhealthy`, and `healthy`. A collection filter is required to search or return collection-assigned numbers. Use `per_page` from 1 through 50, `page`, and opt-in `includes` such as `total_count` and `conversations_count`. The result can include routing, allowed callers, assignees, proactive limits, texting, forwarding, caller ID, screening, health, and timestamps; use the returned fields rather than assuming a number's current configuration.

`get-phone-number-availability` takes no arguments and returns the current organization-level CPAAS schedule, unavailability options, receiving-user unavailability options, and whether a voicemail greeting exists. Read it before changing phone routing or unavailability behavior.

`update-phone-number` requires `phone_number_id` and supports partial updates for alias, collection, receiving mode, receiving users, allowed callers, default assignees, proactive-message limit, texting, unavailability overrides, forwarding, CNAM, caller ID, and inbound screening. Missing fields preserve current values, but read the current number and construct a complete intended routing state before changing related fields.

The receiving mode is `direct_users`, `ivr`, or `transfer`. `direct_users` requires at least one receiver. The integer sentinel `0` means the AI agent and may be used alone but cannot be combined with human receivers. Human receiver and allowed-caller IDs must belong to the current organization. Default assignees also use current organization user or agent IDs and may include `0`. Read active outreach pipelines before removing `0` from default assignees or disabling texting on a number that a pipeline uses.

The unavailability override for direct users can be `agent`, `voicemail`, or `forward`; IVR and transfer support only `agent` or `voicemail` for that override. The receiving-user override can be `agent`, `voicemail`, or `forward`. A forwarding number is required for transfer mode or for a forward override and must be a valid US phone number. The other supported fields include `texting_enabled`, `cnam_listing_enabled` with conditional `cnam_listing_details`, `caller_id_name_enabled`, and inbound screening values `disabled`, `flag_calls`, or `reject_calls`. CNAM details are required when CNAM is enabled and are limited to 255 characters. Confirm customer-facing routing, call costs, and messaging impact before changing these settings.

`search-phone-numbers-to-buy` searches available US local Telnyx numbers. It accepts an optional `starts_with` prefix or area code and a `limit` from 1 through 50 with a default of 20. A provider failure can return an empty result; distinguish that from a confirmed lack of inventory.

`buy-phone-number` requires an E.164 `number` such as `+15551234567`, checks uniqueness among the organization's non-deleted numbers, and calls the provider purchase flow. It has external and billing implications. Confirm the exact returned number and any price or provider impact available from the live response; never invent a purchase price because the tool schema does not expose one.

## A2P 10DLC settings

Read `../workspace-management/references/a2p-10dlc.md` for the dedicated compliance workflow. `get-a2p-registration-details` takes no arguments and returns current registration state, SMS availability, temporary messaging status and expiry, limits, errors, campaign prefills, and current options for form statuses, brand statuses, entity types, verticals, and stock exchanges. Call it first and use its values to resume the correct registration stage.

`submit-a2p-brand` requires `displayName`, `entityType`, `vertical`, `ein`, `street`, `city`, `postalCode`, `state`, `country`, `firstName`, `lastName`, `email`, and `phone`. `country` is currently `US`; `entityType` values are `PRIVATE_PROFIT`, `PUBLIC_PROFIT`, `NON_PROFIT`, and `GOVERNMENT`. `companyName` is required unless the entity type is `GOVERNMENT`; `website` is optional; `stockSymbol` and `stockExchange` are required for `PUBLIC_PROFIT`. Use the registration response for the current vertical and stock-exchange values. EIN, address, and contact data are sensitive. Verify every value with the user and confirm before submission because initial brand registration may charge a one-time fee.

`submit-a2p-campaign` requires real compliance facts in `description`, `messageFlow`, `helpMessage`, `optinMessage`, `sample1`, `sample2`, `termsAndConditionsLink`, and `privacyPolicyLink`. Read current registration and limits first, use public URLs supplied by the user, and never invent an opt-in flow, message sample, or policy URL. Campaign review may charge a fee; confirm before submission.

`appeal-a2p-campaign` requires `campaign_id`, `appeal_reason`, `sample1`, and `sample2`. Resolve the campaign ID from the registration read, use it only for a failed campaign, and provide factual appeal material. The service preserves the other campaign fields while replacing the appeal samples. An appeal may charge a review fee and is an external compliance submission, so confirm before execution.

## Product settings

### Live chat widget

`get-live-chat-settings` takes no arguments and returns every field the update accepts, plus `organization_name` and the resolved `default_assignees`.

`update-live-chat-settings` covers every field on the Live Chat settings page. Send only the fields to change; omitted fields keep their current values. The fields are:

- Content: nullable `livechat_name` up to 100 characters (`null` resets to the organization name), nullable `livechat_logo_path` (an Ask Z attachment path such as `/attachments/logo.png` for a JPEG, PNG, GIF, or WebP image of at most 5 MB uploads a new logo; `null` removes it and falls back to the organization logo), `livechat_main_page_greeting` up to 100 characters, and `livechat_welcome_message` up to 100 characters.
- Appearance: `livechat_theme` with `light` or `dark`, `livechat_brand_color` as `#RRGGBB`, and nullable `livechat_brand_foreground_color` using the current `Color::DARK` or `Color::LIGHT` values, currently `#111316` or `#F7F8FA` (`null` restores automatic contrast).
- Conversation: `livechat_notice_type` with `simple` or `alert`, `livechat_notice_message` up to 160 characters, and `livechat_default_assignees`, which replaces the whole assignee list (IDs from the current organization; `0` is the AI agent).

To show the widget, call common `render-ui` with `component: live_chat_widget` and empty `props`. Render it after every successful update so the user can review the saved widget.

### Inquiry pipelines

The pipeline setting actions are `get-organization-pipeline-mode`, `search-inquiry-pipelines`, `get-inquiry-pipeline`, `create-inquiry-pipeline`, `update-inquiry-pipeline`, `update-inquiry-pipeline-intake-field`, and `delete-inquiry-pipeline`. Use `../workspace-management/references/pipeline-management.md` for goal, outreach, stage-transition, and lifecycle rules. This section covers the settings tool boundary and nested configuration shape.

`search-inquiry-pipelines` supports search, `sort_by` values `newest`, `oldest`, `name-asc`, `name-desc`, `completion-asc`, and `completion-desc`, filters for completion status, active state, and created-at date range, and pagination from 1 through 50 with a default of 15. Use the returned pipeline ID, then call `get-inquiry-pipeline` for the full normalized configuration. The get response includes `basic_info`, `intake_flow`, `communication`, `schedule`, `branding`, and `configuration`; it omits legacy flow and subflow fields.

Create and broad update payloads use the pipeline's nested sections. `create-inquiry-pipeline` accepts the complete `pipeline` object. `update-inquiry-pipeline` requires `pipeline_id` and `changes`; nested objects merge recursively, omitted values remain unchanged, and a supplied array replaces that collection. `update-inquiry-pipeline-intake-field` is the narrowest action for one stable intake `field_id`; it requires `pipeline_id`, `field_id`, and a `patch`. Use `get-organization-pipeline-mode` when the organization's mode is unknown; action schemas describe supported fields, not the mode.

`basic_info` contains a name, description, ordered stages, and sources. Stage and source names are unique; colors use `#RRGGBB` or `#RRGGBBAA`, and sources may include an emoji. `intake_flow` contains at least one page with fields. Field types are `header`, `short-answer`, `paragraph`, `multiple-choice`, `checkboxes`, `dropdown`, `date`, `time`, and `signature`. Choice fields require options. Validation types and operations must come from the fresh schema. Preserve the protected system contact fields `first_name`, `last_name`, `email`, and `phone`, including their stable IDs, types, required state, and visibility.

`communication` contains `outreach_enabled`, nullable `subject_instructions` up to 1000 characters, a nullable `goal` up to 5000 characters that the full create schema requires when authoring outreach, `pipeline_channel_type` of `phone` or `email`, and `pipeline_channels` with `enabled` and `disabled` channel IDs. At least one active channel is required. Each selected channel appears once. Active phone channels require texting and AI agent `0` in the number's default assignees. Disable rather than remove a channel that existing inquiries use. Switching from phone to email is blocked when the pipeline has a default call node.

`schedule` contains `schedule_overridden`, an IANA `timezone`, and Monday-through-Sunday time arrays of `{start_time, end_time}` using `HH:MM` with end after start. `branding` contains form header and submit-button text plus the supported six color values. `configuration` contains default assignee IDs, default stage and source, `drop_lead_action` with `bring_back` or `keep_in_drop`, outbound call concurrency, optional cost values, consent settings, and form or iframe submit behavior. Assignee IDs and stage/source values must match the current organization and the supplied pipeline structure. `outbound_call_concurrency_limit` must be at least 0, cannot exceed the organization limit, and must be at least 1 when the intake flow has a call node. If consent is enabled, the consent message is 10 through 1000 characters. Form and iframe submit actions are `thank_you` or `redirect`, with the corresponding conditional message or URL.

When creating or broadly updating a pipeline, inspect the current schema for `goal`. If it contains `goal`, use that field and never send `ai_flow`. If it does not contain `goal`, send neither `goal` nor `ai_flow` and explain that the AI flow must be completed in the Z360 Pipeline UI. For AI-only canvas changes in that mode, do not call the update action. Deleting a pipeline is a hard delete that cascades to associated lead records, and deletion is blocked when the pipeline is connected to a Meta lead form. Search, inspect, confirm, and report the exact pipeline before deletion.

### Ticket settings

The six ticket setting actions are `search-ticket-settings`, `create-ticket-setting`, `update-ticket-setting`, `delete-ticket-setting`, `set-default-ticket-setting`, and `reorder-ticket-statuses`. `setting_type` is `priority`, `status`, or `type`. Search requires `setting_type`, supports optional search with fuzzy or `regex:<pattern>` matching, and uses pagination from 1 through 50 with a default of 15 plus opt-in `total_count`.

Create and update use a `params` branch that matches `setting_type`. For `priority` and `status`, `name` is required, unique within the organization, and no longer than 255 characters; `color` is required and uses `#RGB` or `#RRGGBB`. For `type`, `title` is required and unique with a maximum length of 255, `icon` is required and must be exactly one emoji character, and `description` is optional up to 1000 characters. Type settings can include `default_assignees` for current organization users or agents, including AI agent `0`. New statuses are placed after the current maximum order. An update requires the complete branch for that setting type; it is not a single-field patch.

`delete-ticket-setting` requires `setting_type` and `setting_id`. A setting cannot be deleted when it is a default or has tickets; read current metadata and ticket usage before proposing deletion. `set-default-ticket-setting` changes the future default for the selected type, so read the current default and confirm the exact setting. `reorder-ticket-statuses` requires the complete distinct array of current-organization status IDs in the desired display order; it replaces the whole order, not just the moved IDs.

### Contact custom fields

The settings catalog has `create-contact-custom-field`, `update-contact-custom-field`, and `delete-contact-custom-field`. Use the general contact read action `get-contact-custom-fields` to discover existing field IDs because it is not itself in the Settings section of the catalog.

`create-contact-custom-field` accepts an optional current `preset_key`, a required `name` unless a preset supplies it, a required `type` unless a preset supplies it, optional `options`, and `is_required`. Current custom-field types are `text`, `long_text`, `number`, `dropdown`, `date`, `currency`, `yes_no`, `multi_select`, `secondary_email`, `secondary_phone`, and `address`. `dropdown` and `multi_select` require options; options are ignored for other types. Preset keys and preset-provided names, types, and options come from the current schema. Field names must be unique within the organization.

`update-contact-custom-field` requires `field_id` and supports partial `name`, `type`, `options`, and `is_required` changes. Changing type or options can delete incompatible stored values from contacts, so read the field and confirm that data consequence first. `delete-contact-custom-field` requires `field_id` and deletes the definition and all stored values. Treat both type changes and deletion as destructive data changes even when the action annotation is non-destructive or idempotent.

## Safety and failure rules

- Use only IDs returned for the current organization and the current action schemas. Never substitute a numeric ID from another organization or system.
- Use `0` only where the schema defines it as the AI agent sentinel. It is not a generic placeholder and must not be combined with human receivers where the phone rules forbid that combination.
- Read before write. Search results can be compact, paginated, or filtered, so follow pagination and use a detail action when the write depends on fields that search omits.
- Preserve all current values that the user did not ask to change. For replacement arrays, full ticket orders, pipeline stages, sources, channels, schedules, assignees, or language lists, send the complete intended collection.
- Confirm access changes, member removal, invitation delivery, customer-facing channel routing, AI configuration, pipeline outreach, phone purchase, A2P submission, billing-impacting changes, and all settings or pipeline deletes.
- Treat EINs, phone numbers, addresses, email addresses, compliance samples, policy URLs, provider identifiers, and credentials as sensitive. Do not invent them, expose secrets, or place them in reusable instructions.
- Interpret annotations such as read-only, idempotent, or non-destructive as implementation metadata, not as a reason to skip context, confirmation, or read-back. A role change, routing change, or field-type change can have material effects even when technically idempotent.
- Inspect warnings and normalized response values. A saved configuration does not prove provider approval, message delivery, number health, campaign registration, pipeline execution, or downstream agent behavior.
- After a failed or timed-out write, read current state before retrying. Do not assume the operation was atomic across separate tools or that an external provider did nothing.

## Related references and boundaries

Use `automation-management.md` for creating, updating, activating, pausing, running, or deleting automations. Settings such as agent configuration, channels, team membership, and pipelines can affect an automation's future behavior, but settings tools do not manage an automation record.

Use `pipeline-management.md` for pipeline goals, lead stages, outreach cadence, status transitions, and lifecycle completion. Use `a2p-10dlc.md` for the fuller compliance collection and confirmation workflow. Use `skill-management.md` for reusable procedures and `expert-management.md` for AI Studio Experts. Use the product-model references for [team members](../../product-model/references/team-members.md), [inbox](../../product-model/references/inbox.md), [inquiries](../../product-model/references/inquiries.md), [pipelines](../../product-model/references/pipelines.md), and [integrations](../../product-model/references/integrations.md) when the setting's meaning depends on those objects.

When a request spans settings and records, complete the settings read and confirmation boundary first, then use the record-specific action. Keep each action's returned state separate and report which part is saved configuration versus a record or provider operation.
