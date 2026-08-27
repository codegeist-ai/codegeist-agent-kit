# OpenCode Commands

Shared workflow commands intended to work across repos.

## Purpose

- Keep common repo actions repeatable and easy to discover.
- Preserve a small shared command core.
- Move repo-specific planning and analysis flows into repo-local docs or
  repo-local commands.

## Core Workflow Commands

- `/learn` - capture durable guidance in `.opencode/rules/`.
- `/commit` - review changes and create a git commit.
- `/git-commit` - compatibility wrapper around `/commit`.
- `/git-sync` - rebase the current branch onto the repo's local base branch,
  fast-forward that base branch, and verify that both refs end on the same
  commit.
- `/rebase` - rebase the current branch onto the repo's local base branch.
- `/save` - run `/learn`, refresh submodules, commit, rebase, and push. On the
  local base branch it may push that base branch; on a feature branch it
  refreshes the local base branch from upstream, rebases the current branch onto
  that refreshed base, and pushes only the current branch.
- `/session-title` - generate a short session title from the current branch and
  recent result.
- `/task` - manage canonical task files under `docs/tasks/` with the actions
  `spec`, `impl`, `cancel`, and `backlog`; projects that mount
  `codegeist-agent-kit` as `.opencode` and have a confirmed GitHub mirror receive
  one concise Issue per top-level or child task through `GH_TOKEN`, but only
  after the user approves the exact Issue preview; verified implementation closes
  that Issue as completed before local status becomes `solved`.
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
  release.

## Local Overlays

- Project-specific planning, analysis, and deployment workflows should live in
  repo-local docs or repo-local commands such as `@.oc_local/commands/*.md`.
- Keep the shared command set repo-agnostic and move project-only workflow
  details into the consuming repo instead of the shared command core.
