# Release Usage For LLM Coding Agents

This repository provides a reusable OpenCode workspace that consuming git
repositories mount as a `.opencode` submodule. It gives an LLM coding agent a
shared set of rules, commands, skills, helper scripts, and OpenCode plugin
configuration while leaving project-specific behavior in the consuming repo.

## What This Submodule Provides

- `opencode.json` loads the shared instructions, MCP servers, plugin files, and
  external-directory permissions expected by OpenCode.
- `opencode.json` can load a repository-root `INDEX.md` owned by the consuming
  repository; the shared `.opencode` submodule does not ship that file.
  Keep project-specific index content outside `.opencode/`.
- `rules/` contains durable agent rules for command execution, commits, tests,
  documentation, memory-bank updates, task workflow, scripting, and related
  engineering practices.
- `commands/` contains reusable slash-command workflows such as `/save`,
  `/commit`, `/learn`, `/update-chat`, `/git-sync`, `/rebase`, `/task`,
  `/update-index`, and `/update-submodules`.
- `skills/` contains targeted reusable workflows, currently `gh-auth`,
  `commit-message-guard`, and `graphify`.
- `ai-scripts/` contains helper scripts used by the commands and skills, such
  as `commit-message-guard.sh`.
- `plugin/` contains Graphify OpenCode integration files. Graphify is optional
  and should only build or update graphs when the user explicitly asks for it.
- `playwright-mcp.json` contains shared browser launch settings used by the
  `playwright` MCP server in `opencode.json`.

The generated `release` branch is intentionally minimal. During release copy,
this source file is renamed from `README_release.md` to `README.md`. The release
branch should contain only runtime files needed by consuming repositories:
`.gitignore`, `README.md`, `opencode.json`, `playwright-mcp.json`,
`ai-scripts/`, `commands/`, `rules/`, `skills/`, and `plugin/`.

## Changelog

### Current Version

- Added a shared `playwright` MCP server that starts `@playwright/mcp@latest`
  through `npx` and loads `.opencode/playwright-mcp.json` for browser launch
  settings.
- Added `.opencode/playwright-mcp.json` to start visible Chrome through the
  `/usr/local/bin/chrome` launcher and suppress
  Playwright's unsupported `--disable-blink-features=AutomationControlled`
  default argument when the installed Chrome build warns about it.
- Consumer action: no repository migration is required for the new MCP server or
  tool-access rule. After updating `.opencode`, restart OpenCode so the updated
  `opencode.json`, `playwright-mcp.json`, and `rules/tools.md` are loaded.
  Playwright browser workflows require `npx` and a `chrome` launcher at
  `/usr/local/bin/chrome` in the runtime environment.
- Added `tools.md` to define Bash and system command access for coding agents:
  built-in OpenCode tools stay preferred for direct file and workflow operations,
  but agents may use any available Bash command, shell script, Python code,
  installed CLI, SSH/OpenSSH utility, or task-appropriate system tool without a
  per-command allowlist. Shell scripts are preferred for command orchestration
  when they fit, while Python is appropriate when it better matches the problem.
- Update notes for coding agents: check for already-installed tools before
  rebuilding equivalent logic; inside a devcontainer, missing packages may be
  installed with `apt-get` without asking first, while package installation
  outside a devcontainer requires user approval.
- Added tool guidance for disposable test repositories and GitHub work: agents
  may freely manipulate repositories or sandboxes created for the current test,
  and may run task-scoped `git` and `gh` commands without asking merely because
  they touch Git or GitHub; direct GitHub state changes still require narrow
  task scope and careful target inspection.
- Added the directory index pattern: agent-owned `INDEX.md` files can now be
  used as compact navigation maps for large directories, with rules for when to
  create, read, and refresh them.
- Added `/update-index` to create or refresh a directory `INDEX.md` with local
  search hints, key files, workflows, and update triggers.
- Added support for a repository-root `INDEX.md` instruction so consuming
  repositories can keep their agent navigation index outside the `.opencode`
  submodule.
- Update notes for coding agents: use the uppercase filename `INDEX.md` for this
  pattern, link related directory indexes when useful, and keep the root
  repository `INDEX.md` list current whenever directory indexes are added, moved,
  or removed.
- Consumer action: keep any project-specific root index at `INDEX.md` in the
  consuming repository root, not inside `.opencode/`. After updating
  `.opencode`, restart OpenCode so the new `INDEX.md` and
  `directory-index.md` instructions are loaded by the running agent session.
- Release safety: the generated `.opencode` release intentionally excludes
  `INDEX.md`. Do not add `.opencode/INDEX.md`; `opencode.json` should keep the
  instruction path as `INDEX.md` so it resolves to the consuming repository root.
- Hardened the shared rules, `/update-index`, release docs, and release smoke
  test so future changes keep `INDEX.md` out of the generated `.opencode`
  submodule while still loading a consumer-owned repository-root `INDEX.md`.
- Replaced the separate task phase commands with one `/task` workflow that uses
  only `spec` and `impl`, so task specification and implementation can repeat
  without juggling separate phase commands.
- Update notes for coding agents: use `/task spec "<title/context>"` to create
  and collaboratively specify a focused task, then use
  `/task impl <task-ref> [instructions]` to implement it. If implementation
  finds missing specification, clarify with the user and update the same task
  before editing runtime files.
- Added a `## Changelog` section to the released `.opencode/README.md` so
  consumer-visible changes and upgrade notes are shipped with each release.
- Removed the source-repository-only `.oc_local/rules/project-release-source.md`
  instruction from the released `opencode.json`; release configuration now
  references only files expected to exist in consuming repositories.
- Added local source-repo guidance for maintaining `README_release.md` and made
  the local release-build workflow require a changelog review before publishing.
- Update notes for coding agents: before running the local release-build command,
  inspect the release-bundle diff, update this changelog with consumer-visible
  changes, and include migration notes when consuming projects need adjustments.
- Consumer action: after updating `.opencode`, no project changes are required
  unless a consuming repository copied the removed `.oc_local` instruction into
  its own OpenCode configuration; remove that local reference if present.

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

## Extending This Agent Kit

A consuming repository can ask its coding agent to add reusable shared behavior
to this agent kit instead of only creating local `.oc_local/` overlays. The
intended command shape is:

```text
/add-agent-kit command|rule|skill <description of the shared behavior>
/add-agent-kit move <explicit .oc_local command, rule, or skill path>
```

This is an upstream change workflow. Do not edit `.opencode/` directly as the
implementation path; it is the generated `release` branch of
`codegeist-agent-kit`, mounted as a submodule. Shared changes belong in a source
checkout of `https://github.com/codegeist-ai/codegeist-agent-kit.git` on `main`.
`README_release.md` is the source file that becomes `.opencode/README.md` in
consuming repositories.

Expected autonomous workflow for the agent:

1. Inspect the consuming repository state and verify that `.opencode` exists,
   is a Git submodule, and is configured to track the `release` branch in
   `.gitmodules`.
2. Clone `https://github.com/codegeist-ai/codegeist-agent-kit.git` into an
   explicit temporary directory outside the consuming repository, for example
   under `/tmp/opencode`, unless the user or local workflow provides a trusted
   source checkout.
3. Implement the requested shared `command`, `rule`, or `skill` in the source
   paths of that temporary checkout: `commands/`, `rules/`, `skills/`,
   `ai-scripts/`, `plugin/`, `opencode.json`, and `README_release.md` as
   applicable. For `move`, start only from the explicitly selected
   `.oc_local/commands/`, `.oc_local/rules/`, or `.oc_local/skills/` overlays
   and rewrite them into repo-agnostic shared form before adding them upstream.
   Do not move whole `.oc_local/` directories or infer extra files that the user
   did not select.
4. Continue only when the change is generic across repositories with unrelated
   domains, products, architectures, and deployment models. Shared additions
   must not encode product-specific services, customer workflows, environment
   names, domain assumptions, branch policies, or repository layouts beyond the
   shared OpenCode workspace contract.
5. If the behavior is specific to the current consuming repository, stop the
   upstream workflow and create or update a local overlay in the consuming
   repository instead. If generic applicability is unclear, ask one short
   clarification question before editing the source checkout.
6. For `move`, remove only the selected original `.oc_local/` overlays after
   the upstream source change is committed, the release branch is built,
   `.opencode` is updated to the new release, and each replacement shared file
   is verified in the updated submodule. Leave all unselected local overlays in
   place.
7. Run the source repository verification, starting with `task test`, and fix
   failures before continuing.
8. Commit the source repository change with a focused Conventional Commit
   message, then push the source branch when the remote is configured and the
   authenticated session has permission.
9. Run `task release-build` in the source repository. This creates and pushes a
   normal commit on the generated `release` branch with only the runtime files
   that consuming repositories mount as `.opencode`, preserving release history
   so the copied changes remain reviewable.
10. Return to the consuming repository and update only the `.opencode` submodule
   to the new `origin/release` commit, using the same safety checks as
   `/update-submodules`: fetch the configured branch, run
   `git checkout -B release origin/release` inside `.opencode`, verify that
   `HEAD` matches `origin/release`, and verify that the submodule status is
   clean.
11. Report the new `.opencode` commit and the parent repository gitlink change.
   If the user requested a full save workflow, commit the parent gitlink update
   in the consuming repository through `/save` or the repo's equivalent commit
   workflow.

Only use direct edits inside `.opencode/` for temporary inspection or debugging;
do not leave them as the implementation path. The agent must not update
unrelated submodules, delete local files inside the consumer checkout, or commit
unrelated parent-repo changes as part of this workflow.

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
- `/task` manages tracked task files under `docs/tasks/` with `spec`, `impl`,
  `cancel`, and `backlog` actions when the repo uses that workflow.
- `/update-index` creates or refreshes an agent-owned directory `INDEX.md` for
  local navigation and search hints.
- `/add-agent-kit` adds reusable shared commands, rules, or skills upstream, or
  moves generic `.oc_local/` overlays into the shared agent kit, then builds a
  new release and updates the consuming repo's `.opencode` submodule.

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

- Keep durable repo-owned docs and comments in English. User conversations may
  use the user's preferred language, but committed project text stays English.
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
release submodule. Maintainers and coding agents must make shared-kit changes in
the source repository on `main`, never directly in a consuming repository's
`.opencode/` submodule checkout. Use the Taskfile instead of hand-building the
release branch.

Run the release smoke test:

```bash
task test
```

Build and push the generated release branch:

```bash
task release-build
```

The `release-build` task creates a temporary worktree, copies only the release
runtime paths, commits them on the release branch, updates the local release
ref, and pushes it without rewriting existing release history. The first release
for a new remote is bootstrapped as an orphan; later releases are normal commits
so maintainers can inspect which runtime changes were published. The working
branch and dirty worktree are left untouched except for the temporary release
worktree cleanup.

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
