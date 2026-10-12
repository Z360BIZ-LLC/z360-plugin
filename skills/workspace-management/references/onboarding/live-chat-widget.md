# Live chat widget

Task ID: `live_chat_widget`

Read the live chat widget section of `../workspace-management/references/workspace-settings.md`. Use the Z360 action group and fetch a fresh schema before every action.

1. Call `z360-read-get-live-chat-settings` and render `live_chat_widget` so the user sees the current widget.
2. Ask which content, appearance, and conversation settings the user wants to change.
3. Confirm the values, then call `z360-write-update-live-chat-settings`.
4. Call `z360-read-get-live-chat-settings` again, verify the saved settings, and render `live_chat_widget` for review.
5. Installing the widget on a website is a separate step. The embed code is on the Live Chat settings page, which the rendered card links to. Tell the user where to copy it and never invent embed code. Distinguish saved configuration from installation.
