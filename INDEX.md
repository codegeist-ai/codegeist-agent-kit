# OpenCode Kit Index

Agent-owned navigation map for the shared OpenCode workspace.

## When To Read This

- Read this when starting work in the shared agent kit or when looking for the
  right command, rule, skill, or plugin file.
- In consuming repositories this file is loaded as `.opencode/INDEX.md` through
  `.opencode/opencode.json`.

## Directory Map

- `ai-scripts/` - helper scripts used by shared commands and skills.
- `commands/` - reusable slash-command workflow definitions.
- `rules/` - durable instructions loaded by `opencode.json`.
- `skills/` - specialized workflows that can be loaded on demand.
- `plugin/` - optional Graphify OpenCode integration.
- `opencode.json` - runtime configuration that loads shared instructions,
  plugins, MCP servers, and permissions.
- `README.md` - source-repository overview for maintainers.
- `README_release.md` - source file copied to `README.md` on the generated
  `release` branch.
- `Taskfile.yml` - release-copy, release-build, and smoke-test entrypoints.
- `tests/release-copy.sh` - smoke test for the generated release bundle.

## Known Directory Indexes

- `.opencode/INDEX.md` - this root index in consuming repositories.

## Key Workflows

- Use `task test` after changing release runtime files or release-copy behavior.
- Use `task release-build` only after reviewing `README_release.md` changelog
  updates for consumer-visible changes.
- Use `/update-index <directory>` to create or refresh directory-local indexes.

## Search Hints

- `RELEASE_PATHS` - release bundle source paths in `Taskfile.yml`.
- `/update-index` - command for creating or refreshing directory indexes.
- `directory-index.md` - rule that defines the `INDEX.md` pattern.
- `instructions` - `opencode.json` entries loaded by OpenCode.

## Update Triggers

- Update this file when a new `INDEX.md` is added, moved, or removed.
- Update this file when top-level directories, release paths, or major shared
  entrypoints change.

## Agent Notes

- Keep this index compact because it is loaded into OpenCode instructions.
- Paths in this file should use the consuming repository view when helpful,
  especially `.opencode/...` for released runtime files.
