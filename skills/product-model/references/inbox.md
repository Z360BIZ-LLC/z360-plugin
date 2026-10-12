# Inbox

The Inbox is the customer-interaction surface for conversations, messages, internal activity, and records attached to a thread. A conversation normally belongs to one contact. The conversation is the container for the timeline; it is not the same thing as one message or one business record.

## Conversations and messages

A message is a timeline item inside a conversation. Common message types are `text`, `composition`, `ai_log`, `ai_tool`, `phone_call`, and `fax`. A `composition` connects a business record such as a ticket, inquiry, note, or reminder to the conversation. One thread can therefore contain several business records without creating several threads.

The conversation channel describes how the organization communicates with the contact. Z360 supports SMS, email, live chat, and phone conversations. Phone activity can appear in a phone conversation, while text messaging on that number remains an SMS interaction. A phone conversation with the same channel and recipient combination reuses the existing thread; email can produce separate threads even when the sender and recipient are unchanged.

Fax is a communication channel with inbound history and outbound PDF-document activity. It is distinct from ordinary phone messaging. Calls are organization activity carried out under the configured agent identity, not an “AI call”. Calls and other internal activity are timeline context; they are not customer-facing text messages.

Outbound text belongs in an existing email, phone, or live-chat conversation, and its body is customer-facing. Internal notes belong in the employee back-channel rather than the message body. An outbound fax carries one PDF attachment and may create or reuse a fax conversation.

## Thread boundaries

A conversation is the right home for an interaction that belongs to an existing customer thread. Tickets, inquiries, notes, and reminders can be attached to that thread as composition messages. A new thread represents a genuinely separate exchange, not merely a new record about an existing exchange.

Internal employee commentary and final responses are application-level response channels, not Z360 customer communication channels. Customer-facing messages, internal notes, and AI activity should remain distinct in the timeline.

Related contrasts: [contacts vs conversations](../contrasts/contacts-vs-conversations.md) and [conversations vs messages](../contrasts/conversations-vs-messages.md).
