# Work Items

Work mode uses a Work Item for one execution of a pipeline goal. It stores the submitted form data, pipeline and source, current stage, and status. The pipeline defines the reusable objective and sequence; the Work Item records what happened for this submission. The [pipeline reference](pipelines.md) describes that shared configuration.

A Work Item can involve several Contacts and assigned Users. Contacts are external parties reached through Inbox conversations; Users are organization members who can provide internal decisions. A Work Item can link several conversations, and one conversation can be relevant to more than one Work Item. Whether a contact's response changes or completes the work depends on the pipeline goal.

The Work Item has its own thread to coordinate the workflow. A linked Inbox conversation can have a separate agent thread that handles customer communication. The Work Item thread can ask an Inbox thread to communicate and later use the reported result as evidence. These agent threads do not replace either business record.

Stages describe the Work Item's position in the pipeline. Status describes its broader outcome:

- `todo`: work has not started.
- `in_progress`: work is underway or waiting on a required response.
- `completed`: the pipeline goal has been achieved.
- `failed`: the goal's stop or failure condition has been confirmed.

A stage name alone does not prove completion or failure. The submitted form values supply facts for this Work Item; they do not rewrite the pipeline goal. Inquiry mode uses a different record, status model, and conversation relationship. Related contrasts: [Work Items vs inquiries](../contrasts/work-items-vs-inquiries.md) and [Work Items vs conversations](../contrasts/work-items-vs-conversations.md).
