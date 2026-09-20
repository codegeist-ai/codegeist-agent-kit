# OpenCode Commands

Shared workflow commands intended to work across repos.

## Purpose

- Keep common repo actions repeatable and easy to discover.
- Preserve a small shared command core.
- Move repo-specific planning and analysis flows into repo-local docs or
  repo-local commands.
- Create commits only when the current user request invokes `/commit`,
  `/git-commit`, or `/save`, or otherwise explicitly requests a commit.

## Core Workflow Commands

- `/learn` - capture durable guidance in `.opencode/rules/`.
- `/commit` - create one local commit from the intended coherent change set;
  unrelated dirty files and unrequested pushes remain untouched.
- `/git-commit` - compatibility wrapper around `/commit`.
- `/git-sync` - rebase the current branch onto the repo's local base branch,
  fast-forward that base branch, and verify that both refs end on the same
  commit.
- `/rebase` - rebase the current branch onto the repo's local base branch.
- `/save` - run `/learn`, refresh submodules, commit, rebase, and push. On the
  local base branch it may push that base branch; on a feature branch it
  refreshes the local base branch from upstream, rebases the current branch onto
  that refreshed base, and pushes only the current branch. Direct invocation
  authorizes these documented side effects without a second confirmation.
- `/session-title` - generate a short session title from the current branch and
  recent result.
- `/task` - manage canonical task files under `docs/tasks/` with the actions
  `spec`, `impl`, `cancel`, and `backlog`; local tasks default to no public
  tracking, while users may opt into one concise GitHub Issue through `GH_TOKEN`
  and exact-preview approval. A linked Issue is validated before implementation
  and confirmed closed as completed before local status becomes `solved`.
  `backlog` only records an uncommitted local edit.
- `/update-submodules` - update `.opencode` and `.devcontainer` to their
  configured branches from `.gitmodules`.
- `/update-documentation` - refresh the docs affected by recent changes.
- `/verify-documentation` - audit repo docs and report stale or broken
  references.
- `/update-index` - create or refresh an agent-owned directory `INDEX.md` for
  local navigation and search hints.
- `/create-ai-script` - create a repo-local AI helper script when one is
  justified.
- `/add-agent-kit` - add reusable shared commands, rules, skills, or OpenCode
  configuration upstream, or move generic `.oc_local/` overlays into the shared
  agent kit, then update the consuming repo's `.opencode` submodule to the new
  release. It prepares and tests the source change before requiring explicit
  authorization for its source and release commits and pushes.

## Local Overlays

- Project-specific planning, analysis, and deployment workflows should live in
  repo-local docs or repo-local commands such as `@.oc_local/commands/*.md`.
- Keep the shared command set repo-agnostic and move project-only workflow
  details into the consuming repo instead of the shared command core.
