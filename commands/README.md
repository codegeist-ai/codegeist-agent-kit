# OpenCode Commands

Shared workflow commands intended to work across repos.

## Purpose

- Keep common repo actions repeatable and easy to discover.
- Preserve a small shared command core.
- Move repo-specific planning and analysis flows into repo-local docs or
  repo-local commands.

## Core Workflow Commands

- `/memory-bank` - refresh the repo's lightweight memory file using the repo
  memory rules.
- `/update-chat` - refresh `docs/memory-bank/chat.md` when the repo uses it as
  project memory.
- `/learn` - capture durable guidance in `.opencode/rules/`.
- `/commit` - review changes and create a git commit.
- `/git-commit` - compatibility wrapper around `/commit`.
- `/git-sync` - rebase the current branch onto the repo's local base branch,
  fast-forward that base branch, and verify that both refs end on the same
  commit.
- `/rebase` - rebase the current branch onto the repo's local base branch.
- `/save` - run the memory, learn, commit, current-branch rebase, local
  base-branch fast-forward, and when configured, the final base-branch push
  plus local/remote branch-sync flow.
- `/session-title` - generate a short session title from the current branch and
  recent result.
- `/task` - manage task folders under `docs/tasks/` with the actions `create`,
  `specify`, `solve`, `cancel`, and `backlog`.
- `/update-documentation` - refresh the docs affected by recent changes.
- `/verify-documentation` - audit repo docs and report stale or broken
  references.
- `/create-ai-script` - create a repo-local AI helper script when one is
  justified.

## Local Overlays

- Project-specific planning, analysis, and deployment workflows should live in
  repo-local docs or repo-local commands such as `@.oc_local/commands/*.md`.
- Keep the shared command set repo-agnostic and move project-only workflow
  details into the consuming repo instead of the shared command core.
