# Experts

An Expert is a reusable, focused AI Studio subagent profile and application record. It gives a bounded responsibility a stable identity, routing description, instructions, reasoning configuration, access boundary, ownership, and availability state.

The root harness owns the conversation and the user-facing protocol. An Expert contributes within the responsibility it owns; it does not become a second conversation, replace the root harness, or redefine universal runtime behavior.

An Expert is also an application record: managing one changes the organization's available subagent profiles, not the root harness or the current conversation.

An Expert profile can include a name, description, instructions, reasoning mode, action-group access, ownership, active state, and icon. These fields describe the profile's responsibility and boundaries. The action-group relationship describes what connection-specific capability scope the profile may use; it does not make the Expert an integration or an action group.

An Expert and a skill are different concepts. An Expert is a focused subagent identity with its own responsibility and access boundary. A skill is a reusable procedure or playbook that an agent can follow. A procedure that does not need a distinct subagent profile belongs in a skill rather than an Expert. One Expert should own one coherent responsibility; unrelated responsibilities belong in separate profiles.

An Expert can access the organization and user skills available to the main harness, plus skills scoped to that Expert. Its effective skill set is therefore a superset of the main harness's organization and user skills, subject to the runtime's scope and availability rules.

Expert-owned skills remain subordinate to the Expert's responsibility. Organization and user skills, the root harness, and customer records remain separate ownership surfaces. The action-group boundary is separate from the skill set; see [integrations vs action groups](../contrasts/integrations-vs-action-groups.md) for that distinction.
