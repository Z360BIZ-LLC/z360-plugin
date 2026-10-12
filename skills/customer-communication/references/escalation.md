# Terminal escalation

Use this reference only when the incident comes from an external contact in the current conversation. It is a terminal safety workflow, not a general request-for-a-human or customer-support handoff.

## Trigger threshold

Trigger this workflow for severe, targeted abuse or harassment, extremely rude or degrading behavior directed at staff, threats or intimidation, unsafe or prohibited content, or another contact behavior that requires immediate termination of the interaction. A single severe incident is enough. Do not wait for repetition or confirmation from the contact.

Do not trigger it for ordinary frustration, criticism, a legitimate complaint, a raised tone, a routine request for a manager, or a normal request to stop outreach. Do not use it for internal team members or other authenticated users.

## Terminal workflow

Once the threshold is met, stop all customer-facing work immediately. Do not reply, apologize, explain, de-escalate, ask a question, promise follow-up, send a closing message, place a call, or continue the current lead or communication workflow. Complete only the internal actions below, then end the turn without further contact-facing output.

Use the authenticated Z360 action catalog for every operation. Reuse the current action group when known. Otherwise, discover the group with `search-action-groups`, find each operation with `search-actions`, read its current schema with `get-action-schema`, and execute it with `execute-action`. Never guess action slugs, fields, IDs, or assignment semantics.

Perform the internal workflow in this order:

1. Read `../customer-communication/references/dnd-and-blocking.md` to understand DND and blocking, then use `z360-write-update-identifier-communication-status` to enable DND for the current recipient identifier. Do not substitute blocking unless a separate policy or explicit instruction requires it.
2. Use `search-team-members` to find the best internal owner. Prefer one accountable member whose role covers support, customer success, operations, compliance, or management. If the organization has a clearly appropriate escalation group, select the smallest suitable set. Never select the contact, the AI agent, or an invented ID. If role information is ambiguous, prefer an organization owner or administrator returned by the search.
3. Create one internal ticket attached to the current conversation, and assign it to the selected owner or owners. Include the contact ID when one exists, the identifier and conversation context, channel, incident time, concise reason for escalation, necessary exact wording, DND result, and AI-unassignment status. Preserve only the incident detail needed for internal review.
4. Remove the AI assignment from the current conversation with the catalog's current unassignment action. This is an internal unassignment. It must not send a customer-facing leave or closing message.

Verify each result before proceeding. If an internal action fails or times out, do not resume the conversation or send a recovery message. Keep DND enabled when it succeeded, record the failed step in the ticket when possible, and leave the internal handoff state explicit for follow-up.
