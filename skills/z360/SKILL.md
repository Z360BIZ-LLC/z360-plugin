---
name: z360
description: Use when the user asks to look up or change anything in their Z360 organization, such as contacts, conversations, tickets or inquiries. Explains how to find the right Z360 action, build its arguments and run it safely.
---

# Z360

Z360 exposes its features as actions, grouped by app. The Z360 MCP server gives four tools to reach them:

1. `search-action-groups`: list the action groups (apps) available in the connected organization.
2. `search-actions`: find actions in one group. Pass the `group_id` and a short query.
3. `get-action-schema`: read the arguments an action needs. Always call this before running an action.
4. `execute-action`: run the action with `group_id`, `action_slug` and `arguments`.

## How to work

- Search first. Never guess a `group_id`, `action_slug` or argument name.
- Build `arguments` only from the schema returned by `get-action-schema`.
- Before running an action that creates, changes, sends or deletes something, tell the user exactly what will happen and wait for their confirmation.
- Read actions can run without confirmation.
- If an action fails, show the error to the user and fix the arguments from the schema; don't retry blindly.
- The connection works on the one organization the user chose when signing in. To use another organization, the user reconnects and picks it.
