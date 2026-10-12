# Phase 1: agent context migration

Migrate business context into the organization memory file, not into agent configuration. The application remains the source of truth for scheduling; the memory copy gives the new Harness useful business context.

## Read current state

1. Read ../product-model/SKILL.md and ../workspace-management/SKILL.md before interpreting Z360 records or using cataloged filesystem tools.
2. Read /memories/org/AGENTS.md. If it is missing, treat the current memory as empty; otherwise preserve all unrelated sections and wording.
3. Resolve the current Z360 action group and call get-action-schema for z360-read-get-legacy-agent-context immediately before execution, then execute it once. It returns `business_details` and `availability` and accepts no input.
4. If the action is not in the current catalog, stop and report the migration gap.

The result may contain defaults. Distinguish configured non-empty facts from empty or default values instead of writing a claim that the business did not provide.

## Build the proposal

Propose a concrete patch with non-empty business facts from `business_details` and the weekly schedule from `availability`. Use stable headings such as:

```markdown
## Business information

- Business name: <value>
- Business type: <value>
- Website: <value>
- Address: <value>
- Business description: <value>
- Contact email: <value>
- Contact phone: <value>
- Year established: <value>

## Availability

- Timezone: <IANA timezone>
- Monday: <start>-<end>; <additional windows if present>
- Tuesday: <closed or windows>
```

Include only fields with useful values and the days or windows supplied by the configuration. Keep existing unrelated sections unchanged. Do not copy any of these fields into memory:

- agent_name
- agent_introduction_instructions
- ai_data_consent
- templates_seeded_industry
- voice, personality, language, or other personalization settings

Do not make an agent_schedule or any other configuration write. Record availability as context only. If no meaningful business facts or weekly windows exist, report that there is nothing useful to migrate and ask whether the user wants to supply the missing context.

Show the exact proposed memory patch, explain which existing sections are preserved, and ask for explicit approval. Approval must cover the exact file and the Business information and Availability sections being changed.

## Write and verify

After approval, reread /memories/org/AGENTS.md once more. Rebase the patch on that latest content so a concurrent edit cannot erase newer memory.

- If the file does not exist, use write_file for /memories/org/AGENTS.md.
- If it exists, use edit_file and replace only the stable Business information and Availability sections. Do not append duplicate sections.

Read the file back after the write. Verify that the approved non-empty facts and availability are present, unrelated memory remains, excluded fields are absent, and agent_schedule was not changed. If read-back differs, report the mismatch instead of claiming completion.
