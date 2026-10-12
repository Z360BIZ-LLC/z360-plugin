---
name: lead-management
description: Manage Z360 leads through the action catalog. Read this reference when searching, creating, qualifying, updating, assigning, staging, closing, deleting, or linking a lead, or when discovering the pipeline, stage, source, status, form field, contact, team member, or conversation identifiers needed for lead work.
---

# Z360 Lead Management

For an existing inquiry, read `../product-model/references/inquiries.md` for its model. If the request could refer to either an inquiry or a Work Item, read `../product-model/contrasts/work-items-vs-inquiries.md` and resolve the organization's mode before choosing a workflow. Read `../product-model/references/inbox.md` or `../product-model/references/contacts.md` when the request is conversation- or identity-scoped. If identity matching is ambiguous, open [contacts vs identifiers](../../product-model/contrasts/contacts-vs-identifiers.md). Use this reference with the authenticated Z360 action catalog. Some action slugs still use the term `inquiry`; use the exact slug returned by the catalog.

## Tools

- `search-inquiries`
- `get-inquiry-options`
- `get-pipeline-form-fields`
- `search-inquiry-pipelines`
- `get-inquiry-pipeline`
- `create-inquiry`
- `update-inquiry`
- `delete-inquiry`
- Supporting discovery: `search-contacts`, `search-conversations`, `search-team-members`

## Workflow

1. Identify whether the request is read, create, update, assignment, pipeline movement, qualification, or deletion.
2. For existing leads, search first using the strongest known identity: inquiry ID, contact name/email/phone, contact ID, conversation ID, pipeline, status, stage, source, assignment, field values, or created date.
3. Before setting pipeline-specific data, call `get-inquiry-options` or `search-inquiry-pipelines`; call `get-inquiry-pipeline` when stage/source context is needed.
4. Before writing custom field values, call `get-pipeline-form-fields` for the target pipeline unless the field names or IDs are already known from the user or previous tool output.
5. Resolve assignees through `search-team-members`; pass returned user IDs as replacement `assigned_user_ids`.
6. Resolve contacts through `search-contacts` when the request may refer to an existing person or business.
7. For create:
   - Use defaults for stage/source unless the user explicitly requests a specific value.
   - Include required contact fields and only the custom fields needed for the request.
8. For update:
   - Omit fields that should remain unchanged.
   - Use stage/source/status IDs or values only after discovery.
   - Treat assignment arrays as full replacements.
9. Delete only when the user explicitly asks to delete a lead/inquiry.

## Guardrails

- Never guess lead, pipeline, stage, source, contact, conversation, or user IDs.
- Do not change default stage/source/status/assignment behavior unless the task requires it.
- Do not create duplicate contacts or leads when search results plausibly match the requested person.
- Do not infer a lead is lost, secured, or disqualified without user instruction or clear business evidence.
- If several leads match, present the candidates and ask for disambiguation before writing.

## Output

For reads, summarize matching leads with ID, contact, pipeline/stage/status, source, owner, created date, linked conversation if present, and notable fields.

For writes, report exactly what changed, which IDs were used, and which fields were intentionally left unchanged.
