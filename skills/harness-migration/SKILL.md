---
name: harness-migration
description: Use only when the user explicitly asks to start or perform a Harness migration for an organization on the customer-facing-deep-agent rollout; never trigger for general Harness, skills, pipelines, or configuration work.
---

# Harness migration

Use this skill only when the user explicitly asks to start or perform a Harness migration. Do not invoke it merely because the user mentions Harness, an ability, a skill, a pipeline, agent configuration, or a migration-related concept. If the request is not explicitly about migrating the organization's legacy Harness, leave this skill unused.

## Purpose and context

The Legacy Harness is primarily built from two runtime primitives: abilities and flow-based pipelines. Agent configuration also contributes important context, including business information and weekly availability or scheduling. Legacy ability and pipeline flows are rigid graphs whose nodes and edges describe questions, messages, actions, branches, calls, subflows, and terminal behavior.

The new Harness replaces abilities with Markdown skills, keeps pipelines as pipeline records but expresses their outreach behavior as a plain-language goal, and stores shared organization context in the organization memory file at /memories/org/AGENTS.md. The migration preserves the old records as read-only historical source data while helping the user decide how their behavior should be represented by the new primitives.

This is a collaborative translation workflow, not an automatic JSON converter. Read the legacy data, explain what it means, propose a concrete target structure or document, collect user feedback, and write only after explicit approval. Keep the user's decisions visible at each checkpoint and make each phase safe to resume or repeat.

Legacy flow actions are exposed through the internal Z360 action catalog as flag-gated read tools. Use the dedicated Z360 action group for these reads and for current action discovery; if its group_id is not already known, find it with search-action-groups before using search-actions or get-action-schema, and never guess or silently switch groups. Legacy ACT nodes refer directly to AiAction records, not necessarily to the current internal MCP action catalog. A legacy action ID therefore may not have an exact current tool. Use the safe description and parameter context returned by the reader to find the closest current catalog action, and use the current action's group, slug, and schema in any generated skill or goal.

## Invocation and rollout guard

Use this skill only after an explicit user request for Harness migration. Do not start it merely because the user asks about an old ability, a skill, a pipeline, agent configuration, or a general migration concept.

Before reading legacy data, verify that the organization is on the customer-facing-deep-agent rollout and that the four migration reads are available in the current Z360 action catalog: z360-read-get-legacy-agent-context, z360-read-search-legacy-abilities, z360-read-get-legacy-ability, and z360-read-get-legacy-pipeline-flow. If any required migration action is unavailable, stop and explain that Harness migration is not enabled for this organization. Do not call old HTTP routes, query legacy data through an unapproved path, or reconstruct the data from another source.

Read product-model and workspace-management before beginning. Explain the migration plan and checkpoints before starting a phase. Let the user choose the phases and their order: they may migrate context first, start with skills, migrate pipelines only, or stop after any approved phase. The default order is agent context, abilities, then pipelines, but the user's explicit choice controls the session.

## Migration phases and checkpoints

1. **Agent context:** Read the current organization memory and use get-legacy-agent-context to read the existing business details and availability. Propose a concrete patch under stable memory sections, obtain approval, write it with the cataloged filesystem tool, and read it back. Availability is recorded as context; agent_schedule remains the application's scheduling source of truth.

2. **Abilities to skills:** First inventory all active and inactive legacy abilities and perform a brief audit without fetching every full flow. Read Workspace Management's Skill Management guidance, propose a skill fleet with one skill per active ability by default plus any safe grouping, overlap, or reuse opportunities, and obtain architecture approval. Then process the approved set one ability at a time: fetch its flow, draft the complete skill and a short example behavior summary, gather feedback, obtain approval, write and verify it, and only then move to the next skill.

3. **Flow-based pipelines to goal-based pipelines:** There is no separate architecture stage because the pipeline record remains in place. Discover the selected pipelines and process them one at a time. Read Workspace Management's Pipeline Management guidance, compare the published and draft legacy flows and any current goal, propose the exact goal and a short example execution flow, obtain approval for that pipeline, update only communication.goal, read the result back, surface status and warnings, and render the existing pipeline card.

## Shared migration rules

Use the published legacy flow as runtime truth and expose drafts for comparison; never migrate a draft automatically. Preserve unrelated organization memory, existing skills, pipeline configuration, and all legacy database records. Express legacy node-level cadence in goal or skill prose rather than silently changing application scheduling. Do not write legacy action IDs, raw AiAction configuration, endpoints, headers, credentials, connected-account details, or unresolved placeholders into a new artifact.

Follow the original Workspace Management Skill Management and Pipeline Management instructions for authoring frontmatter, tool declarations, do blocks, references, pipeline goals, schemas, and cataloged writes. Immediately before each write, reread the current target and fetch the current schema needed for that write; if the source or target differs from the approved proposal, rebuild the proposal and ask for approval again. Read every successful write back and report what was verified.

This ticket covers the Harness migration workflow for text and voice abilities and pipelines. Do not perform an automatic unapproved bulk migration, add a migration-status table or database backfill, mutate or delete legacy records, or change pipeline schedule and channel configuration as an implicit part of migration.

## References

- [Agent context migration](references/agent-context-migration.md) covers business information and availability in /memories/org/AGENTS.md.
- [Ability-to-skill migration](references/ability-to-skill-migration.md) covers the skill-fleet checkpoint and one-by-one legacy ability conversion.
- [Legacy flow playbook](references/legacy-flow-playbook.md) explains the shared legacy graph vocabulary and action-mapping hazards.
- [Flow-based pipeline-to-goal migration](references/flow-based-pipeline-to-goal-migration.md) covers one-by-one pipeline goal reconciliation and goal-only updates.
