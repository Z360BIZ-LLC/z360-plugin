# Phase 3: flow-based pipeline to goal-based pipeline migration

Use this phase for existing pipelines whose legacy outreach behavior is encoded as a flow. There is no skill-fleet or pipeline architecture checkpoint: the pipeline record remains the target primitive, and migration changes only its plain-language communication goal. Read the common [Legacy flow playbook](legacy-flow-playbook.md) for graph vocabulary and read Workspace Management's [Pipeline Management guidance](../workspace-management/references/pipeline-management.md) before authoring or updating a goal.

## Select and inspect one pipeline

Process one selected pipeline at a time. Discover active pipelines by default; skip inactive pipelines unless the user explicitly selects them. A clearly enumerated batch approval is allowed, but each pipeline still needs its own current read, proposal, approval, write, and verification.

1. Resolve and fetch fresh schemas for search-inquiry-pipelines and get-inquiry-pipeline. Use them to discover the selected pipeline and establish the current name, description, intake form, stages, sources, channels, branding, configuration, schedule, outreach_enabled state, and current communication goal.
2. Fetch the fresh schema for z360-read-get-legacy-pipeline-flow and execute it for the selected pipeline. Read its published flow as runtime truth, surface the draft flow for comparison, and report missing graphs, default-only graphs, unsupported nodes, action gaps, and other warnings. Interpret the graph with the Legacy flow playbook.
3. If the published legacy flow is missing or is only the default START-to-END graph with no meaningful behavior, report a no-op. Do not infer behavior, manufacture a goal, or write an empty replacement.
4. If a current goal already exists, present a reconciliation that explains what the published legacy flow says, what the current goal already covers, and what would be added, changed, or intentionally retained. Never overwrite an existing goal silently.

Do not create a separate architecture plan for pipelines. After one pipeline's proposal is approved and verified, continue to the next explicitly selected pipeline.

## Draft and review the goal

Write one exact plain-language communication goal for the selected pipeline. Cover the entry trigger and target lead context, initial outreach, channels and message intent, follow-up intervals and retry limits, reply, no-reply, unreachable, and incomplete-information branches, stage transitions and their evidence, stop conditions and human handoff, call briefs and call-specific retries and outcomes, and the final stage with Secured completion behavior.

Use the published flow as the default source and explain meaningful draft differences without migrating draft-only behavior automatically. Translate node-level delays and follow-up settings into goal prose. Treat a pipeline-level schedule override as existing product configuration: do not copy node delays into its schedule object, and do not change schedule, channels, branding, intake, stages, sources, or other configuration as an implicit part of goal migration. Propose and confirm those changes separately only when the user asks for them.

Read the Pipeline Management guidance for goal-writing conventions, supported action references, schema handling, confirmation, and rendering. Do not duplicate its general pipeline-authoring instructions here; this reference adds the legacy-flow interpretation and migration boundaries.

Show the exact proposed goal, the current goal reconciliation, the source-flow warnings, and a short example execution flow, such as:

```text
entry trigger -> initial outreach -> reply/no-reply branch -> stage evidence
-> scheduled follow-up -> human handoff or final stage + Secured
```

Ask for explicit approval for this pipeline's exact goal. Batch approval is valid only when the pipeline IDs and each exact proposed goal are enumerated. If the user gives feedback, revise the proposal and request approval again.

## Write only the approved goal

Immediately before writing, reread the current pipeline and fetch the current schema for z360-write-update-inquiry-pipeline. Confirm that the schema supports communication.goal and that the current record still matches the approved reconciliation. If the source, current goal, or schema differs, stop and present an updated proposal for approval.

Send only the supported nested change:

```json
{
  "pipeline_id": "<current pipeline id>",
  "changes": {
    "communication": {
      "goal": "<approved exact goal>"
    }
  }
}
```

Do not send flow, subflows, ai_flow, or draft_ai_flow. Preserve the current pipeline name, description, intake form, stages, sources, channels, branding, configuration, schedule, and outreach_enabled state by omitting them from the goal-only update. If the current schema does not expose communication.goal, stop and explain the schema migration gap instead of using a legacy route.

## Verify, report, and render

Inspect the returned inner action response after the write. Surface the returned ai_status and every warning, including warnings that do not prevent a write. If the response reports a failure or a warning that requires user action, report it and do not claim that migration is complete.

Re-fetch the pipeline and verify that the approved goal persisted while the preserved configuration remains unchanged. Then call the existing render-ui tool for the pipeline card with the current pipeline ID and report the card and final status. A failed goal write leaves legacy data untouched; explain the next safe action and do not proceed as though the pipeline was migrated.
