# Pipelines

A pipeline is a reusable configuration for a customer lifecycle. It defines a repeatable outreach or qualification process rather than representing one contact, one conversation, or one execution record.

A pipeline can describe a goal, stages, sources, channels, timing, stop conditions, and terminal outcomes. Its `goal` is the plain-language instruction for the business objective and lifecycle, not only the first message or one stage. The pipeline is the shared model; an inquiry or Work Item records one execution according to the organization's mode.

In Inquiry mode, stages describe where an inquiry is in the process. Status describes the broader state of the inquiry, and a stage change is not a status change. Inquiry statuses have these meanings:

- **Active** means the inquiry is currently being worked through its pipeline. Only one inquiry can be active in a conversation.
- **Secured** means the pipeline goal was achieved. It does not necessarily mean that a new customer was acquired.
- **Dropped** means the cadence stopped before the goal was achieved, including when the defined attempts were exhausted.
- **Declined** means the contact or business declined the opportunity, so the cadence should not continue without a new instruction.
- **Idle** means another inquiry occupies the conversation, so this inquiry cannot currently be active.

Pipeline configuration can influence how outreach proceeds, when it stops, and how a completed or unsuccessful outcome is represented. It does not replace the conversation history, contact identity, ticket ownership, or inquiry record.

Related domain: [inquiries and leads](inquiries.md).

## Work mode

A pipeline in Work mode creates Work Items as its execution records. Work Items have their own statuses and can link conversations for several stakeholders. The [Work Items reference](work-items.md) defines this mode. If the organization's mode is unclear, read [Work Items vs inquiries](../contrasts/work-items-vs-inquiries.md) before choosing a workflow.
