---
name: product-model
description: Explain Z360's product model, terminology, records, relationships, channels, capabilities, and common object choices. Use when interpreting Z360 data or building a correct mental model of the application.
---

# Product model

This skill explains what Z360 objects mean and how they relate. It is a conceptual reference, not a task workflow.

## Z360 at a glance

Z360 is an organization workspace for customer operations. The organization owns phone numbers, email accounts, customer-facing channels, conversations, business records, and AI Studio configuration. The Z360 app is where employees manage this work; a deep link is appropriate when the next step belongs in the app.

A Z360 user is an internal employee or collaborator acting inside the organization's account. A contact is an external person or business that the organization communicates with. An Inbox conversation is also called a thread and represents an interaction with a contact. A Deep Agent thread holds the agent's work and is a separate record.

## Read the minimum needed

Classify the request before opening references. Read one direct domain reference when the request concerns a specific object. Read one contrast guide only when two objects could plausibly satisfy the same need. Do not open every reference or every contrast by default. When a request crosses domains, open the smallest set of direct references that explains those relationships, then stop.

An organization uses either Inquiry mode or Work mode for its active pipeline workflow. If the mode is unclear, read [Work Items vs inquiries](contrasts/work-items-vs-inquiries.md) before choosing a record or status model.

The references below are conceptual definitions. Workspace-management references contain the operational workflows and current action details; keep those concerns separate.

## Structure

### Domain references

- [Inbox](references/inbox.md) covers conversations, threads, messages, channels, and timeline composition.
- [Contacts](references/contacts.md) covers external people or businesses and their identity data.
- [Tickets](references/tickets.md) covers durable work records and ownership.
- [Inquiries](references/inquiries.md) covers leads, customer lifecycle, and pipeline-linked records.
- [Work Items](references/work-items.md) covers the Work workflow, stages, statuses, and linked stakeholder conversations.
- [Notes and reminders](references/notes-and-reminders.md) covers internal context and teammate follow-up.
- [Pipelines](references/pipelines.md) covers pipeline configuration in Inquiry and Work modes.
- [Knowledge base](references/knowledgebase.md) covers durable organization documents and folders.
- [Integrations](references/integrations.md) covers connected applications and provider relationships.
- [Team members](references/team-members.md) covers internal organization users and assignment concepts.
- [Library](references/library.md) covers files and attachments shared with Ask Z.
- [Experts](references/experts.md) covers focused AI Studio subagent profiles.
- [Automations](references/automations.md) covers saved schedules and event-driven agent runs.

### Contrast guides

Open a contrast only when the choice is ambiguous. The guides are intentionally short and point back to the domain references for full definitions.

- [Tickets vs notes](contrasts/tickets-vs-notes.md)
- [Tickets vs reminders](contrasts/tickets-vs-reminders.md)
- [Tickets vs inquiries](contrasts/tickets-vs-inquiries.md)
- [Work Items vs conversations](contrasts/work-items-vs-conversations.md)
- [Work Items vs inquiries](contrasts/work-items-vs-inquiries.md)
- [Contacts vs conversations](contrasts/contacts-vs-conversations.md)
- [Contacts vs identifiers](contrasts/contacts-vs-identifiers.md)
- [Conversations vs messages](contrasts/conversations-vs-messages.md)
- [Skills vs automations](contrasts/skills-vs-automations.md)
- [Automations vs reminders](contrasts/automations-vs-reminders.md)
- [Knowledge base vs memory](contrasts/knowledgebase-vs-memory.md)
- [Integrations vs action groups](contrasts/integrations-vs-action-groups.md)
- [Team members vs contacts](contrasts/team-members-vs-contacts.md)

## Core model

Contacts represent external identity. Inbox conversations represent interaction history, and messages are timeline items inside them. Tickets, inquiries, notes, and reminders are business records that can attach to a conversation without becoming separate threads.

Work mode uses Work Items to coordinate a pipeline goal across linked conversations.

Team members are internal organization users who can own, receive, or manage work. Integrations, action groups, knowledge-base content, Experts, skills, automations, and Library files are configuration or assistance surfaces rather than customer identities.

Skills are reusable, progressively disclosed procedures. Experts are focused subagent profiles. Automations are saved trigger contracts that start the main agent on a schedule or event. Pipelines configure lifecycles; an inquiry or Work Item records one execution, depending on the organization's mode.

## Action groups, actions, and schemas

An integration identifies an external application or provider. An action group is the connection-specific capability boundary associated with a provider, account, tenant, or credential scope. An action is one named capability exposed within an action group. Similar action names can exist in multiple groups, so the group identity is part of the operation.

An action schema is the current contract for an action. It describes required and optional fields, types, enum values, limits, permissions, and server-managed output. Schemas can differ across action groups or application versions. The schema returned for the selected group is authoritative; do not infer identifiers, arguments, enum values, or server fields.

The action group, action, and schema describe capability access, not a customer record or business lifecycle. See [integrations vs action groups](contrasts/integrations-vs-action-groups.md) for the provider boundary. Task-specific references contain the current discovery and execution workflow.

## Shared relationships

- A contact is the party, a conversation is the thread, and a message is one timeline item.
- A conversation provides context, while a ticket, inquiry, note, or reminder gives that context a business purpose.
- Customer-facing messages and internal notes are different kinds of timeline content.
- An inquiry tracks customer lifecycle, while the contact supplies external identity.
- The knowledge base is organization-authored reference material, while memory is retained context about people, organizations, or prior interactions.

## Data and action conventions

- Interpret each request through the product object that owns the requested state.
- Resolve identifiers and current option values before changing state. Never invent IDs, slugs, arguments, or enum values.
- Keep records attached to the existing conversation when the request belongs to that thread. A new thread represents a genuinely new exchange.
- Treat Z360 timestamps as UTC unless the current action says otherwise. Interpret relative dates in the user's timezone, then convert them when the action expects UTC.
- Omit optional fields, nulls, empty arrays, empty objects, and explicit defaults unless they are needed for correctness. Omitted update fields normally remain unchanged; replacement fields replace the full existing value.
- Confirm destructive changes and externally visible behavior. Follow returned pagination state and report only records or outcomes returned by the action.
- When two objects overlap, match the object whose lifecycle and visible record fit the business meaning.

## Product-model boundary

The product model answers what an object means, how it relates to other objects, and which business concept it represents. Operational references answer how to manage it and which live action contract applies. Keep concrete tool procedures in those operational references so this model remains stable when the application changes.
