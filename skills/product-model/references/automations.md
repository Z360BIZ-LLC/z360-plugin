# Automations

An automation is a saved rule that starts the main agent when a schedule or application event occurs. It runs asynchronously without a person starting a new chat at the moment of execution.

An automation stores the behavior and execution context needed for repeated runs, including a title, instructions, ownership, active state, approval policy, reasoning mode, and either a schedule or an event trigger. A scheduled automation is time-driven; an event automation is started by an event from Z360 or a connected application.

The automation is the recurring trigger contract, not the procedure itself. A skill is a reusable procedure an agent follows, while an automation decides when that procedure-like behavior should be initiated. The automation may be paused, resumed, replaced, or retired as a product object.

An event automation has a provider and connection context for its trigger. The trigger action group identifies the event source and connected account, but it does not expand the main agent's action permissions or grant it a new identity. See [integrations vs action groups](../contrasts/integrations-vs-action-groups.md) for the provider boundary.

At runtime, a scheduled run receives the automation instructions. An event-driven run receives the trigger name and event payload before those instructions. The available payload fields depend on the selected trigger.

An automation run acts with the main agent's available organization and user capabilities. Its instructions and the current permission context determine whether the run can inspect or change records, communicate with customers, or invoke connected capabilities; the event trigger does not add permissions.

Ownership and policy are part of the automation's behavior. Organization-owned automations represent shared workspace behavior; private automations belong to one user. Approval and reasoning settings describe how an unattended run should operate, and active state determines whether future runs can start.

Related contrasts: [skills vs automations](../contrasts/skills-vs-automations.md), [automations vs reminders](../contrasts/automations-vs-reminders.md), and [integrations vs action groups](../contrasts/integrations-vs-action-groups.md).
