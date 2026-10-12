# Integrations

An integration represents an external application or provider that Z360 can connect to. It describes the application-level connection surface and the capabilities or event types that provider can expose.

An organization or user can have a connected account for an integration. That connection carries the account, tenant, authentication, and availability context for using the provider. The same integration can therefore have more than one connection with different ownership or account boundaries.

An action group is the connection-specific capability boundary associated with one connection. It may be linked to an integration, but it is not the integration definition itself. The integration answers “which application or provider is this?”; the action group answers “which connected capability scope is available here?”.

An integration can expose event triggers as well as callable capabilities. A trigger belongs to a connected provider context and can be used by product features such as automations. Provider availability, account ownership, and connection status are part of the integration relationship, not properties of a customer contact or conversation.

Related contrast: [integrations vs action groups](../contrasts/integrations-vs-action-groups.md).
