---
name: onboarding
description: Use when a customer starts, resumes, or reviews Z360 onboarding, including work on a specific onboarding task.
---

# Z360 onboarding

Use the Z360 action catalog. Onboarding may continue across threads, so use persisted task status and `/memories/org/AGENTS.md` as the source of truth.

## Task lifecycle

Follow this sequence for every onboarding task:

1. Call `list-onboarding-steps` before describing progress.
2. If `onboarding_complete` is true, exit the onboarding flow and handle future requests through the matching management workflow without changing onboarding statuses.
3. Select the task requested by the user when it is visible and incomplete. Otherwise, select the first visible `in_progress` task, or the first visible `todo` task when none is in progress.
4. Before starting the selected task, follow any prerequisite in Shared organization context below. This includes running the preset selection workflow before `skills`.
5. When a selected `todo` task actually starts, call `update-onboarding-step` with `in_progress`. If it is already `in_progress`, resume it without changing its status.
6. Read only the selected task's linked reference below and follow its workflow.
7. Leave partial or blocked work as `in_progress`. Leave declined or unstarted work as `todo`.
8. Verify the result with a read-back or equivalent evidence. Only after verification, call `update-onboarding-step` with `done`.
9. Call `list-onboarding-steps` again, state what was completed, and continue or offer the next visible incomplete task by repeating this sequence.

Use only `todo`, `in_progress`, and `done`. Work only with tasks returned by `list-onboarding-steps`, and report status-tool errors instead of claiming that a status changed. When the user pauses, summarize the latest persisted statuses and any blocker discussed in the conversation.

## Shared organization context

Read existing `/memories/org/AGENTS.md` before asking for business information. Store confirmed reusable facts there without duplicating uncertain or temporary details.

After `business_profile_ai_basics` and `knowledge_base` are `done`, and before starting `skills`, read [Onboarding presets](onboarding/presets.md) and run its selection workflow. A preset seeds the complete organization starting configuration once; the later Skills, Pipelines, Automations, and Ticket Configuration tasks customize and verify the relevant seeded resources. Seeding alone does not complete those tasks.

For each seeded resource handled by a later task, follow [Customize a seeded resource](onboarding/presets.md#customize-a-seeded-resource) and call `read_preset_resource_guidelines` immediately before reviewing and customizing that resource.

## Organization task references

Read only the reference for the selected task:

1. `business_profile_ai_basics`: [Business profile and AI basics](onboarding/business-profile-ai-basics.md)
2. `knowledge_base`: [Knowledge base](onboarding/knowledge-base.md)
3. `skills`: [Skills](onboarding/skills.md)
4. `pipelines`: [Pipelines](onboarding/pipelines.md)
5. `automations`: [Automations](onboarding/automations.md)
6. `agent_setup`: [Agent setup](onboarding/agent-setup.md)
7. `ticket_configuration`: [Ticket configuration](onboarding/ticket-configuration.md)
8. `authenticated_email`: [Authenticated email](onboarding/authenticated-email.md)
9. `phone_number`: [Phone number](onboarding/phone-number.md)
10. `ten_dlc_registration`: [10DLC registration](onboarding/ten-dlc-registration.md)
11. `team_members`: [Team members](onboarding/team-members.md)
12. `live_chat_widget`: [Live chat widget](onboarding/live-chat-widget.md)
13. `test_completed_setup`: [Test completed setup](onboarding/test-completed-setup.md)

## Guardrails

- Use read tools before write tools and never guess IDs.
- Discover unfamiliar actions and read their schemas before writes.
- Ask only for information required by the current action or requested outcome. If the user defers other settings, leave them unchanged and continue.
- Ask before external messages, invitations, purchases, fee-bearing submissions, or other consequential writes.
- Never claim success without verification or mark skipped work done.
