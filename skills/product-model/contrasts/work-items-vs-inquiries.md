# Work Items vs inquiries

A **Work Item** is one execution of a pipeline goal in Work mode. Its intake and linked conversations may involve several stakeholders. Its statuses are `todo`, `in_progress`, `completed`, and `failed`.

An **inquiry** is the lead record for a customer's progression through a pipeline in Inquiry mode. It can appear as a composition in an Inbox conversation and uses inquiry statuses.

## Boundary

An organization uses one active pipeline execution mode at a time. If the current task does not establish the mode, call the read-only `get-organization-pipeline-mode` Z360 action. It returns `work` or `inquiry` for the current organization. Use that mode's record, workflow, and statuses throughout the task. A known Work Item or inquiry already establishes the mode for work on that record; do not look up the mode again just to handle it. Historical records in the other mode may remain, but they do not make both workflows active. Do not create a parallel record or apply the other mode's statuses.

Related definitions: [Work Items](../references/work-items.md) and [Inquiries](../references/inquiries.md).
