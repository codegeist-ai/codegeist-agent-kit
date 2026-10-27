# Project Release Source

This repository is the source project used to build the generated OpenCode
release that consuming repositories mount at `.opencode/`.

## Source Of Truth

- Edit shared source files in the repository root, not in `.opencode/`.
- Shared rules belong in `rules/`.
- Shared commands belong in `commands/`.
- Shared skills belong in `skills/`.
- Shared helper scripts belong in `ai-scripts/`.
- Shared MCP runtime config belongs in root release paths such as
  `playwright-mcp.json` when `opencode.json` references it.
- Release documentation source belongs in `README_release.md` when it is meant
  to become `.opencode/README.md` in consuming repositories.

## Generated Release Path

- Treat `.opencode/` in this repo as the generated or consumed release state,
  not as the primary editing location for shared files.
- Do not add or update `.opencode/rules/*`, `.opencode/commands/*`,
  `.opencode/skills/*`, or `.opencode/ai-scripts/*` unless the task explicitly
  targets the release/submodule state.
- When a shared rule, command, skill, or script changes, make the source
  change in the matching root directory and let the release workflow propagate
  it to `.opencode/`.

## Config Path Sharp Edge

- The root `opencode.json` intentionally references `.opencode/...` paths
  because those paths are correct after this project is released into consuming
  repositories as a `.opencode` submodule.
- Add new shared rules directly under `rules/`, for example `rules/example.md`.
  The `.opencode/rules/*.md` instruction glob includes every Markdown file in
  that directory after release; no individual config entry is needed.
- Local development-only guidance for this source repo belongs under
  `.oc_local/rules/` and must not be referenced from root `opencode.json`,
  because that file is copied into the generated release.
- Load these local rules through `.oc_local/opencode.json`, whose `instructions`
  include the project-relative `.oc_local/rules/*.md` pattern.
- Set `OPENCODE_CONFIG_DIR` to `<repository-root>/.oc_local`, as the devcontainer
  already does. The variable selects the config directory but does not load
  Markdown rules by itself. Quit and restart OpenCode after changing the config.

## Before Editing

- If a path exists both at the repository root and under `.opencode/`, prefer
  the root path unless the user explicitly asks for `.opencode/` release-state
  changes.
- Check the root directory layout before creating new OpenCode rules or
  workflow files.

## Internal Git Authentication

- Follow `@.oc_local/rules/gitea-git.md` for internal `origin` fetch, pull, and
  push operations. That focused rule owns Tea login setup, `GITEA_TOKEN`
  handling, repository-local TLS configuration, credential-helper ordering, and
  failure diagnosis.

## Public Documentation Boundary

- Keep public source and release documentation focused on workflows and resources
  that GitHub contributors can access.
- Avoid naming internal repository hosts or linking internal repositories unless
  that detail is technically required for the documented operation.
- When an internal source distinction matters, describe it minimally as an
  internal source repository without exposing inaccessible URLs or unrelated
  hosting details.
