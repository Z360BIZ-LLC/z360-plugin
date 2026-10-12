---
name: outbound-calling
description: Place an outbound phone call to a person. Read this reference before ever calling the outbound-call action. Use when the user asks you to call someone, phone a lead, or follow up by phone, or when a lead pipeline goal reaches a step that requires a call to accomplish its objective.
---

# Making an outbound call

You're about to make a **real phone call to a real person.** The call starts live and
cannot come back for clarification, so its **goal** must contain the purpose, a
short workflow, the voicemail instruction, the tools it may use, and the safety
boundaries. Whatever you leave out becomes a guess, a wrong tool call, or a made-up
promise to someone on the other end.

The goal you write **is a compact skill delivered by value.** It uses the same
`SKILL.md` frontmatter and tool references as any skill, but keeps the whole call
plan in one short document that rides *with* this call instead of being stored and
picked from a catalog.

Place the call by calling the **outbound-call action** (in the **"Z360"** group of the action catalog) with three things: `from_number` (an active org phone number to call from), `to_number` (the US number to call), and `goal` (the full `SKILL.md` you write). Never call it until the goal is complete and confirmed. And the job isn't done when you dial — the call runs for minutes, so you set a wakeup, wait, then read the outcome and act on it (§8–§9).

## 1. Know how you got here

There are two ways you arrive at placing a call, and they change how much you ask.

- **A person asked you, in chat.** *"Call this number and get them to reschedule."* The request is almost always incomplete. **Interrogate them (§2) until the goal is unambiguous** before you dial. Never fill the gaps with your own assumptions.
- **A pipeline goal directed it.** You're working a pipeline goal and it reaches a step like *"call the inquiry and confirm they still want the appointment."* Here the **purpose, the success criteria, and the facts are already given to you** in the pipeline's instructions — your job is to **extract them faithfully and shape them into a goal**, not to invent anything. There may be **no user to ask**, so pull everything you need from the instructions you were given and the tools/records you can reach. Only stop and flag a gap if something *required* to place the call (a phone number, a critical fact) is genuinely missing.

## 2. Pull the call goal out (clarify first)

Whether you're interrogating a person or reading a pipeline's instructions, you need all of this before you write a goal. When it's a person, ask warmly, a few questions at a time, and keep going until you could describe the whole call yourself. When it's a pipeline, map its instructions onto these and ask only about real gaps.

- **Who and what number** — who are we calling, and the `to_number` (US). And **which org number to call from** (`from_number`, an active org phone number) — if there's only one obvious choice use it, otherwise settle it.
- **Purpose** — why we're calling, in one plain sentence you could say out loud.
- **The stop condition — and the acceptable "no."** What has to be true for the call to be done? Put the finish line and the acceptable negative outcome in `flow` (e.g. *"…OR they decline to rebook and say they'll call us"*). A happy path without an explicit stop condition makes the agent grind against a refusal.
- **Voicemail** — if a machine picks up, does the agent **leave a message** (say exactly what) or **hang up silently**? Assume a household member may hear it; if the reason is sensitive, say what to leave *out*.
- **The steps and the branches** — what to say, in order, and every fork *including the unhappy ones*: wrong person answers, they decline, nothing works, an action fails. Identity: confirm you're speaking to the right person before revealing anything.
- **The facts the call needs** — names, appointment details, open slots, a confirmation number. These get **inlined as prose** in the goal (§4), not saved as variables.
- **The actions the call must perform** — booking, creating a ticket, an eligibility check. Resolve these per §3.
- **Guardrails and formats** — what must never happen (never promise X, never disclose Y) and any value that must be sent or said exactly.

## 3. Resolve the goal's tools (same discipline as any skill)

If the call only talks — no booking, no ticket — skip this. Otherwise, for **each** action the call will perform, work the catalog discovery tools in order and **never guess a name, id, or parameter**:

1. **Find the group** — `search-action-groups` → pick the `group_id`.
2. **Find the action** — `search-actions` (with that `group_id`) → pick it, note its `action_slug`, confirm what it does.
3. **Get its parameters** — `get-action-schema` (`group_id`, `action_slug`) → read the real `input_schema`. Confirm, per parameter, *what* goes there and *where it comes from* (the callee's answer / an earlier result / a verbatim constant).
4. **Record the real `group_id` + `action_slug`** for the manifest. **Never invent a reference and never leave an action unresolved.**

**The conversation-id rule.** Only if an action's `input_schema` you actually read in step 3 **literally lists a `conversation_id` parameter** that you must fill: also resolve **`get-conversation-id`** (in the **"Z360"** group), add it to the manifest with its real references, and in the body call it **once before the first action that needs it**, passing its result in via a `conversation_id:` line. If no resolved schema has such a parameter — including when a ticket or note fills its thread server-side — **do not add `get-conversation-id` at all.** Don't add it "to be safe."

**Action access.** The outbound call runs with the authenticated organization action
catalog. Resolve every action needed by the call and use its exact references; if an
action is unavailable, report the gap rather than inventing an id.

## 4. Write the goal — a compact `SKILL.md` with five fields

Compose the goal as one `SKILL.md`. It is **not written to a file** — you pass it inline as the `goal` argument in §7.

````yaml
---
name: appointment-reschedule-callback      # kebab-case, named after the JOB, not the person
description: >
  Call Sarah Chen because her Tuesday 3pm cleaning appointment must be moved.
  The intent is to agree on another suitable time or confirm that she prefers
  to call the office later.
flow: |                                    # REQUIRED — short ordered workflow and stop conditions
  1. Confirm that you are speaking with Sarah before sharing appointment details.
  2. Explain that the Tuesday appointment needs to be moved and offer the available times.
  3. Confirm the selected time and let her know what will happen next.
  4. If none work, ask what days suit her and explain the follow-up plan.
  5. Stop if she declines or says she will call the office herself.
voicemail: >                               # REQUIRED — what to leave, or "Do not leave a message. Hang up."
  Say who is calling, explain that her Tuesday appointment needs attention,
  and ask her to call the main office. Do not disclose why it must be moved.
tools:                                     # real references from §3 — dict form, never bare names
  - name: create-ticket
    group_id: <int from §3>
    action_slug: <slug from §3>
---
````

`name`, `description`, `flow`, and `voicemail` are required for every outbound goal.
The parser drops the manifest if `name` or `description` is missing. The `flow`
is the caller-safe summary handed to the speaking agent: it must state the call's
intent, ordered steps, branches, and explicit stopping condition, while staying
free of tool names, action slugs, ids, parameter names, JSON, and hidden execution
instructions. `voicemail` must say exactly what to leave or that the agent should
hang up. `tools` is required as a manifest field; use an empty list when the
flow performs no action.

Keep the caller-safe summary fields in this frontmatter block. Put operational
instructions, facts needed by tools, and ` ```do ` blocks in the Markdown body for
the worker that executes the call:

- **Inline every fact as prose.** *"You're calling Sarah Chen about her Tuesday March 4th 3pm cleaning with Dr. Reyes. That slot is gone. Open this week: Wed 10am, Wed 2pm, Fri 9am."* **No variables map, no `{placeholder}` slots, no `save_variable`** — context is the memory; later steps refer to earlier things by meaning.
- **Speakable language only.** The front agent says the `description`, `flow`, and `voicemail` prose out loud, so **no ids, no JSON, no field names, no jargon** anywhere in those fields.
- **Number the flow in order** and branch explicitly — *"If she says none work, ask what days suit her; don't push past two suggestions."* The model follows prose branches, not implied ones.
- **Each action is a ` ```do ` block in the body** naming a tool from the manifest, with one `param: <fill instruction>` line **per value the worker supplies** — nothing else. Auth, endpoints, and ids are never in the block.
- **State formats and verbatim values inline** — *"date of birth as YYYYMMDD, eight digits, no dashes"*, *"read this back exactly: …"*. **Never invent:** if a value isn't in the goal and can't come from a tool, tell the agent to ask for it.

**Keep it short — this is a hard constraint.** The goal travels base64-encoded in a SIP header, and a too-long goal is **rejected**, not truncated. Include only facts that matter to *this* call. For anything non-trivial the organization already has as a stored skill, **point at its path instead of restating it** — for example, *"For the eligibility check, read `/skills/org/eligibility/SKILL.md` and follow it"* — which keeps the goal small and the procedure maintained in one place.

**Never put in a goal:** a separate `success:` field, ability-engine XML (`<Flow>`, `status="current"`, `end_script`), a `save:`/variables map, secrets/auth/endpoints, persona or tone or language rules (those come from the org's config), or generic voicemail/pushback *rules* (the outbound prompt already has those — the goal supplies only the per-call `voicemail:` content).

## 5. Check the goal before you dial

- `name`, `description`, `flow`, and `voicemail` are all present.
- `description` states why the call is happening and its intent; `flow` summarizes what will happen, includes all branches, and states when to stop.
- Every `tools:` entry carries a real `group_id` **and** `action_slug`, and the authenticated catalog can reach it.
- Every fact the agent needs is inlined as prose — no variables map, no placeholders.
- Every ` ```do ` block names a tool in the manifest; any action needing `conversation_id` has a `get-conversation-id` step before it.
- No secrets, no ids or JSON in anything spoken, no ability-engine XML, no persona/tone rules.
- Long procedures reference a stored skill path instead of being inlined; the goal is short.
- It reads as instructions to a person, in the order they happen.
- `from_number` is an active org number and `to_number` is the person you mean to call.

Fix anything that fails.

## 6. Confirm, if a person asked

- **If a person asked:** play the whole thing back in plain language — who you're calling and from which number, the purpose and intent, the flow and stop condition, what happens on voicemail, the branches, and the guardrails — and get an explicit **yes**. Fix what they correct, then re-confirm. **Do not dial without the green light.**
- **If a pipeline directed it:** there's no one to confirm with — the §5 check is your gate. Don't dial with a required field missing.

## 7. Place the call

Call the **outbound-call action** (in the **"Z360"** group; resolve it via the catalog like any action) with exactly:

- `from_number` — an **active** org phone number to call from (US).
- `to_number` — the recipient (US). The tool validates both as US numbers.
- `goal` — the full `SKILL.md` text you wrote in §4.

It returns a **`conversation_id`** and a `message_id`. **Hold onto the `conversation_id`** — you need it to follow the call (§8). If it comes back rejected (org or app **concurrency limit reached**, or billing blocked), that call did **not** start: surface it plainly and **do not silently retry.**

## 8. Wait for the call to finish

The call runs on its own and takes minutes. **Don't block on it and don't loop in one turn** — set a wakeup, end your turn, and check back. A wakeup is a timer on this thread: when it fires you get a fresh turn here with all of this context intact.

1. **Right after placing the call,** leave one line a future turn will understand — e.g. *"Call placed to Marcus (conversation 90210); I'll check the outcome shortly."* Then call **`set-wakeup`** with `minutes: 2` and end the turn. (You don't need to re-read this skill when you wake — your note and the `conversation_id` in the thread are enough.)
2. **When the wakeup fires,** check whether the call is over. Read the call's message with **`search-messages`**, scoped to this call: pass `filters.conversation_id` = the conversation id from step 7 and `filters.type` = `["phone_call"]`, with `per_page` 1. The outbound call created a fresh one-message conversation, so that returns the call's message. Read its **`metadata.outbound_tool_resolved_at`**:
   - **empty / null** → the call is **still going.** Call `set-wakeup` again with a slightly longer gap than last time (3 minutes, then 4, then 5…) and end the turn. **Give up after about six checks / ~20 minutes total** — then report that you couldn't confirm the outcome rather than waking forever.
   - **a timestamp** → the call is **over.** Go to §9.

## 9. Read the outcome and act

With the call over, read the result off that same phone-call message (via `search-messages`):

- **`metadata.summary`** — the summary of how the call went. This is your primary read on the outcome.
- **`metadata.transcript`** — the turn-by-turn transcript, if you need detail beyond the summary.
- **`metadata.is_voicemail`**, **`metadata.client_picked_up`**, **`metadata.received_by_label`** — whether a person answered, it went to voicemail, or no one picked up.

**The summary and transcript are written by a different step than the "call over" flag, so they can lag a little.** If `outbound_tool_resolved_at` is set but `summary` / `transcript` are still empty, set one more short wakeup (a minute or two) and read again before concluding.

Then act on what you learned, judging it against the goal's `flow` and stop condition:

- **If a pipeline directed the call** — feed the outcome into the pipeline goal's next step (book the slot they chose, mark the lead not-interested, retry later if it hit voicemail), following what that goal says to do with the result.
- **If a person asked** — tell them plainly how it went: whether you reached them, what they said or agreed to, and the one next step. Lead with the outcome; don't paste the raw transcript. It was your call, so speak as the teammate who made it — *"I called Marcus and he asked to move to Thursday"* — never *"the AI agent called"*.

If the call didn't reach the `flow`'s stop condition (voicemail, no answer, they declined), **say so honestly** and do the sensible fallback — don't dress a miss up as a win.
