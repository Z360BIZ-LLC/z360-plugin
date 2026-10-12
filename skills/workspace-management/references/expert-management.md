---
name: expert-management
description: Create, inspect, update, and organize Z360 Experts—the focused subagent profiles that have their own instructions, reasoning mode, action-group access, and optional expert-owned skills. Read this reference when the user wants to define or manage a specialized agent profile in AI Studio.
---

# Expert management

Read `../product-model/references/experts.md` for the product definition of an Expert and `../product-model/contrasts/skills-vs-automations.md` when the requested behavior might be a skill or automation instead. Use the authenticated Z360 action catalog as the source of truth for Expert records, selectable options, action groups, and schemas. This reference covers the management workflow and tool-specific details; it does not redefine the product model.

## Interview before creating an Expert

Before writing an Expert, make sure the user understands that it is a focused subagent profile rather than a label, a tool bundle, or a single saved instruction. Ask enough questions to establish:

1. The responsibility, desired outcome, and examples of work that belongs to the Expert.
2. What should not trigger it and what work should remain with the root or another profile.
3. The inputs it needs, the output it should return, and how the root should use that output.
4. The records, connections, and action groups it genuinely needs.
5. The desired reasoning mode, visibility or ownership, active state, and important constraints.
6. Whether a reusable skill would solve the request more simply than a new subagent profile.

Play the proposed profile back in plain language. If the user is asking for a repeatable procedure rather than a distinct responsibility, recommend `skill-management`. If the user still wants an Expert, get explicit confirmation of the name, description, instructions, reasoning mode, ownership, and action-group access before creating it.

## Draft the profile

Write instructions around the mission, successful outcome, scope, expected inputs, decisions, output contract, and escalation conditions. Keep universal runtime rules in the root prompt, put long reusable procedures in skills or references, and use the Expert instructions for the stable responsibility that makes the profile worth invoking.

Use the fresh schema for field names and valid values. Keep the name and description specific enough to route work, use a reasoning option returned by `get-expert-options`, keep active and ownership changes explicit, and use one actual emoji character when setting an icon. When the current schema names the instruction field `system_prompt`, treat it as the Expert's instruction contract rather than copying the root prompt.

Keep the allowed action-group list narrow. Include only the connection-specific groups required for the responsibility, and do not assume that a broad group makes every workflow part of the Expert's scope. Keep organization-wide or user-private procedures in their corresponding skill scopes unless they are intentionally part of this profile.

## Create an Expert

1. Search existing Experts when the user has not established that a new profile is needed; avoid duplicate responsibilities and names.
2. Call `get-expert-options` for valid reasoning, ownership, and other selectable settings.
3. Call `search-action-groups` for each requested connection and resolve the exact `allowed_action_group_ids`.
4. Summarize the proposed profile, boundary, skills, and access. Get confirmation.
5. Call `create-expert` using the confirmed values and the tool's current schema.
6. Report the created Expert, its ownership, reasoning mode, and configured action-group access. Do not claim it is available until the action confirms creation.

## Update an Expert

1. Call `search-experts` to find the Expert if the user did not provide its id.
2. Call `get-expert` for current details before changing it.
3. Clarify only the requested changes and check that they do not silently change the Expert's responsibility or ownership boundary.
4. Use `get-expert-options` or `search-action-groups` for any changed settings or access groups.
5. Summarize the exact before-and-after changes and get confirmation.
6. Call `update-expert` using the confirmed values and the tool's schema.
7. Report the updated Expert and the changed areas.

## Inspect an Expert

Use `search-experts` for discovery and `get-expert` for full details. Explain the profile from those results without making changes. When reviewing an Expert for a new request, compare its responsibility, instructions, reasoning mode, action-group allowlist, and owned skills with the requested work before recommending an update or a new profile.

## Manage Expert-owned skills

An Expert may have additional skills that belong only to that profile. These are not organization skills or user skills. When the active Expert or subagent surface exposes expert-scoped resources, confirm the target Expert, read `skill-management`, list the existing files under `/skills/experts/<expert-runtime-id>/`, and choose a unique skill name. Create the entry point at `/skills/experts/<expert-runtime-id>/<skill-name>/SKILL.md`; do not place it under `/skills/org/` or `/skills/user/`, and do not overwrite an existing skill unless that update is intentional and confirmed. The current text root does not enumerate the expert route, so never claim an expert-owned skill is active until the corresponding runtime confirms that it can read and use the file.

`<expert-runtime-id>` is the string `runtime_id` returned by `search-experts` or `get-expert`, not the numeric database `id` those same tools return. Resolve the target Expert first and use its `runtime_id` verbatim; the numeric `id` must never appear in an expert skill path. For an Expert with `id: 563` and `runtime_id: test_subagent`, the path is `/skills/experts/test_subagent/<skill-name>/SKILL.md`, not `/skills/experts/563/<skill-name>/SKILL.md`. When verifying the write, confirm that the segment after `/skills/experts/` equals that Expert's `runtime_id`.

Keep an Expert-owned skill focused on a procedure that supports the Expert's responsibility. Use progressive disclosure, exact action schemas, `do` blocks, explicit failure paths, and read-back verification as described by `skill-management`. The skill adds guidance when the Expert uses it; it does not replace the Expert's instructions, action-group allowlist, or root harness protocol. Report the Expert owner and saved path only after the filesystem write and read-back succeed.

## Safety rules

Never invent Expert ids, action-group ids, schema fields, enum values, or connection ownership. Read current details before updates, confirm externally visible or destructive changes, keep credentials out of prompts and skill files, and report only outcomes confirmed by the action result. Do not broaden an Expert's responsibility or access as an incidental side effect of another change.
