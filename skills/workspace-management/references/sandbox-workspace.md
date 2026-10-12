# Sandbox workspace

Use the sandbox for temporary command execution and file processing.

## Tools

- `sandbox_execute` runs a command in the current thread's sandbox.
- `sandbox_upload` copies an existing `/attachments/` or `/artifacts/` file into
  the sandbox.
- `sandbox_download` copies a sandbox file into persistent `/artifacts/` storage.

## Workflow

1. Upload required Ask Z files before running commands.
2. Run commands with `sandbox_execute`. Keep using the same sandbox paths across
   related calls in the thread.
3. Check the command output and exit code before continuing.
4. Download each final file the user needs to `/artifacts/`.
5. Report the persistent artifact paths to the user.

For a command-only task, use `sandbox_execute` directly. Do not upload files the
command does not need, and do not download temporary or intermediate files.

## Lifecycle

- The first sandbox tool call creates the sandbox lazily. Creating a thread does
  not create a sandbox.
- The same thread reuses the same sandbox across `sandbox_execute`,
  `sandbox_upload`, and `sandbox_download`.
- Sandbox files are temporary and may be deleted when the sandbox expires. Only
  files downloaded to `/artifacts/` are durable Ask Z outputs.

## File rules

- Use absolute paths inside the sandbox.
- Upload only from `/attachments/` or `/artifacts/`.
- Download only to `/artifacts/`.
- Each transfer is limited to 50 MB.
- Never claim a generated file is persistent until `sandbox_download` succeeds.
- If execution or transfer fails, report the failure without claiming the requested output was created.
