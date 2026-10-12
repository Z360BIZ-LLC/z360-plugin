---
name: email-account-management
description: Use when the user wants to connect Gmail or Outlook as a Z360 email account for inbox, sending, conversations, or email collections.
---

# Email account connections

Read `../product-model/SKILL.md` before interpreting email accounts or collections. Use this reference for Settings → Emails connections. For an app's Ask Z tools or automation triggers, use `../workspace-management/references/app-connection-management.md` instead.

Use the email account flow for inbox, sending, receiving, conversations, shared mailboxes, and email collections. Use the app integration flow when the user asks for tools, triggers, automations, or Expert actions. Ask one concise choice only when the surrounding context does not establish either goal.

Use the live tool schemas and `list-ui-components` output as the authority for supported UI.

## Connect Gmail or Outlook

1. Call `z360-read-search-email-accounts` and record the active accounts for the selected provider. If the user wants another account, continue with a new connection.
2. Use provider `id: "gmail"` or `id: "outlook"`. Let the OAuth account picker collect the email address; open the connection card without requesting the address in chat.
3. If the account belongs in a collection, resolve its numeric collection ID with the existing email-collection tools. Use `collection_id: 0` when no collection is needed.
4. Call common `render-ui`:

```json
{
  "component": "mail_connector",
  "props": {
    "id": "gmail",
    "collection_id": 0
  }
}
```

For Outlook, set `id` to `"outlook"`. These provider IDs are distinct from app integration IDs; do not substitute IDs from `search-integrations`.

The card opens the existing OAuth flow and preserves the current Ask Z thread. Tell the user to complete authorization. When the user finishes or asks to continue, call `z360-read-search-email-accounts` again and verify that the intended provider account is active. Treat the connection as complete only after that read succeeds. If a collection is rejected, resolve an accessible collection again.
