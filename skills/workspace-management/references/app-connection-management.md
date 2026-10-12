---
name: app-connection-management
description: Use when the user wants to discover app integrations and their actions or triggers, connect an app, or remove a configured app, custom API, or custom MCP server.
---

# App integration management

Read `../product-model/SKILL.md` before interpreting integrations, action groups, or custom connections. Use the authenticated Z360 action catalog for discovery and removal, and common `render-ui` for setup. The live tool schemas and `list-ui-components` output are authoritative.

## Choose app integration or email account

Use app integrations when Ask Z or AI Studio needs an app's tools, triggers, automations, or Expert actions. This includes Composio apps and custom API/MCP builders.

For Gmail or Outlook inbox, sending, receiving, conversations, shared mailboxes, or email collections, read `../workspace-management/references/email-account-management.md`.

## Discover before connection

1. Call `search-integrations` with the app name or desired capability. Results include `id`, `name`, `description`, `authentication_type`, `auth_fields`, `actions_count`, and `triggers_count` by default.
2. If multiple results are plausible, resolve the user's intended app. Use authentication type and field definitions to explain the setup requirements; do not assume OAuth always has no fields.
3. To browse a pre-built app's catalog, choose the relevant tool below. A connected account or action group is not required.

| Request | Tool | Required input |
| --- | --- | --- |
| Available actions | `search-integration-actions` | Numeric `integration_id` from `search-integrations` |
| Available triggers | `search-integration-triggers` | Numeric `integration_id` from `search-integrations` |

Both tools accept optional `query`, `page`, `per_page`, and `includes: ["total_count"]`. They return paginated results containing `integration_id`, `integration_name`, `name`, and `description`. Follow pagination when more results are needed. These catalog results describe capabilities; they do not provide executable action slugs or automation trigger configuration.

## Open app setup

Call common `render-ui` with the exact integration ID returned by discovery:

```json
{
  "component": "integration",
  "props": {
    "integration_id": "<id returned by search-integrations>"
  }
}
```

Only this UI component expects `integration_id` as a string. Convert a numeric pre-built integration ID to a string for rendering; keep it numeric for the catalog search tools.

Tell the user the connection panel is open and they should complete authorization or setup. Rendering a card does not establish a connection. Verify the resulting configured group with `search-action-groups` before using it, resolving the correct account and ownership if several match.

## Custom API and custom MCP

Search for `custom API` or `custom MCP` with `search-integrations`. These setup options have exact IDs `custom-api` and `custom-mcp`, `authentication_type: null`, empty `auth_fields`, and zero catalog action/trigger counts.

Their `configuration_fields` list describes the existing setup form:

- Custom API: `name`, `description`, `authentication`, `headers`, `method`, `endpoint`, `arguments`.
- Custom MCP: `name`, `ownership`, `server_url`, `transport`, `authentication`, `headers`, `tools`.

These are field names, not an input schema with required flags or allowed values. Open the existing form with `render-ui` using the returned builder ID. The user chooses authentication during setup. Do not send builder IDs to the numeric catalog search tools; custom builders have no pre-connection catalog. After setup, discover their configured groups and actions with `search-action-groups` and `search-actions`.

## Use connected capabilities

For execution, resolve the visible configured `group_id` with `search-action-groups`, then call `search-actions` within that group. Use its returned `action_slug` and `group_id` with `get-action-schema` before constructing `execute-action` arguments. Integration IDs identify catalog apps; group IDs identify configured connections and must not be substituted for each other.

For an automation, follow `../workspace-management/references/automation-management.md`. Use `get-automation-options` to resolve usable trigger and action-group identifiers after connection, then `get-automation-trigger-config` for required trigger fields. A catalog trigger name is not a configured automation trigger identifier.

## Remove configured apps

Resolve the exact visible target and explain the scope before calling `remove-integration`. An explicit user request to remove that resolved target is authorization; ask for clarification when the target or scope is unclear.

| `target_type` | `target_id` | Removal scope |
| --- | --- | --- |
| `connected_integration` | Numeric `group_id` from `search-action-groups` | One configured Composio connection |
| `custom_mcp` | Numeric custom MCP `group_id` from `search-action-groups` | The custom MCP server and its imported actions |
| `custom_api` | Exact `action_slug` from `search-actions` in the relevant visible group | One custom API action |

Individual action removal is supported only for custom APIs. For Composio or custom MCP, removal applies to the connection/server group. A custom API slug must identify exactly one visible custom API action; if removal reports not found or an ambiguous slug, resolve the target again rather than guessing an ID or deleting a broader group.

Report success only after the removal tool succeeds. If it fails, preserve the distinction between a missing/inaccessible target and a provider disconnection failure, and explain the next step using the actual response.
