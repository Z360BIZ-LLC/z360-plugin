---
name: customer-communication
description: Handle customer communication workflows in Z360, including customer conversations, messages, follow-up, lead playbooks, and calls. Use when the request concerns an active customer conversation or a communication workflow.
---

# Customer communication

Read the `product-model` skill before using this skill. It explains Z360's records, relationships, channels, and terminology, so you can interpret contact context and choose the right action. Then use the authenticated Z360 action catalog and read the matching reference before acting.

## Use the Z360 action group

Use the dedicated Z360 action group for contact and communication work. Most actions required to inspect and entertain the contact are available in that group. If its `group_id` is not already known in the current context, find it with `search-action-groups`, then use that same group for `search-actions`, `get-action-schema`, and `execute-action` throughout the task. Never guess the group or switch connections without a reason from the catalog or the user.

Keep internal notes separate from customer-facing messages. Determine the channel and handling status before sending anything. Use the action schema's exact fields. Never claim a message or call was sent until the action confirms it.

## Live-chat identity linking

When creating a contact from an active conversation, first call `get-conversation`. If `conversation.type` is `live_chat`, use its exact `visitor_id` (`conversation.identifier.value`). After `create-contact` returns, call `connect-visitor-to-contact` with that visitor ID and the returned `contact.id`; this links the existing Live Chat conversation to the new contact. Email and phone identifiers link automatically when their matching contact is created.

## Recipient communication status

When an external contact asks to stop outreach, says do not contact them, asks to be blocked or unblocked, or another workflow requires a communication restriction, read `../customer-communication/references/dnd-and-blocking.md` before changing status.

## Terminal escalation

When an external contact becomes severely abusive, threatening, unsafe, or otherwise requires immediate termination, read `../customer-communication/references/escalation.md` before taking any further customer-facing action. Stop messaging immediately and follow its internal-only workflow.

## Build contact background when needed

Before sending the first message, read `../workspace-management/references/contact-audit.md` to build the contact's relevant background when the current context does not provide enough information. Start with its focused-context scope; expand to a complete audit only when the user asks for a dossier or history, or when wider records could change the response. Treat established identity and thread state as sufficient—do not repeat lookup merely to reconfirm them.

## Answer business questions from the knowledge base

When the contact asks about the business, such as contact details, services, hours, or policies, call `search_knowledge_base` and answer from its result. Search before telling the contact something is unavailable, even when an earlier call summary or ticket says it was.

## Match the contact's channel

Determine the contact channel before composing an outbound message. The `get-conversation` action returns `conversation.type`. These rules apply only to the message body sent to the contact. The user's `commentary` and `final` channels remain back-channel communication.

- `phone` is SMS. Write one or two sentences under about 320 characters. Use plain conversational text with no greeting line, sign-off block, headings, or bullets. Name the business only in the first message. Include a link only when the contact cannot act without it. Use at most one emoji, and only when the business voice invites it. Call records may appear in this conversation, but a reply is still SMS.
- `live_chat` is a typed conversation. Write one to three short sentences. Do not use a salutation or sign-off. Ask one question at a time.
- `email` is a written email. Open with a greeting, use short paragraphs with blank lines, write complete sentences, and close with a sign-off naming the business. Do not add a subject line because the reply stays on the existing thread.
- `fax` carries a PDF document rather than a text reply. Follow the faxing reference before starting or replying to a fax conversation.

Message bodies support plain text and line breaks. Markdown reaches the contact literally. Keep customer-facing wording inside the sending action.

## Faxing

When the user asks to send a fax or an active communication workflow requires one, read `../customer-communication/references/faxing.md` before acting. Follow it to select an available fax number, use the Ask Z PDF attachment path, create or reuse the fax conversation, and distinguish a queued send from confirmed delivery.

## Lead execution

When an Inbox conversation is bound to an active lead pipeline, read `../customer-communication/references/lead-execution.md` before executing the lead's outreach or follow-up goal. Use its workflow for conversation context, lead progress, replies, notes, reminders, escalation, and stop conditions.

## Outbound calling

When the user's request or an active communication goal requires a real outbound call, read `../customer-communication/references/outbound-calling.md` before acting. Follow its workflow for resolving phone numbers, writing the call goal, placing the call, scheduling a wakeup, and checking the outcome. Do not treat a call as complete until the action result and any required follow-up checks confirm its state.
