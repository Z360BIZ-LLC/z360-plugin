---
name: contact-audit
description: Build a read-only background or complete audit for a Z360 contact through the action catalog. Read this reference when an unambiguous contact_id is available and more context is needed, or when the user asks for a contact history or dossier.
---

# Contact audit

Use this reference to build contact context without editing records. It covers identity, conversations, messages, notes, reminders, inquiries, tickets, and open work. Read `../product-model/references/contacts.md` and [contacts vs identifiers](../../product-model/contrasts/contacts-vs-identifiers.md) when matching identity data. Read [team members vs contacts](../../product-model/contrasts/team-members-vs-contacts.md) when interpreting ownership or assignee fields. Read `../product-model/references/inbox.md` for conversations and messages, and [tickets](../../product-model/references/tickets.md), [inquiries](../../product-model/references/inquiries.md), or [notes and reminders](../../product-model/references/notes-and-reminders.md) when interpreting linked records.

## Choose the audit scope

- **Focused contact context:** Establish identity and inspect only the records immediately relevant to the question or next action. Read recent messages, the active or recently changed inquiry, pending notes or reminders, open tickets, and prior commitments only when they can change the result. Expand to other conversations only when the current context leaves a decision-relevant gap.
- **Complete contact audit:** Follow the full workflow and output structure for a customer dossier, relationship summary, complete history, or explicit record audit.

## Lookup discipline

- Carry forward an unambiguous `contact_id`, identity, conversation, or record that is already established. Do not repeat a lookup merely to reconfirm a fact that the current context supports.
- Start with the narrowest read that can answer the question. Do not search unrelated conversations or records, retrieve full histories or transcripts, or expand into another record type unless the result could change the answer, next action, or requested audit.
- Stop when the available evidence is sufficient. Expand the audit only for a concrete gap, contradiction, or ambiguity that matters to the task.

## Tools

- `search-contacts`
- `search-conversations`
- `get-conversation`
- `search-messages`
- `search-notes`
- `search-reminders`
- `search-inquiries`
- `search-tickets`
- Optional read helpers: `get-inquiry-options`, `get-ticket-options`

## Workflow

1. If an unambiguous `contact_id` and its identity are already established, carry them forward without another contact lookup. If only the ID is known, retrieve enough contact data to confirm the identity before expanding the audit. Otherwise, resolve the contact with `search-contacts` using name, email, phone, tag, or regex. If multiple contacts match, ask the user to choose before proceeding.
2. Record the contact ID, name, email, phone, tags, favorite status, and created date when the search result returns them.
3. Search related records by `contact_id`:
   - Conversations with `search-conversations`.
   - Leads/inquiries with `search-inquiries`.
   - Tickets with `search-tickets`.
4. For each relevant conversation, call `get-conversation` and then `search-messages` when the timeline, latest customer message, phone call, failed message, or composition records matter. In focused-context scope, prioritize the current and recent conversations; in complete-audit scope, inspect every relevant conversation returned.
5. Search notes and reminders by `conversation_id` for each relevant thread. Search by contact text only when conversation links appear incomplete, and mark text-only matches as unverified until the relationship is confirmed.
6. Identify:
   - Open conversations needing response.
   - Active or recently changed leads.
   - Open tickets or unresolved customer issues.
   - Pending reminders and internal notes.
   - Recent inbound/outbound messages and calls.
7. Build a chronological timeline only from records actually returned by tools. Do not invent missing events or infer that an absent record never existed.

## Guardrails

- Never guess contact IDs or collapse multiple contacts into one audit without user confirmation.
- Do not write during an audit unless the user explicitly asks for a follow-up action.
- Avoid dumping full message bodies unless the user asks for detailed transcript context. Summarize relevant content.
- Keep PII proportionate: show enough identity to confirm the contact, then prefer IDs and concise labels.
- If linked records are absent, say they were not found instead of treating absence as proof the customer never interacted.

## Output

Use this structure:

- Contact: ID and identity summary.
- Current state: relationship status, current thread and channel when applicable, latest customer ask, open work, ownership, and urgency.
- Timeline: newest-to-oldest key events across conversations, messages, inquiries, tickets, notes, and reminders.
- Leads/inquiries: IDs, pipeline/stage/status/source, assignees, and notable fields.
- Tickets: IDs, status/priority/type, assignees, archive state, and linked conversation.
- Conversations: IDs, channel/type, latest direction/status, tags/read/archive state, and next action.
- Internal context: notes and reminders, especially pending follow-up.
- Gaps: ambiguous duplicate contacts, missing conversation links, or records requiring another tool/query.
