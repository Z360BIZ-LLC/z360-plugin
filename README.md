# Z360 plugin

Connect your AI app to [Z360](https://z360.biz) and work with your organization's contacts, conversations, tickets and inquiries in plain language.

## What it includes

- **Z360 MCP server** (`https://beta.z360.biz/mcp`): a remote server that lets the AI app search and run Z360 actions. You sign in with your Z360 account (OAuth) and pick one organization. The AI app only gets the actions your Z360 role allows.
- **`z360` skill**: tells the model how to find the right action, read its schema, and ask you before running anything that creates, changes, sends or deletes data.

## Setup

1. Install the plugin.
2. When the AI app asks, sign in with your Z360 account and choose an organization.
3. Ask things like "find the contact John Smith" or "show my open tickets".

To disconnect, open Z360 → Settings → MCP Connections and revoke the connection.

## Data and privacy

The plugin sends your requests and the tool results only between your AI app and Z360 (`beta.z360.biz`). It runs no local code and sends data nowhere else. See the [Z360 privacy policy](https://z360.biz/privacy-policy) and [terms](https://z360.biz/terms).

## Support

Contact Z360 support through [z360.biz](https://z360.biz).
