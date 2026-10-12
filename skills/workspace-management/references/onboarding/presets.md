# Onboarding presets

Use this workflow after the first two organization tasks are complete and before Skills begins. A preset is an optional starting configuration that is seeded as one unit.

## Select and seed

1. Call `list_presets` without first asking the user to choose a preset. Compare the returned names and descriptions with the confirmed business type, customers, services, and goals. Never infer a preset from the organization name alone.
2. Offer only clearly relevant presets. If one clearly fits, offer it as an optional starting point. If several fit, present only their names and short descriptions. If the fit is ambiguous, ask one brief clarifying question. If none fit, continue onboarding without mentioning presets.
3. After the user selects a preset, call `list_preset` with its returned slug. Summarize the included pipelines, automations, skills, contact custom fields, and ticket types in plain language.
4. Explain that the resources will be created together and customized during their matching onboarding tasks. Obtain explicit confirmation before the organization-wide write.
5. Call `seed_preset` once with the confirmed slug. Do not seed its resources individually.
6. Report `created`, `skipped`, and `failed` resources separately. Existing resources reported as `skipped` are not failures; a failed resource does not roll back successful resources.

Seeding does not complete Skills, Pipelines, Automations, or Ticket Configuration. It creates their desired starting state before channels, phone numbers, triggers, tools, and integrations are necessarily available.

## Resume customization in a new thread

Preset selection is not stored in organization memory in this version. When the user asks to resume preset customization:

1. Call `list_presets`, then inspect the organization's existing skills, pipelines, automations, ticket types, and contact custom fields through their matching management references.
2. Use `list_preset` for plausible candidates and compare their expected resources with the existing resources. Infer a candidate only from a coherent multi-resource pattern. Do not infer a preset from one common resource.
3. Tell the user which preset appears to have been seeded and ask for brief confirmation. If no candidate is clear, ask which preset they previously selected.
4. After confirmation, continue with the matching resource guidelines. Do not call `seed_preset` solely because a preset was inferred.

## Customize a seeded resource

1. Call `list_preset` with the preset slug confirmed in the current conversation to resolve the resource type and ID.
2. Call `read_preset_resource_guidelines` for that resource immediately before reviewing it.
3. Inspect the saved resource and preserve existing customer changes. Do not assume channels, triggers, tools, phone numbers, or integrations are available.
4. Follow the matching management reference for approved changes and verification.
5. Mark the task done only when its relevant resources are configured and verified.
