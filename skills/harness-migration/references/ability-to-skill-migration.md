# Phase 2: legacy abilities to organization skills

Use this phase for legacy abilities only. Its first checkpoint is a brief audit, inventory, and skill-fleet architecture; its second checkpoint is the user-approved implementation of each target skill. Read the common [Legacy flow playbook](legacy-flow-playbook.md) for graph vocabulary, and use Workspace Management's Skill Management guidance as the authoritative guide for authoring the new skills.

## Inventory before designing

1. Resolve z360-read-search-legacy-abilities in the current Z360 action catalog, fetch its fresh schema, and execute it with status: "all". Use the existing maximum page limit and paginate until every active and inactive ability is inventoried. Include total_count when the schema supports it.
2. Show a compact audit of every ability: ID, name, description or purpose, active state, registration requirement, draft state, and missing-action state. Include inactive abilities in the audit even though they are not selected for migration by default.
3. Keep this first pass shallow. Use the compact discovery metadata and any returned warning summary to identify likely behavior domains, overlap, and risk, but do not fetch the complete flow for every ability or perform a detailed node-by-node conversion before the architecture checkpoint.
4. Read ../workspace-management/SKILL.md and ../workspace-management/references/skill-management.md. Read the existing /skills/org/ entries and relevant system skills, especially customer-communication, to identify capabilities that can be reused instead of recreated.

## Propose the skill fleet

Prepare a concrete architecture proposal before fetching full flows for implementation. The proposal should enumerate the candidate active abilities, the target organization skill name and path for each, any proposed grouping or splitting, the reason for each grouping, overlaps with existing or system skills, the suggested processing order, and any uncertainty that must be resolved from a full flow. The default is one organization skill per active legacy ability, but do not create one skill per ability mechanically when a safe and understandable grouping is evident.

Inactive abilities remain in the audit and migration queue but are skipped unless the user explicitly selects them. If the user wants to group, split, merge, reuse, or omit a capability, explain the tradeoff and update the enumerated fleet. Do not fetch and draft the full set or write any skill until the user explicitly approves the skill-fleet architecture and the selected ability set.

## Implement one approved skill at a time

After architecture approval, process one target skill at a time. If a target skill groups several abilities, enumerate those source ability IDs and treat the grouped target as one approved deliverable. Do not begin the next target until the current target has been reviewed, approved, written, and verified.

For the current target:

1. Fetch the fresh schema for z360-read-get-legacy-ability and read the selected ability. Use its published flow as runtime truth, expose a draft flow for comparison only, and read the common playbook before interpreting nodes, subflows, branches, calls, or action references.
2. Compare the ability with the relevant existing organization and system skills again. Reuse customer-communication or another existing capability when it already provides the behavior; otherwise draft the target organization skill under /skills/org/<kebab-case-name>/SKILL.md.
3. Resolve every executable action against the current Z360 catalog. Search the visible action group and action, then call get-action-schema immediately before recording the action. Legacy action IDs and group IDs are lookup context only.
4. Prepare the complete proposed skill content according to Skill Management guidance, plus a concise example behavior or execution flow that shows how a user or lead would experience it. Include a short mapping summary, prerequisites, branches, cadence, calls, completion or handoff behavior, current tool references, warnings, and any migration gaps.
5. Show the exact target path, full proposed content or diff, example behavior, and unresolved questions. Ask for feedback and explicit approval for this skill before writing. Continue the discussion until the user approves the exact content and target.
6. Immediately before writing, reread the current target skill when it exists and fetch the current schemas for every declared tool. If the source, target, or schema differs from the approved proposal, rebuild the proposal and ask for approval again. Use write_file for a new skill; for an existing skill, show the exact merge diff and use edit_file only after the user approves that merge.
7. Read the written skill back and verify it before moving to the next target. Confirm its frontmatter and organization path, current group_id and action_slug references, declared tools, do blocks, references, branches, prerequisites, retries, stop criteria, and absence of legacy IDs, unresolved placeholders, secrets, endpoints, headers, or connected-account details.

## Translate migration-specific behavior

Use the common playbook to understand the graph, then express its observable behavior in plain language rather than copying legacy JSON:

| Legacy primitive | Organization-skill representation |
|---|---|
| ASK | A plain-language question and a semantic reference to the answer. |
| SAY / SPEAK | Conversational response or instruction text. |
| ACT / DO | A current action-catalog tool with a do block, using the fresh current schema. |
| CONDITION / EVALUATE | Explicit prose if / then / else branches and a fallback path. |
| SUBFLOW | An inline procedure or one-level reference file allowed by Skill Management. |
| CALL | The current outbound-call procedure and call brief, using customer-communication calling guidance. |
| END / END_SCRIPT | Completion, stop, or human-handoff criteria. |
| save_as | A semantic context reference, never a copied legacy variable name. |
| follow_up_gap / max_followups | Explicit cadence prose or supported wakeup behavior. |
| requires_registration | An explicit prerequisite before the skill starts. |

Preserve the ability's trigger, purpose, registration prerequisite, required questions, messages, branches, cadence, action outcomes, call behavior, and completion criteria. State what to do when a tool fails or a required answer is unavailable. If a node type, action intent, branch, subflow, or call behavior cannot be mapped safely, report the exact migration gap and do not write a broken skill or an unresolved placeholder.

Skill Management controls the target skill's ownership, frontmatter, declared tools, do blocks, progressive-disclosure layout, reference placement, cataloged filesystem writes, and read-back verification. Follow that guidance instead of restating its general authoring procedure here; this reference adds only the legacy translation, sequencing, and approval rules.
