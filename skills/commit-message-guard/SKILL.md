---
name: commit-message-guard
description: validate commit message inputs and run a safe git commit command
trigger: /commit-message-guard
---

# /commit-message-guard

Use this skill when a task needs a git commit message checked for literal `\n`
escape sequences before the commit is created.

Follow `@.opencode/rules/ai-scripts.md` and `@.opencode/rules/commit.md`.

## Usage

```text
/commit-message-guard
```

## Purpose

This skill standardizes the shared commit path that should not trust ad-hoc
shell escaping:

- keep commit subject and body in separate inputs
- reject literal `\n` escape sequences before commit creation
- print the exact safe `git commit` command that uses env vars
- optionally execute the commit and verify the stored commit message afterward

## Workflow

1. Draft the commit subject and optional body separately.
2. Set `ARG_COMMIT_SUBJECT` to the subject.
3. Set `ARG_COMMIT_BODY` only when a body is needed, using real line breaks.
4. Run `bash ".opencode/ai-scripts/commit-message-guard.sh"` to validate the
   inputs and inspect the emitted `COMMAND=` line.
5. When the draft is correct and staged changes are ready, rerun with
   `ARG_EXECUTE=1` to create the commit.
6. Stop and report the exact script failure instead of falling back to a manual
   `git commit` command when the script rejects the message.

## Commands

Use direct shell commands such as:

```bash
ARG_COMMIT_SUBJECT='docs: example' \
ARG_COMMIT_BODY='Explain why the docs changed.

Keep real newlines in the body.' \
bash ".opencode/ai-scripts/commit-message-guard.sh"

ARG_COMMIT_SUBJECT='docs: example' \
ARG_COMMIT_BODY='Explain why the docs changed.

Keep real newlines in the body.' \
ARG_EXECUTE=1 \
bash ".opencode/ai-scripts/commit-message-guard.sh"
```

## Rules

- Do not collapse subject and body into one env var.
- Do not use literal `\n` escapes in `ARG_COMMIT_SUBJECT` or
  `ARG_COMMIT_BODY`.
- Do not bypass the script with a manual `git commit` when the shared
  commit workflow is available.
- Do not execute the commit until the relevant changes are already staged.
