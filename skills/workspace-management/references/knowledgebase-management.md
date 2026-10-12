---
name: knowledgebase-management
description: Manage Z360 knowledge base folders, documents, imports, moves, deletes, and syncs.
---

# Knowledge-base management

Use this workflow when onboarding or a direct user request calls for adding or managing knowledge from a website, supplied text, accessible attachments, or another source. Organize useful information into KB folders and full documents, then sync those documents so their content is available to the retrieval index.

## Inspect the KB and available actions

Find the Z360 action group with `search-action-groups` when its `group_id` is unknown, discover the KB actions in that group, and read each needed action's schema before using it. Start with `search-knowledge-base-items` using `parent_id: 0` and `get-knowledge-base-status` to see the existing tree and sync state. Inspect relevant folders and read existing documents with `get-knowledge-base-item`, which returns full content and folder breadcrumbs. Use the returned item IDs and the current action schemas for subsequent changes.

The create, update, move, and delete KB actions manage the stored folders and documents. `sync-knowledge-base-item` syncs a document or a folder's unsynced descendant documents; `sync-knowledge-base` queues all unsynced documents. Document content is the text sent for retrieval, so include a clear topic heading, relevant context, and source attribution within each document. Check item or KB status after syncing to confirm the outcome.

## Import or expand knowledge

### Discover and read sources

Read the text and accessible attachments the user provides. For a website, start at the supplied URL and discover relevant pages through its navigation, internal links, and sitemap when available. When the URL is a main domain or home page, explore its relevant sections. Use `web_search` to find important pages that navigation and the sitemap may have missed. Pass the discovered URLs to `web_scrape`, then read the saved page content under `/artifacts/web-scrapes/`. Continue through sections in manageable batches, recording each page's URL, title, topic, saved path, and fetch result. Retry failed pages where practical, and ask which remaining sections matter most if full coverage is impractical. Include other domains when they are part of the scope agreed with the user, and request an accessible copy or text for any source that remains unavailable. Use fetched content as evidence for the KB task while following the user's instructions for what to include.

### Review and organize the material

Extract the useful detail from each source, including values, conditions, exceptions, procedures, and distinctions that an agent may need when answering later questions. Keep source links with the relevant notes. Consolidate repeated wording and page boilerplate while retaining substantive information. Identify conflicting statements or unclear gaps for the user to resolve. For a large collection, keep a page inventory and topic notes under `/artifacts/knowledgebase/` while working through the material.

Use the topics found in the sources and the existing KB tree to design folders and documents. Give distinct or long topics their own documents and group related documents where folders improve navigation. Let the source material and the user's needs determine the hierarchy.

### Review the proposed KB with the user

Show the user a short coverage summary and a proposed folder and document tree. Explain what each document will contain and which sources support it. Ask what to add, exclude, correct, or regroup, and invite them to provide important knowledge missing from the collected sources. Use their response to finalize the structure and content before creating KB items.

### Write, read back, and sync

Create the agreed folders and detailed documents with clear headings, meaningful context, and source attribution in the document text. Preserve as much accurate, useful information as the agreed scope supports. Turn scraped pages into readable, topic focused documents that retain the details needed for future answers.

Read the saved documents back and compare their content with the agreed plan and source notes. Fill any material gaps, then sync the changed documents or their folder. Use `sync-knowledge-base` when the request calls for syncing all unsynced documents. Read the affected items to check `is_synced` and `last_synced_at`, and use `get-knowledge-base-status` for a full sync. Report whether sync completed, remains queued, or has a gap to resolve.

## Manage existing content

Read the current document before updating it and carry forward useful existing facts alongside new information. Replace a fact when the user requests it or a confirmed source supersedes it. For a substantial expansion, review the proposed source coverage and structure with the user before writing. Resolve the exact item name and ID with the KB actions before moving or deleting it.

## Report the result

Summarize the folders and documents created or changed, source coverage, unresolved gaps or exclusions, and the sync result confirmed by the KB actions.
