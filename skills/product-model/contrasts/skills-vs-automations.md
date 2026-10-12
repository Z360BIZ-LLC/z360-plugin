# Skills vs automations

A **skill** is a reusable procedure that an agent follows when the task matches.

An **automation** is a saved trigger contract that starts the main agent on a schedule or application event without a new chat.

An automation's instructions can require the agent to read or follow one or more skills. That dependency is optional; an automation can also carry all of the instructions needed for its run.

## Boundary

A skill explains repeatable behavior; an automation determines when that behavior-like run begins. An automation may rely on instructions similar to a skill, but it is not a replacement for the skill's reusable playbook.

Related definition, only if needed: [automations](../references/automations.md). The operational skill-management workflow is separate.
