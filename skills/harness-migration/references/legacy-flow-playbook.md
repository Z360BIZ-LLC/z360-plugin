# Legacy flow playbook

Use this reference with the ability and pipeline migration procedures. It explains the legacy graph vocabulary and the information needed to translate behavior. Workspace Management's Skill Management and Pipeline Management references remain the authoritative guides for writing the new artifacts; this playbook does not replace or duplicate those authoring instructions.

## What a legacy flow represents

A legacy ability or pipeline flow is a directed graph. Nodes represent user or lead interactions, actions, decisions, nested procedures, calls, and terminal outcomes. Edges and branch labels determine which node runs next. A top-level flow may contain subflows, and a call node may contain a nested call flow. Read nested flows recursively and preserve their behavior rather than treating a subflow or call as an opaque label.

The published `flow` or latest published pipeline flow is the runtime source of truth. A draft flow is a separate proposal and must be surfaced for comparison, but it is never migrated automatically. Report meaningful published-versus-draft differences, missing graphs, unsupported nodes, missing action references, and unavailable actions before proposing a target artifact.

## Legacy primitives

| Primitive | Meaning during migration |
|---|---|
| `START` | Entry point for the graph and its incoming trigger or initial context. |
| `ASK` | A question to the lead or user; preserve the question, expected meaning, and the semantic context captured from the answer. |
| `SAY` / `SPEAK` | A conversational message or instruction that should be expressed in the new artifact's plain language. |
| `ACT` / `DO` | An executable legacy action with its intent and arguments. Resolve it against the current catalog rather than copying the legacy record. |
| `CONDITION` / `EVALUATE` | A decision with branch predicates and if / then / else behavior. Preserve the branch meaning and fallback path. |
| `SUBFLOW` | A nested reusable procedure. Inline it or use a one-level reference only when the target authoring guide permits it. |
| `CALL` | An outbound-call step and any call brief, call outcome, retry behavior, or nested call flow that controls it. Use current calling guidance for the target behavior. |
| `END` / `END_SCRIPT` | A terminal completion, stop, handoff, or other explicit end condition. |
| `CONTINUE` / `RETURN` | Control transfer that continues, returns from, or exits a nested procedure. Preserve the resulting control behavior in prose. |

Edges and branch metadata are part of the behavior, not incidental graph layout. A node's `save_as` names context for later nodes; translate it into a semantic fact or answer reference and never copy a legacy variable name as if it were a new platform contract. `follow_up_gap` and `max_followups` describe cadence and retry limits; express them as explicit prose or use supported wakeup behavior. Preserve registration requirements as prerequisites.

## Legacy actions and the current catalog

Legacy `ACT` nodes were backed by `AiAction` model records directly. They were not authored as references to the internal Z360 MCP action catalog, so a legacy action may be missing from the current catalog or may have no exact one-to-one replacement. This is expected migration context, not permission to invent a tool.

The legacy reader may return a legacy action ID or group ID together with safe descriptive metadata, safe parameter information, and a current `group_id` and `action_slug` when a visible current match exists. It may also report that an action is missing, inactive, unavailable to the organization, or otherwise unresolved. Use the legacy description and arguments to search the current action catalog for the closest current catalog action, then fetch that action's fresh schema before recording it in a skill or relying on it in a pipeline goal.

Generated skills and goals must contain only current catalog references and supported parameters. Never copy legacy IDs, raw action configuration, endpoints, headers, credentials, connected-account details, or secrets into a new artifact. If the action intent, parameters, node type, branch, or call behavior cannot be mapped safely, report the migration gap and do not write a broken skill or unresolved placeholder.

## Translation principles

Translate the graph's observable behavior into clear instructions rather than reproducing its JSON or node-by-node syntax. Preserve triggers, questions, messages, action intent and outcomes, branch conditions, nested behavior, cadence, call behavior, registration prerequisites, completion criteria, and human handoffs. Use the published graph for the proposed behavior and use the draft only to explain what would differ.

For ability migration, the target is an organization skill and its current catalog tools. For pipeline migration, the target is the existing pipeline's plain-language communication goal; pipeline identity, intake, stages, sources, channels, branding, schedule, configuration, and outreach state remain existing product configuration unless the user separately requests and approves a change.
