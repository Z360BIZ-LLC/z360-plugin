# Agent setup

Task ID: `agent_setup`

Read `../workspace-management/references/workspace-settings.md`. Use the Z360 action group and fetch a fresh schema before every action.

## Agent settings

Agent settings include the shared Agent name, Channel settings, and Voice settings.

### Shared agent details

The Agent name applies to both the Text Agent and Voice Agent.

### Channel settings

1. Call `z360-read-get-agent-config` and review the Agent name and the Email, SMS, and Live Chat defaults.
2. Explain that reasoning controls analysis depth and approval policy controls confirmation.
3. Confirm the preferred values, then call `z360-write-update-agent-config` with the complete payload and current values preserved.
4. Call `z360-read-get-agent-config` again and verify the saved settings.

### Voice settings

1. Call `z360-read-get-voice-config` and review the voice, personality, introduction, and language settings.
2. Confirm the preferred values, then call `z360-write-update-voice-config` with the complete payload and current values preserved.
3. Call `z360-read-get-voice-config` again and verify the saved Voice settings.
