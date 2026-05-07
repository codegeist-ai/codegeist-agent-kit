# Release Usage For LLM Coding Agents

This repository provides a reusable OpenCode workspace that consuming git
repositories mount as a `.opencode` submodule. It gives an LLM coding agent a
shared set of rules, commands, skills, helper scripts, and OpenCode plugin
configuration while leaving project-specific behavior in the consuming repo.

## What This Submodule Provides

- `opencode.json` loads the shared instructions, MCP servers, plugin files, and
  external-directory permissions expected by OpenCode.
- `rules/` contains durable agent rules for command execution, commits, tests,
  documentation, memory-bank updates, task workflow, scripting, and related
  engineering practices.
- `commands/` contains reusable slash-command workflows such as `/save`,
  `/commit`, `/learn`, `/update-chat`, `/git-sync`, `/rebase`, `/task`, and
  `/update-submodules`.
- `skills/` contains targeted reusable workflows, currently `gh-auth`,
  `commit-message-guard`, and `graphify`.
- `ai-scripts/` contains helper scripts used by the commands and skills, such
  as `commit-message-guard.sh`.
- `plugin/` contains Graphify OpenCode integration files. Graphify is optional
  and should only build or update graphs when the user explicitly asks for it.

The generated `release` branch is intentionally minimal. During release copy,
this source file is renamed from `README_release.md` to `README.md`. The release
branch should contain only runtime files needed by consuming repositories:
`.gitignore`, `README.md`, `opencode.json`, `ai-scripts/`, `commands/`,
`rules/`, `skills/`, and `plugin/`.

## Add To A Consuming Repository

Add this repository as the `.opencode` submodule from its generated `release`
branch:

```bash
git submodule add -b release https://github.com/codegeist-ai/codegeist-agent-kit.git .opencode
git submodule update --init --recursive
```

After adding or updating the submodule, commit the parent repository gitlink
change together with the matching `.gitmodules` change when applicable.

## Update In A Consuming Repository

Refresh the submodule to the latest configured release branch commit:

```bash
git submodule update --remote .opencode
git status --short
```

If the parent repo also uses `.devcontainer` from the shared workspace family,
prefer the shared command when available:

```text
/update-submodules
```

The command updates only `.opencode` and `.devcontainer` to the branches
configured in `.gitmodules`, verifies clean submodule states, and reports any
parent gitlink changes that need to be committed.

## Expected Consumer Layout

OpenCode should see this submodule at exactly `.opencode/` in the consuming repo
root. The instruction paths in `opencode.json` intentionally use
`.opencode/...` prefixes and should not be rewritten to absolute paths.

Project-specific behavior belongs outside this shared submodule, typically in:

- `.oc_local/commands/*.md`
- `.oc_local/rules/*.md`
- `.oc_local/skills/*/SKILL.md`
- repo-owned docs such as `docs/memory-bank/chat.md` or `docs/tasks/`

Do not add product-specific deployment steps, architecture assumptions, branch
names, or planning rules to the shared `.opencode` submodule unless they are
intended to apply across all consuming repositories.

## Agent Startup Checklist

When working inside a consuming repository that uses this submodule:

1. Read any active repo memory file, usually `docs/memory-bank/chat.md`, when it
   exists.
2. Read relevant shared rules under `.opencode/rules/` and any local overlays
   under `.oc_local/rules/`.
3. Inspect the affected repository files directly before making assumptions.
4. Prefer repo-local commands and overlays when they define a more specific
   workflow than the shared default.
5. Treat `.opencode` as a submodule gitlink, not as ordinary parent-repo files.

## High-Value Commands For Git Work

- `/save` refreshes memory, learns durable guidance, updates shared submodules,
  commits, rebases, fast-forwards the local base branch, and pushes the base
  branch when configured.
- `/commit` reviews the diff and creates a focused conventional commit.
- `/git-sync` synchronizes the current branch and local base branch without
  creating a commit.
- `/rebase` rebases the current branch onto the local base branch.
- `/learn` captures durable workflow guidance in rule files.
- `/update-chat` refreshes `docs/memory-bank/chat.md` when the repo uses it as
  lightweight project memory.
- `/session-title` creates a short session title from the current branch and
  recent result.
- `/task` manages tracked task files under `docs/tasks/` when the repo uses
  that workflow.

Prefer these commands over reimplementing their shell and git logic in chat,
especially for commits, saves, submodule updates, and base-branch sync.

## Commit And Git Safety

- Follow conventional commit style from `.opencode/rules/commit.md` and
  `.opencode/rules/commit-conventions.md`.
- Use `.opencode/ai-scripts/commit-message-guard.sh` or the
  `commit-message-guard` skill when creating commits through the shared
  workflow.
- Keep commit subject and body as separate inputs and use real line breaks in
  commit bodies. Do not pass literal `\n` escape sequences.
- Never commit secrets, unrelated files, or generated noise.
- Never use destructive git commands such as `git reset --hard` unless the user
  explicitly asks for that exact action.
- Do not amend commits unless the user explicitly requests it and the active
  safety rules allow it.
- When a task intentionally changes a submodule, commit the submodule content on
  the intended branch first, synchronize its upstream when configured, then
  commit the parent repository gitlink update.

## GitHub CLI Work

When a task needs GitHub CLI access, verify authentication before using `gh`:

```bash
gh auth status
```

If the session is not authenticated, use the `gh-auth` skill. Do not ask the
user to paste tokens into chat when the browser login flow can complete the
authentication.

## Documentation, Memory, And Local Rules

- Keep durable repo-owned docs and comments in English unless the consuming repo
  records an explicit language exception.
- Update docs in the same task when behavior changes.
- Update `docs/memory-bank/chat.md` when future sessions would otherwise miss
  important context.
- Use `/learn` for reusable guidance that should become a durable rule.
- Prefer updating an existing rule over adding broad or duplicative guidance.

## Graphify Notes

Graphify is available as an optional OpenCode aid. For normal coding tasks:

- Read existing graph reports under `docs/graphify/` when they are relevant.
- Prefer graph queries only when a matching existing `graph.json` is available.
- Do not run graph-building commands such as `graphify install`,
  `graphify update`, or `graphify extract` unless the user explicitly requests
  graph generation.

## Maintaining This Shared Repository

The source repository contains development-only files that are not part of the
release submodule. Maintainers should use the Taskfile instead of hand-building
the release branch.

Run the release smoke test:

```bash
task test
```

Build and push the generated orphan release branch:

```bash
task release-build
```

The `release-build` task creates a temporary worktree, copies only the release
runtime paths, commits them on an orphan branch, updates the local release ref,
and pushes it with `--force-with-lease`. The working branch and dirty worktree
are left untouched except for the temporary release worktree cleanup.

When using this repo's local release workflow, prefer
`.oc_local/commands/release-build.md`; it runs `task release-build`, refreshes
the configured shared submodules, and then delegates final commit, rebase, and
sync work to the shared `/save` workflow.

## Quick Troubleshooting

- If OpenCode does not load shared rules, confirm the submodule path is exactly
  `.opencode/` and `opencode.json` is present at `.opencode/opencode.json`.
- If a shared command seems too generic, check for a consuming-repo overlay under
  `.oc_local/commands/` before changing the shared command.
- If submodule updates show a dirty parent repo, commit the intentional gitlink
  update in the parent repository.
- If a release bundle is missing files, run `task test` in this repository and
  inspect `Taskfile.yml` `RELEASE_PATHS`, the `README_release.md` to `README.md`
  rename step, and `tests/release-copy.sh`.
