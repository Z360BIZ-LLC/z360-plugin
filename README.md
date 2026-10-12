# Z360 plugin

Connect your AI app to [Z360](https://z360.biz) and work with your organization's contacts, conversations, tickets and inquiries in plain language.

## What it includes

- **Z360 MCP server** (`https://beta.z360.biz/mcp`): a remote server that lets the AI app search and run Z360 actions. You sign in with your Z360 account (OAuth) and pick one organization. The AI app only gets the actions your Z360 role allows.
- **Skills** that teach the model how Z360 works and how to use its actions:
  - `product-model`: Z360's records, relationships and terms, such as contacts, conversations, tickets, inquiries and pipelines.
  - `customer-communication`: customer conversations, messages, follow-ups, lead playbooks and calls.
  - `harness-migration`: move an organization's legacy abilities and flow-based pipelines to skills and goals. Used only when the user asks for a Harness migration.
  - `workspace-management`: organization setup and settings, onboarding, team members, knowledge base, experts, automations, pipelines, phone and messaging readiness.

## Setup

1. Install the plugin.
2. When the AI app asks, sign in with your Z360 account and choose an organization.
3. Ask things like "find the contact John Smith" or "show my open tickets".

To disconnect, open Z360 → Settings → MCP Connections and revoke the connection.

## Data and privacy

The plugin sends your requests and the tool results only between your AI app and Z360 (`beta.z360.biz`). It runs no local code and sends data nowhere else. See the [Z360 privacy policy](https://z360.biz/privacy-policy) and [terms](https://z360.biz/terms).

## Maintenance

The skills come from the Z360 text agent. To update them, run `scripts/sync-skills.sh` with the path to the agent-layer repository. The script is for maintainers only; the plugin never runs it.

## Support

Contact Z360 support through [z360.biz](https://z360.biz).
