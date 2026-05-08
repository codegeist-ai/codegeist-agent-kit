# Project Release Source

This repository is the source project used to build the generated OpenCode
release that consuming repositories mount at `.opencode/`.

## Source Of Truth

- Edit shared source files in the repository root, not in `.opencode/`.
- Shared rules belong in `rules/`.
- Shared commands belong in `commands/`.
- Shared skills belong in `skills/`.
- Shared helper scripts belong in `ai-scripts/`.
- Shared plugin source belongs in `plugin/`.
- Release documentation source belongs in `README_release.md` when it is meant
  to become `.opencode/README.md` in consuming repositories.

## Generated Release Path

- Treat `.opencode/` in this repo as the generated or consumed release state,
  not as the primary editing location for shared files.
- Do not add or update `.opencode/rules/*`, `.opencode/commands/*`,
  `.opencode/skills/*`, or `.opencode/ai-scripts/*` unless the task explicitly
  targets the release/submodule state.
- When a shared rule, command, skill, script, or plugin changes, make the source
  change in the matching root directory and let the release workflow propagate
  it to `.opencode/`.

## Config Path Sharp Edge

- The root `opencode.json` intentionally references `.opencode/...` paths
  because those paths are correct after this project is released into consuming
  repositories as a `.opencode` submodule.
- A new shared rule normally needs both the root source file, for example
  `rules/example.md`, and a root `opencode.json` instruction entry pointing to
  `.opencode/rules/example.md`.
- Local development-only guidance for this source repo belongs under
  `.oc_local/rules/` and may be referenced directly from root `opencode.json`.

## Before Editing

- If a path exists both at the repository root and under `.opencode/`, prefer
  the root path unless the user explicitly asks for `.opencode/` release-state
  changes.
- Check the root directory layout before creating new OpenCode rules or
  workflow files.
