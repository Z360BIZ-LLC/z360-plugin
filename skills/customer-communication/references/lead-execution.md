---
name: lead-execution
description: Execute the outbound cadence of a lead pipeline whenever a lead is active, is about to start, receives a reply, or reaches a scheduled wakeup. Always read this reference before taking action on an active lead so the pipeline goal, current lifecycle, follow-up cadence, and lead status are respected.
---

# Lead Execution

Use this reference whenever the current conversation is attached to a lead that is being executed or is about to begin execution. It explains how to continue a pipeline from current evidence without restarting, skipping, or inventing steps.

Read `../product-model/references/inquiries.md` for the inquiry or lead record and `../product-model/references/pipelines.md` for stage and status meanings. This reference adds execution rules; it does not redefine those objects.

The pipeline `goal` is the playbook for that cadence, including its objective, messages or business actions, stage movement, follow-up timing, stop conditions, and success criteria. This skill explains how to determine where execution currently stands and continue the goal without restarting, skipping, or inventing steps.

## Actions

Commonly needed here: get conversation context, get active lead, search messages, send conversation message, update the lead, set wakeup, search knowledge base, and—when the goal calls for it—place an outbound call. This list is indicative, not exhaustive; discover anything else through the authenticated action catalog.

## Lead status guardrails

Read the lead's status with its stage and conversation evidence. The product-model pipeline reference defines the status meanings. Execute only an `Active` lead. Z360 permits only one active lead per conversation, so do not execute an `Idle` lead as though it were active. Treat `Secured`, `Dropped`, and `Declined` as terminal unless the goal, evidence, and action schema support an explicit transition.

When the pipeline goal is complete, update the lead's stage as the goal specifies and set its status to `Secured`. When the goal or the contact's response establishes a different terminal outcome, set the corresponding stage and status (`Dropped` or `Declined`) only when the evidence and action schema support it. Do not change status merely because a stage label looks stale.

## Establish the execution context

The first job is to understand the lead's current pipeline and actual conversation state before sending or changing anything:

1. Identify the active lead attached to the current conversation and read its current details. As soon as the lead is identified, immediately find and inspect the pipeline it belongs to; do not begin customer-facing work before this.
2. Read the pipeline's stages and complete `goal`; expect the goal to contain the instructions for the entire lead lifecycle.
3. Establish the conversation you are handling and inspect the relevant recent messages, notes, reminders, and other context available for that lead. Pay particular attention to conversation activity after the lead was created because some part of the goal may already have been executed or may be waiting for a response.
4. Compare the pipeline goal, the pipeline stages, the lead's recorded stage/status, and the conversation evidence. Treat the recorded stage as a hint, not conclusive proof; infer the actual lifecycle position from what happened in the conversation.
5. Decide whether the lead is just starting, already in a particular phase, waiting for a response, terminal, or blocked by missing information. Continue the goal from that point onward rather than replaying completed outreach.

If the lead, pipeline, stage, conversation, or goal cannot be resolved, do not invent a value or begin outreach. Gather the missing context through the action catalog or ask the user when the business decision is unavailable from Z360.

## Execute the next part of the goal

Once the current lifecycle position is clear, follow the pipeline goal from there:

If a new inbound contact message triggered this run, continue the pipeline goal with the Inbox surface's response requirement still in force. A goal with no new business step is not, by itself, a reason to remain silent.

- Send the next customer-facing message or perform the next business action the goal calls for.
- Use knowledge-base actions when the lead asks about business facts, services, pricing, policy, availability, process, or anything the goal and conversation context do not answer.
- Update the lead's stage or status when the goal's evidence threshold is met. Preserve the existing state when no transition is justified.
- When the goal requires a human, follow the stated escalation path and update the stage/status or assignment the goal specifies.
- Keep one coherent execution objective for the turn and do not send duplicate outreach for a step that the conversation already proves is complete.

Treat the pipeline `goal` as the source of strategy. The conversation and lead records tell you what has already happened; the goal tells you what should happen next and what outcome completes the cadence.

Use action names and slugs from the goal when they are already provided and current. Otherwise, discover the capability through the authenticated action catalog and read its current schema before executing it. Use exact returned identifiers and report only outcomes the action confirms.

## Follow-up cadence and wakeups

When the goal requires a future follow-up with this conversation, set a wakeup for the next cadence point using the timing, attempt limit, and stop condition defined by the goal. A wakeup is the right mechanism when the agent can continue without waiting for another person or external system: it resumes this thread so the lead's cadence can continue from the same context.

After a wakeup fires, inspect new conversation activity and the lead's current state before continuing. If the contact replied, a user intervened, the lead became terminal, or another external event changed the situation, adapt to that evidence instead of blindly sending the scheduled message. Keep each wakeup's purpose singular: resume this lead and continue the pipeline goal from its current point. If the wakeup was replaced or cleared by another event, set a new one whenever the goal still requires a future follow-up. Never create an unbounded wakeup loop; stop when the goal's attempts or terminal conditions say to stop.

## Outbound calls

When the goal reaches a step that phones the lead, read `../customer-communication/references/outbound-calling.md` first and follow it—it covers placing the call, waiting for it to finish, and reading the outcome. Use the call brief the pipeline goal already carries as that call's goal; do not invent one, and do not ask the user for details the goal should have supplied. Never place a call the goal did not ask for, and never on an email pipeline.

## Escalating to a human

When the goal or lead asks for a human, send a short escalation message when appropriate, then update the lead's stage, status, or assignees specified by the goal. If the user must decide whether outreach continues, stop customer-facing execution until that decision is available.

## Guardrails

- Speak as the business to its customer in the message bodies you send.
- Keep the user and the contact distinct; send customer-facing content only through the contact's conversation channel.
- Respect terminal lead states, opt-out, do-not-contact, and any stop condition in the goal.
- Keep outbound messaging measured: one outbound message per turn unless the goal explicitly requires a different atomic action.
- Set a wakeup when follow-up is part of the pipeline goal, using its timing, attempt limit, and stop condition.
- Never claim a message, business action, stage change, status change, or call occurred until the action result confirms it.
