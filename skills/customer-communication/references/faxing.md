---
name: faxing
description: Send a PDF fax when the user supplies an Ask Z attachment and a recipient fax number, or when an active communication workflow requires a fax.
---

# Sending a fax

Fax delivery uses Z360 conversation actions. The agent passes the Ask Z attachment path to Z360; it does not download the file or call the gateway directly. Z360 retrieves the PDF, stores it in protected fax storage, creates an outbound fax message, and queues the existing Telnyx fax job.

## Prepare the send

- Require one uploaded PDF attachment no larger than 50 MB. Use its Ask Z `virtual_path`, such as `/attachments/referral.pdf`, as `attachment_path`. If no eligible PDF is attached, ask the user to attach one.
- Resolve the recipient as a full international fax number. Do not guess a missing or ambiguous number.
- Use `search-fax-numbers` to find an active sender available to the current user. Match an explicit number or alias; when several plausible senders remain, ask the user which one to use.
- Discover each action in the authenticated Z360 action group and read its current schema before execution. Use returned IDs and exact argument names.

## Send a new fax

Use `create-conversation` with:

- `type`: `fax`
- `channel_id`: the selected fax-number ID
- `recipient`: the resolved destination fax number
- `attachment_path`: the Ask Z attachment path

No subject or text body is required. Z360 may reuse an existing fax conversation for the same sender and recipient.

## Send in an existing fax conversation

Confirm the conversation's `type` is `fax`, then use `send-conversation-message` with its `conversation_id` and the new `attachment_path`. Do not send a text-only reply in a fax conversation.

## Interpret the result

A successful action confirms that the fax message was created and queued; it does not prove delivery. Report it as queued or submitted. If delivery confirmation is requested, read the conversation again and report only the status recorded on its fax message. Surface validation, billing, channel, and provider errors without silently retrying or claiming success.
