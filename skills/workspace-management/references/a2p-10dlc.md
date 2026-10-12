---
name: a2p-10dlc
description: Guide Z360 A2P 10DLC registration through the action catalog. Read this reference when a customer asks about A2P, 10DLC, SMS registration, messaging compliance, brand registration, campaign registration, campaign review, campaign rejection, or phone-number messaging readiness.
---

# Z360 A2P 10DLC

Use this skill with the authenticated Z360 action catalog. A2P 10DLC registration
is required for reliable business SMS/MMS messaging on US long-code numbers. Treat
it as a guided compliance setup, not a generic form-fill task.

## Tools

- `get-a2p-registration-details`
- `submit-a2p-brand`
- `submit-a2p-campaign`
- `appeal-a2p-campaign`

## Workflow

1. Always start with `get-a2p-registration-details`.
   - Use it to read current brand/campaign state, SMS availability, temporary messaging status and expiry, errors, campaign phone counts, limits, valid options, and campaign prefills.
   - Summarize where the customer is in the flow before asking for more information.
2. If brand registration is missing, incomplete, unverified, or failed, guide the brand step first.
   - Collect only the missing fields required by `submit-a2p-brand`: display/DBA name, legal company name unless government, entity type, vertical, EIN, website when available, US address, and contact name/email/phone.
   - Use the `options.entity_types`, `options.verticals`, and `options.stock_exchanges` values returned by the read tool; do not invent enum values.
   - For `PUBLIC_PROFIT`, collect stock symbol and stock exchange.
   - Tell the customer that initial brand submission may charge the one-time brand registration fee, then get explicit approval before calling `submit-a2p-brand`.
3. If brand registration is in review, explain that campaign submission should wait until the brand is approved or the platform reports the next allowed step.
4. Once brand registration is complete, guide campaign registration.
   - Use `campaign_prefills` from `get-a2p-registration-details` as drafting help, but personalize them to the customer's business.
   - Collect campaign description, message flow/consent source, HELP response, opt-in confirmation, two realistic sample messages, public SMS terms URL, and public privacy-policy URL.
   - Samples and opt-in/help text should be specific, compliant, and include opt-out/help expectations where appropriate.
   - Tell the customer that campaign submission may charge a campaign review fee, then get explicit approval before calling `submit-a2p-campaign`.
5. If a campaign failed, help the customer appeal instead of resubmitting blindly.
   - Use `a2p_errors` and `a2p_campaign_errors` from the read tool to explain the rejection in plain language.
   - Ask for or draft a concise appeal reason that says what changed.
   - Update sample messages during appeal when the rejection concerns samples, consent, opt-out, or message content.
   - Call `appeal-a2p-campaign` only after explicit approval; include `campaign_id` when multiple campaigns exist.
6. After any write, briefly confirm what was submitted and explain the expected review state. Do not promise approval or exact carrier review timing unless the tool result states it.

## Status Guidance

- `awaiting_submission`: the next form step can be submitted.
- `in_review`: submission has been sent; explain that the customer may need to wait for review.
- `failed`: read the errors, explain what likely needs correction, then guide update or appeal.
- `unverified`: explain that the brand needs corrected business identity details before campaign work proceeds.
- `completed`: the relevant registration step is accepted.

Campaign limits from the read tool matter. Do not create a new campaign when `a2p_campaign_limit` is reached. Use `a2p_campaign_number_limit` and campaign phone counts to explain whether an existing campaign can support more numbers.

## Temporary messaging

Use `temporary_messaging` and `sms_can_send` as the source of truth. If temporary SMS is active, state its expiry date and remaining time. If it is pending activation, expired, or unavailable, explain the returned state without promising access. Keep the temporary messaging window separate from carrier review.

## Guardrails

- Never guess EIN, legal company name, consent language, terms URL, privacy URL, or public-company details.
- Do not submit brand, campaign, or appeal writes without clear user approval.
- Do not send null, empty strings, empty arrays, or default values just to satisfy optional fields.
- Do not expose full EIN back to the customer unless they provided it in the current conversation and need to confirm it; prefer saying it is present or missing.
- Do not claim SMS is ready until registration state and phone-number assignment support that.
- Keep the flow conversational: explain why each field matters, collect missing details in small batches, and make skipping or pausing feel normal when the customer is not ready.
