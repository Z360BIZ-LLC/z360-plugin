---
name: dnd-and-blocking
description: Manage a recipient's Do Not Disturb or blocked communication status from an active customer conversation. Read when a contact asks to stop outreach, requests DND, asks to be blocked or unblocked, or a workflow must change recipient communication status.
---

# Do Not Disturb and blocking

Use this reference whenever you need to stop outreach, enable Do Not Disturb, or block a specific recipient.

## Which recipient details are affected

Use the exact email address, phone number, or live-chat visitor identifier from the current conversation. Live chat uses `visitor_id`.

The recipient may be anonymous or linked to a contact:

- If it is linked to a contact, changing one of the contact's email addresses, phone numbers, or visitor identifiers changes the same setting for all of them. Updating any linked identifier affects the whole contact.
- If it is not linked, only that exact recipient detail changes.
- Existing and future conversations using an affected detail follow its current setting, so outbound messages and calls are stopped without changing each conversation separately.

## What the statuses do

- `dnd_status: true` means Do Not Disturb. It prevents outbound messages and calls while allowing inbound messages.
- `is_blocked: true` means blocked. It prevents inbound and outbound messages and calls.
- Set a status to `false` only when the request or policy explicitly removes that restriction. Do not change an unspecified status.

Both values are independent. If the workflow explicitly requires both, provide both in the same action call. At least one status value is required.

## Change the status

1. Use the current conversation context to resolve the exact recipient identifier type and value. Do not infer an identifier from a Contact search when the conversation already supplies it, and do not guess a value.

2. Use `z360-write-update-identifier-communication-status` with the exact identifier type and value and the requested boolean status. Provide at least one of `dnd_status` or `is_blocked`.

3. Verify the action result. Report a status change only when the result confirms it. After a successful opt-out or block, do not send a customer-facing follow-up unless a separate policy explicitly requires one. If execution fails, stop outreach, record the confirmed failure through an appropriate internal action, and do not claim that the status changed.
