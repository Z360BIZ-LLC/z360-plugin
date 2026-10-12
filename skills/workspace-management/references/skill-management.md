---
name: skill-management
description: Create, inspect, update, organize, and delete reusable Z360 skills for an organization, a user, or a specific Expert. Read this reference when the user wants to teach a repeatable workflow, save a procedure for future conversations, revise an existing cataloged skill, or delete a skill or one of its files.
---

# Skill management

Read `../product-model/contrasts/skills-vs-automations.md` when deciding whether the request needs a reusable skill or a scheduled or event-driven automation, and read `../product-model/references/experts.md` when the request may need a distinct Expert profile. This reference covers authoring and managing skills through Ask Z and the Skills UI; it does not redefine the product model.

Create a skill for work that will recur and keep a one-off request in the current conversation. The root assistant authors skills through Ask Z, and the Skills UI catalogs and previews them after they are written. A skill can be organization-owned, user-owned, or owned by one Expert; expert-owned skills are explained in `expert-management.md` and must remain under that Expert's scope rather than being saved as an organization or user skill.

## Choose the scope

| Scope | Path | Visibility |
|---|---|---|
| **organization** | `/skills/org/<skill-name>/SKILL.md` | Everyone in the organization |
| **user** | `/skills/user/<skill-name>/SKILL.md` | Only the current user |
| **expert** | `/skills/experts/<expert-runtime-id>/<skill-name>/SKILL.md` | The named Expert/subagent profile |

Choose organization scope for a shared procedure or policy, user scope for a private workflow or preference, and expert scope only when the procedure is part of one Expert's focused responsibility. Before authoring an expert-owned skill, confirm the target Expert and read `expert-management.md`; do not use expert scope as a substitute for defining a clear Expert profile. System skills are maintained with application source and are not authored from a conversation.

### Resolve the expert runtime id

Expert tools return two different identifiers: a numeric database `id` and a string `runtime_id`. An expert skill path uses the `runtime_id` only. Before writing anything under `/skills/experts/`, resolve the target Expert with `search-experts` or `get-expert` and use the `runtime_id` from that result verbatim, exactly as returned—do not transform, slugify, or reconstruct it, and never guess it. The numeric `id` must never appear in an expert skill path.

For example, for an Expert returned with `id: 563` and `runtime_id: test_subagent`, save the skill at `/skills/experts/test_subagent/<skill-name>/SKILL.md`, not `/skills/experts/563/<skill-name>/SKILL.md`.

## Delete a skill or one of its files

Find the Delete Skill action in the Z360 group action catalog and use the exact agent-visible `virtual_path`. Deleting a skill's `SKILL.md` deletes the entire skill and all reference files. Deleting another file removes only that file. Confirm the exact path and consequence with the user before calling the action.

## Clarify the requirement

Before writing, ask focused questions until the whole procedure is unambiguous:

- What starts the workflow, and what should not trigger it?
- What outcome means it succeeded?
- What are the steps and decision branches, including not-found and failure paths?
- Which values, formats, guardrails, confirmation points, and retry limits are exact?
- Which actions or coded tools does it need?
- Where does the workflow continue in another skill or reference, and what has to be true for it to go there?

Play the procedure back in plain language and get explicit confirmation before any write. Never fill missing business rules or identifiers with assumptions. If the requested behavior is really a distinct role with its own purpose, instructions, reasoning, action access, and ownership boundary, recommend an Expert instead of hiding that design inside a skill.

## Resolve every action

The authenticated action catalog is available to the root assistant. For each catalog action:

1. Use `search-action-groups` and `search-actions` to find the real action.
2. Call `get-action-schema` immediately before recording its parameters.
3. Record the exact `group_id` and `action_slug` returned by the catalog.
4. Use only fields in the returned schema; never invent names, ids, or enum values.

Built-in coded tools such as `search_knowledge_base` are recorded with `kind: internal` and do not need catalog ids. Include `get-conversation-id` only when an action schema requires a model-supplied `conversation_id`; call it once before the first action that needs that value. Keep action-group access and connection-specific details accurate for the scope in which the skill will run.

## Write one entry point

Write exactly one `SKILL.md` in the chosen scope. Keep the entry point concise and move lengthy procedures into sibling Markdown references. The model reads those files only when the entry point matches the request.

```yaml
---
name: <kebab-case-name>
description: <what it does and when to use it>
tools:
  - name: <catalog action name>
    group_id: <real group id>
    action_slug: <real action slug>
  - name: search_knowledge_base
    kind: internal
---
```

Use numbered prose for the procedure. Put each action call in a ` ```do ` block with one plain-language fill line per value the model supplies. Keep ids, secrets, authentication, endpoints, and server-supplied fields out of the body. Describe failure handling and confirmation requirements explicitly. Do not duplicate a system, organization, user, or expert skill's instructions without a reason; link to the narrower reference or split the procedure into progressive-disclosure files instead.

For a conversation-scoped action, use this shape:

````
## Get the conversation id
Call `get-conversation-id` once and use its result in the next action.

```do get-conversation-id
```

```do create-note
conversation_id: the id returned above
body: the confirmed note text
```
````

## Hand off to another playbook

When a procedure continues in another skill or reference, end that step with a ` ```goto ` block instead of prose. A sentence telling the model to read another file is unreliable: it sits at the end of a long procedure and competes with the reading agent's own rule against opening files it was not sent to. The block is what makes the handoff survive.

Put the destination path on the info line and use two fill lines:

````
```goto /skills/org/<skill-name>/references/<reference>.md
when: the plain-language condition that must hold on this conversation
carry: the ids and confirmed values the next file's steps need
```
````

Name the exact file whose steps run next, never the destination's `SKILL.md`, and use the scope prefix that file is saved under. Confirm the destination exists before recording it; a `goto` to a missing path ends the workflow silently.

Gate `when` only on values the procedure reliably produces by that point. A condition that depends on an optional or best-effort step — a ticket that may fail to write, a field the user may decline — strands the handoff every time that step is skipped, and the work simply stops with no error. When the destination genuinely cannot run without a value, make the step that produces it a hard prerequisite earlier in the procedure rather than a condition here. List in `carry` everything the destination needs, so it does not re-ask for values already confirmed.

## Save and verify

Write to `/skills/org/<skill-name>/SKILL.md`, `/skills/user/<skill-name>/SKILL.md`, or `/skills/experts/<expert-runtime-id>/<skill-name>/SKILL.md` with the cataloged filesystem tools. Read the file back after writing and verify:

1. The path and frontmatter match the confirmed scope, owner, and name. For an expert skill, confirm that the segment after `/skills/experts/` is exactly the selected Expert's `runtime_id` as returned by `search-experts` or `get-expert`, and not its numeric `id`.
2. Every catalog action has real `group_id` and `action_slug` values.
3. Every ` ```do ` block names a declared tool.
4. Every ` ```goto ` block names a path that exists, with a `when` the procedure can actually satisfy and a `carry` listing what the destination needs.
5. Required schemas, branches, guardrails, and failure paths are present.
6. No secrets, invented ids, unresolved placeholders, or unsupported fields appear.

Tell the user the scope, owner when relevant, path, and future trigger. Do not claim the skill is available until the write and read-back both succeed.


## Design progressive disclosure

Keep the parent `SKILL.md` as the entry point: include the skill's purpose, trigger, selection guidance, shared guardrails, and a map of the procedures it can load. When a skill covers several meaningful workflows, variants, or a large amount of detail, create sibling Markdown references inside that skill and link each one directly from the parent with a clear instruction for when to read it. Treat each reference as a sub-skill in structure, not as a separately cataloged skill: it should contain only the detail needed for its branch and should be loaded only when that branch is relevant.

For example, keep references beside the parent entry point in a `references/` folder:

```text
customer-follow-up/
├── SKILL.md
└── references/
    ├── email-follow-up.md
    └── sms-follow-up.md
```

The parent `SKILL.md` should link to each file and explain its trigger, such as `/skills/org/customer-follow-up/references/email-follow-up.md` for an organization skill. Use the corresponding `/skills/user/` or `/skills/experts/<expert-runtime-id>/` prefix for other scopes. Do not create each reference as a separate top-level skill folder or expect it to appear in the root skill catalog.

Apply the same authoring rules to a reference as to a parent skill. Clarify its trigger, outcome, branches, exact values, action requirements, confirmations, retries, and failure paths; resolve every catalog action and schema; use progressive-disclosure-friendly `do` blocks; and read the file back after writing. Do not create a reference for every small request or split a short skill artificially. Add this extra layer only when it clearly reduces context, separates a real workflow or variant, or keeps a large parent skill understandable. Keep references one level deep from `SKILL.md`; avoid chains of references that make the procedure difficult to discover. A ` ```goto ` handoff is not such a chain: the files it moves between are each one level deep, and it is the supported way to continue one request across skills.
