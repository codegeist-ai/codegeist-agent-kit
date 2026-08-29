# Release Usage For LLM Coding Agents

This repository provides a reusable OpenCode workspace that consuming git
repositories mount as a `.opencode` submodule. It gives an LLM coding agent a
shared set of rules, commands, skills, helper scripts, and OpenCode runtime
configuration while leaving project-specific behavior in the consuming repo.

## What This Submodule Provides

- `opencode.json` loads the shared instructions, MCP servers, and
  external-directory permissions expected by OpenCode.
- `opencode.json` can load a repository-root `INDEX.md` owned by the consuming
  repository; the shared `.opencode` submodule does not ship that file.
  Keep project-specific index content outside `.opencode/`.
- `rules/` contains durable agent rules for command execution, commits, tests,
  documentation, task workflow, scripting, and related engineering practices.
- `commands/` contains reusable slash-command workflows such as `/save`,
  `/commit`, `/learn`, `/git-sync`, `/rebase`, `/task`, `/update-index`, and
  `/update-submodules`.
- `skills/` contains targeted reusable workflows, currently
  `commit-message-guard`.
- `ai-scripts/` contains helper scripts used by the commands and skills, such
  as `commit-message-guard.sh`.
- `playwright-mcp.json` contains shared browser launch settings used by the
  `playwright` MCP server in `opencode.json`.
- `LICENSE` carries the Zero-Clause BSD terms for Codegeist-owned material in
  this distribution.

The generated `release` branch is intentionally minimal. During release copy,
this source file is renamed from `README_release.md` to `README.md`. The release
branch should contain only runtime files needed by consuming repositories:
`.gitignore`, `LICENSE`, `README.md`, `opencode.json`, `playwright-mcp.json`,
`ai-scripts/`, `commands/`, `rules/`, and `skills/`.

## Changelog

### Current Version

- Added a shared temporary-storage rule for consuming repositories. New
  disposable artifacts belong under the workspace `.tmp/` link when available,
  or another operating-system temporary directory outside the repository;
  persistent non-test secrets belong under ignored `.codegeist/secrets/`.
- Consumer action: devcontainer-kit workspaces create `.tmp` and
  `.codegeist/secrets/` automatically after their runtime kit is updated. Other
  consumers should provide equivalent ignored paths when they adopt this
  convention. Existing temporary and secret paths are not migrated.
- Extended `/task spec` so every project that mounts `codegeist-agent-kit` as an
  initialized `.opencode` Git submodule gets one concise Issue per top-level or
  child task after its GitHub mirror is confirmed and the user explicitly
  approves the exact repository, title, and complete body preview. A task request
  is not approval; declined or deferred approval creates no Issue and leaves the
  task blocked. Backlog entries and ineligible repositories remain local, and
  repositories without a mirror do not require GitHub access.
- Added an optional Tea `v0.12.0` push-mirror discovery fallback for eligible
  repositories without a mirror declaration or GitHub root remote. Unknown or
  inaccessible results block public tracking until the repository declares
  `GitHub Mirror: <URL|none>`; Tea runs without `GH_TOKEN` and never starts login
  setup or exposes the raw source-forge response.
- Kept each local task file authoritative for scope, acceptance criteria, status,
  files, and verification. The linked Issue contains only the Goal, canonical
  task path, and source-of-truth notice. `/task` does not synchronize labels,
  projects, readiness, cancellation, or intermediate statuses, but it closes a
  validated linked Issue as completed before persisting local status `solved`.
- Preserved existing Issue URLs across later eligibility and no-mirror results,
  preventing a linked task from bypassing completion closure. Existing Issues
  that are unmarked or incomplete require an approved linkage edit, newly
  supplied exact cross-author links require approval before storage, and pull
  requests are rejected.
- Consumer action: declare `GitHub Mirror: <URL|none>` in `docs/tasks/README.md`
  when contributors cannot inspect the source repository's configured push
  mirrors. A declaration keeps Tea optional and prevents an unknown mirror from
  blocking task tracking.
- Update notes for coding agents: existing task files do not require a bulk
  migration. After updating `.opencode` and restarting OpenCode, let the next
  `/task spec` or `/task impl` repair missing `Public Tracking` and immutable
  `Tracking Key` fields. Do not create Issues without exact preview approval or
  mark a linked task `solved` before completed closure is verified.
- Replaced interactive GitHub CLI authentication with the `GH_TOKEN` environment
  variable and removed the shared `gh-auth` skill. Shared workflows no longer
  use `gh auth login`, `gh auth status`, stored GitHub CLI credentials, or any
  token environment variable other than `GH_TOKEN`, and every `gh` invocation
  forces `GH_HOST=github.com`.
- Consumer action: provide a valid `GH_TOKEN` to the OpenCode process before any
  workflow that runs `gh`, then restart OpenCode after updating `.opencode` or
  changing its environment. The token needs repository metadata read access and
  permissions for the requested GitHub mutation; never commit it to the repo.
- Removed the shared `/memory-bank` and `/update-chat` commands together with
  the `chat.md` and `memory-bank.md` instructions. Shared workflows no longer
  read or update `docs/memory-bank/chat.md`; `/learn` continues to capture
  durable guidance in rule files.
- Consumer action: after updating `.opencode`, restart OpenCode so the removed
  instructions and commands leave the active configuration. Consumer-owned
  files under `docs/memory-bank/` are not part of the submodule update and can be
  removed separately when no repo-local workflow still uses them.
- Changed `/task impl` to record successfully verified work as `solved` instead
  of `implemented`, aligning generated task updates with the documented local
  task lifecycle.
- Added the canonical `0BSD` `LICENSE` to generated release bundles so the
  distributed Codegeist-owned runtime content carries its license. No consumer
  action is required beyond receiving a future submodule update.
- Removed the shared `repomix` MCP server while keeping the Repomix CLI
  available as a standalone analysis tool.
- Consumer action: after updating `.opencode`, restart OpenCode. Workflows that
  relied on Repomix MCP tools must use the CLI or a repo-local MCP configuration;
  standalone Repomix CLI usage is unchanged.
- Expanded AI-ready source guidance so non-trivial modules, classes, functions,
  and blocks carry contract-level comments or docstrings and may link to focused
  repo-owned Markdown documentation for deeper context.
- Added operation-boundary logging guidance for scripts and source code, with
  stable structured events, separate diagnostic and payload streams, and
  explicit requirements for output evaluated by LLMs or automation.
- Consumer action: after updating `.opencode`, restart OpenCode so coding agents
  load the new reviewability rules. No repository migration is required; apply
  the comment, documentation, and logging contract when creating or changing
  non-trivial behavior.
- Moved Playwright MCP snapshots, console logs, screenshots, and related output
  under the workspace-local ignored `.chrome/playwright-mcp/` directory instead
  of creating `.playwright-mcp/` at the workspace root.
- Removed the Graphify OpenCode plugin, instruction, and skill from the shared
  runtime bundle.
- Consumer action: after updating `.opencode`, restart OpenCode. Consumers that
  relied on Graphify must move that behavior to a repo-local overlay or external
  tool; consumers that did not use Graphify require no migration.
- Explicitly pass Playwright MCP's `--sandbox` CLI override in addition to the
  browser launch option so current `@playwright/mcp@latest` releases no longer
  add the unsupported `--no-sandbox` Chrome argument during config merging.
- Clarified `/save` branch behavior: when a local base branch is resolved, the
  workflow refreshes that local base branch from its configured upstream before
  using it as a rebase base. Base-branch saves can then push the base branch with
  a normal non-force push.
- Clarified `/save` feature-branch behavior: the current branch is rebased over
  its own upstream when needed, then rebased onto the refreshed local base branch,
  and only the current branch is pushed. The feature-branch path must not merge,
  fast-forward, push, or force-push the local base branch.
- Kept the narrow `/save` safety rule for rebased feature branches: use
  `--force-with-lease` only for the current non-base branch after fetching its
  upstream, and only when a rebase rewrote commits already present upstream.
- Added a shared `playwright` MCP server that starts `@playwright/mcp@latest`
  through `npx` and loads `.opencode/playwright-mcp.json` for browser launch
  settings.
- Added `.opencode/playwright-mcp.json` to start visible Chrome through the
  `/usr/local/bin/chrome` launcher and suppress
  Playwright's unsupported `--disable-blink-features=AutomationControlled`
  default argument when the installed Chrome build warns about it.
- Configured the shared Playwright MCP server with
  `PLAYWRIGHT_MCP_USER_DATA_DIR=.chrome` so it uses the consuming repository's
  workspace-local ignored Chrome profile instead of the removed
  `/mnt/codegeist/chrome-cdp-profile` mount.
- Updated `/add-agent-kit` to accept `config` as a shared upstream target for
  repo-agnostic OpenCode configuration changes such as `opencode.json` and
  `playwright-mcp.json` updates.
- Updated `/add-agent-kit` guidance to use a unique user-owned temporary source
  checkout path created with `mktemp` instead of the fixed `/tmp/opencode` path,
  which can be root-owned and unwritable in shared devcontainer environments.
- Consumer action: no repository migration is required for the new MCP server or
  tool-access rule. After updating `.opencode`, restart OpenCode so the updated
  `opencode.json`, `playwright-mcp.json`, and `rules/tools.md` are loaded.
  Playwright browser workflows require `npx` and a `chrome` launcher at
  `/usr/local/bin/chrome` in the runtime environment. No `/mnt/codegeist` mount
  is required; browser profile state is kept under `.chrome/` in the opened
  workspace and should stay ignored by Git.
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
- repo-owned docs such as `docs/tasks/`

Do not add product-specific deployment steps, architecture assumptions, branch
names, or planning rules to the shared `.opencode` submodule unless they are
intended to apply across all consuming repositories.

## Contributing Upstream

This checkout is generated distribution content. Propose generic shared
OpenCode behavior in the
[`codegeist-agent-kit` source repository](https://github.com/codegeist-ai/codegeist-agent-kit)
from a topic branch based on source `main`; do not implement it on `release` or
inside a consuming `.opencode/` checkout. Project-specific behavior belongs in
the consuming repository's `.oc_local/` overlay.

Use the source repository's
[contribution guide](https://github.com/codegeist-ai/codegeist-agent-kit/blob/main/CONTRIBUTING.md),
[Issues](https://github.com/codegeist-ai/codegeist-agent-kit/issues),
[local task guide](https://github.com/codegeist-ai/codegeist-agent-kit/blob/main/docs/tasks/README.md),
and the [Codegeist roadmap](https://github.com/users/codegeist-ai/projects/1).
These links deliberately target source `main`; contributor docs and local task
specifications are not files in this generated release bundle.
The effective shared policies are the Codegeist
[contribution policy](https://github.com/codegeist-ai/.github/blob/main/CONTRIBUTING.md),
[Code of Conduct](https://github.com/codegeist-ai/.github/blob/main/CODE_OF_CONDUCT.md),
[security policy](https://github.com/codegeist-ai/.github/blob/main/SECURITY.md),
and [support guide](https://github.com/codegeist-ai/.github/blob/main/SUPPORT.md).
The distributed files are licensed under [0BSD](LICENSE).

The canonical source check is:

```bash
task test
```

It validates a temporary release copy without publishing. Release publication
is maintainer-only after source review.

## Extending This Agent Kit

A consuming repository can ask its coding agent to add reusable shared behavior
to this agent kit instead of only creating local `.oc_local/` overlays. The
intended command shape is:

```text
/add-agent-kit command|rule|skill|config <description of the shared behavior>
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
   explicit user-owned temporary directory outside the consuming repository,
   unless the user or local workflow provides a trusted source checkout. Prefer
   a unique directory created with `mktemp -d "${TMPDIR:-/tmp}/opencode-agent-kit.XXXXXX"`;
   do not rely on a fixed `/tmp/opencode` path because shared environments may
   create it as root-owned and unwritable to the workspace user.
3. Implement the requested shared `command`, `rule`, `skill`, or `config` in the
   source paths of that temporary checkout: `commands/`, `rules/`, `skills/`,
   `ai-scripts/`, `opencode.json`, `playwright-mcp.json`, and
   `README_release.md` as applicable. For `move`, start only from the explicitly
   selected
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

1. Read relevant shared rules under `.opencode/rules/` and any local overlays
   under `.oc_local/rules/`.
2. Inspect the affected repository files directly before making assumptions.
3. Prefer repo-local commands and overlays when they define a more specific
   workflow than the shared default.
4. Treat `.opencode` as a submodule gitlink, not as ordinary parent-repo files.

## High-Value Commands For Git Work

- `/save` learns durable guidance, updates shared submodules, commits, rebases,
  and pushes the intended branch. On the local base branch it may push that base
  branch; on a feature branch it updates the base branch from upstream first,
  then pushes only the current branch.
- `/commit` reviews the diff and creates a focused conventional commit.
- `/git-sync` synchronizes the current branch and local base branch without
  creating a commit.
- `/rebase` rebases the current branch onto the local base branch.
- `/learn` captures durable workflow guidance in rule files.
- `/session-title` creates a short session title from the current branch and
  recent result.
- `/task` manages authoritative task files under `docs/tasks/` with `spec`,
  `impl`, `cancel`, and `backlog`. In projects that mount this kit as `.opencode`
  and have a confirmed GitHub mirror, each top-level or child task gets one
  concise Issue through `GH_TOKEN` only after the user approves its exact
  preview. Verified implementation closes that Issue as completed before the
  task becomes `solved`; backlog entries do not.
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

Every GitHub CLI workflow requires `GH_TOKEN` in the OpenCode process
environment. Check its presence and validity without printing it, and disable
interactive prompts:

```bash
test -n "${GH_TOKEN:-}" && \
  GH_HOST=github.com GH_PROMPT_DISABLED=1 gh api user >/dev/null
```

`GH_TOKEN` is the only supported token environment variable. Do not use stored
GitHub CLI credentials, `gh auth login`, or a browser flow. Do not ask the user
to paste the token into chat or print, inspect, or persist its value. If
`GH_TOKEN` is missing or invalid, stop the GitHub operation and report the
non-secret failure.

## Documentation And Local Rules

- Keep durable repo-owned docs and comments in English. User conversations may
  use the user's preferred language, but committed project text stays English.
- Update docs in the same task when behavior changes.
- Use `/learn` for reusable guidance that should become a durable rule.
- Prefer updating an existing rule over adding broad or duplicative guidance.

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
