---
name: workspace-management
description: Manage a Z360 organization's workspace, records, configuration, navigation links, experts, automations, reusable skills, and sandbox file-processing workflows, including onboarding, teams, knowledge, phone and messaging readiness, pipelines, contacts, leads, and application settings. Use when the user wants to configure the organization's operating workspace, navigate in Z360, process workspace files, run sandbox commands, or save a repeatable workspace procedure.
---

# Workspace Management

Read the `product-model` skill before interpreting Z360 records, relationships, or terminology. It explains how an organization, users, contacts, conversations, leads, tickets, notes, reminders, pipelines, and action groups fit together. Then use the Z360 action catalog and read the matching reference before acting.

## Organization and workspace context

A Z360 organization is the business workspace represented by the current tenant. It contains the organization's users and operating configuration, its customer-facing contact and conversation records, business records such as leads, tickets, notes, reminders, and pipelines, and the connections that expose tools through action groups. Workspace changes affect that organization; do not assume that a record, connection, identifier, or setting belongs to another organization, and never cross tenant boundaries.

The current user is an employee or collaborator operating that organization's workspace. Treat organization-level changes as shared changes, distinguish them from user-private resources, and keep the user informed about the exact record or setting being changed.

## App navigation

When the user asks for a Z360 link, to open a page or record, or where to go in the app, call `get-navigable-routes`. Use only URLs returned by that tool/actions.

- For a specific record, replace an ID placeholder only with an ID returned by a search or get tool/actions. Do not guess IDs, URLs, query parameters, route segments, or editor tabs.
- If the requested record is not yet identified, use the relevant read tool/actions to find it before building a link.
- If no returned URL provides the requested direct link, say that it is unavailable and offer the closest returned page when useful.
- Return templates with their placeholders unchanged only when the user asks for the available URL structure; otherwise return a completed URL.

## Use the Z360 action group

Most workspace and record operations are provided by the dedicated Z360 action group. If its `group_id` is not already known in the current context, find it with `search-action-groups` before discovering actions. Use the returned group for `search-actions`, `get-action-schema`, and `execute-action` throughout the task. An action group represents a particular authenticated connection, so do not guess a group id, silently switch to another connection, or treat similarly named groups as interchangeable.

## Choose the matching procedure

Read only the reference that matches the requested work. Each reference contains the detailed discovery, schema, confirmation, and failure rules for its area; follow that reference after this overview rather than recreating its workflow from memory.

### Onboarding and initial setup

Read `../workspace-management/references/onboarding.md` when the organization is being configured for the first time, the user asks to start or resume onboarding, requests a specific onboarding task, or asks for a readiness review. Follow that reference for persisted progress, task routing, preset setup, and task-specific configuration.

### Skill management

Read `../workspace-management/references/skill-management.md` when the user wants to create, inspect, revise, organize, or delete a reusable skill. Use it to choose organization, user, or expert ownership, interview for the trigger and success criteria, resolve every referenced action, write a progressive-disclosure entry point, and verify the saved files. A repeatable procedure belongs in a skill; do not turn a one-off request into a permanent workspace resource without the user's intent.

### Automation management

Read `../workspace-management/references/automation-management.md` when the user wants to create, inspect, run, pause, update, or delete an AI Studio automation, or when they want repeatable work to start on a schedule or an application event. Use its lifecycle, trigger discovery, schedule, ownership, approval, confirmation, and read-back rules. Do not use an automation for a one-time action, a reminder, a wakeup, or a reusable procedure that belongs in a skill.

### App integration management

Read `../workspace-management/references/app-connection-management.md` when the user wants to discover app integrations and their actions or triggers, connect an app for tools, triggers, automations, or Expert actions, use a custom API/MCP builder, or remove a configured app. Use it to distinguish catalog integration IDs from configured group IDs, discover authentication requirements, open setup UI, and resolve the correct removal target.

### Email account connections

Read `../workspace-management/references/email-account-management.md` when the user wants to connect Gmail or Outlook for inbox, sending, receiving, conversations, shared mailboxes, or email collections. Use its provider and collection identifiers with the mail UI, and distinguish email accounts from app integrations when intent is unclear.

### Workspace settings

Read `../workspace-management/references/workspace-settings.md` when the user wants to inspect or change organization-level or current-user settings, including account, notification, team, channel, product, compliance, billing, or AI Studio agent settings. Use it to distinguish settings from records, automations, skills, experts, and pipelines, identify the narrowest settings tool, inspect current configuration, confirm shared or external effects, and read back the result.

### Pipeline configuration

Read `../workspace-management/references/pipeline-management.md` when the user wants to create or revise pipelines, stages, lead goals, cadence, or other lifecycle configuration. Use the reference's discovery and confirmation flow because pipeline changes define what happens to future leads and can affect outbound work across the organization.

### Knowledge base management

Read `../workspace-management/references/knowledgebase-management.md` when the user wants to create, inspect, revise, organize, import website or supplied content into, delete, move, or sync knowledge base folders or documents. Use it during onboarding or for direct user requests, with source review, a user-approved structure, detailed documents, and verified sync.

### Expert management

Read `../workspace-management/references/expert-management.md` when the user wants to create, inspect, update, activate, or otherwise manage an AI Studio Expert. Use it to determine whether an expert profile is actually the right primitive, define its focused subagent responsibility, configure its instructions, reasoning mode, action-group access, and expert-owned skills, and confirm the exact application record before writing it.

### Sandbox execution and file processing

Read `../workspace-management/references/sandbox-workspace.md` when the user needs to run scripts, shell commands, queries, or file-processing work in the thread-scoped sandbox. Use it to choose `sandbox_execute`, `sandbox_upload`, and `sandbox_download` correctly and to preserve final outputs in `/artifacts/`.

### Messaging compliance

Read `../workspace-management/references/a2p-10dlc.md` for A2P 10DLC, SMS registration, campaign information, messaging compliance, or phone-number readiness. Follow its exact data requirements and validation steps; do not invent registration values or claim compliance until the action results confirm it.

### Contact context, history, and customer dossier

Read `../workspace-management/references/contact-audit.md` when the user needs contact background, a complete contact history, a record audit, or a customer dossier. Use it to gather related conversations and business records without editing them, distinguish missing data from a negative finding, and report the evidence clearly.

### Lead lifecycle

Read `../workspace-management/references/lead-management.md` when the user wants to create, update, assign, inspect, or advance a lead. Follow its rules for resolving the person and pipeline, preserving lifecycle state, handling ambiguity, and confirming consequential changes.

## Shared execution rules

Discover actions and read their schemas before writing. Prefer the narrowest read needed to establish context, then make the smallest requested change. Ask focused questions when the organization, record, connection, ownership, or desired outcome is ambiguous. Confirm consequential or externally visible changes when the matching reference requires it. Use only fields and enum values returned by the schema, never invent identifiers, and report the exact records and outcomes returned by the tools. Never expose credentials or treat a successful tool call as proof of a broader outcome than it actually confirms.
