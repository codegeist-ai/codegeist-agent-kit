# OpenCode Kit Index

Agent-owned navigation map for the shared OpenCode workspace.

## When To Read This

- Read this when starting work in the shared agent kit or when looking for the
  right command, rule, skill, or plugin file.
- In this source repository and consuming repositories, `opencode.json` loads
  this as the repository-root `INDEX.md`.

## Directory Map

- `ai-scripts/` - helper scripts used by shared commands and skills.
- `commands/` - reusable slash-command workflow definitions.
- `rules/` - durable instructions loaded by `opencode.json`.
- `skills/` - specialized workflows that can be loaded on demand.
- `plugin/` - optional Graphify OpenCode integration.
- `opencode.json` - runtime configuration that loads shared instructions,
  plugins, MCP servers, and permissions.
- `playwright-mcp.json` - Playwright MCP browser launch configuration copied
  into the generated release bundle.
- `README.md` - source-repository overview for maintainers.
- `README_release.md` - source file copied to `README.md` on the generated
  `release` branch.
- `Taskfile.yml` - release-copy, release-build, and smoke-test entrypoints.
- `tests/release-copy.sh` - smoke test for the generated release bundle.

## Known Directory Indexes

- `INDEX.md` - this root index in the repository root.

## Key Workflows

- Use `task test` after changing release runtime files or release-copy behavior.
- Use `task release-build` only after reviewing `README_release.md` changelog
  updates for consumer-visible changes.
- Use `/task spec "<title/context>"` and `/task impl <task-ref> [instructions]`
  for tracked task work.
- Use `/update-index <directory>` to create or refresh directory-local indexes.

## Search Hints

- `RELEASE_PATHS` - release bundle source paths in `Taskfile.yml`.
- `playwright-mcp.json` - browser config used by the shared Playwright MCP.
- `/update-index` - command for creating or refreshing directory indexes.
- `spec`, `impl` - task command actions for specification and implementation.
- `directory-index.md` - rule that defines the `INDEX.md` pattern.
- `instructions` - `opencode.json` entries loaded by OpenCode.

## Update Triggers

- Update this file when a new `INDEX.md` is added, moved, or removed.
- Update this file when top-level directories, release paths, or major shared
  entrypoints change.

## Agent Notes

- Keep this index compact because it is loaded into OpenCode instructions.
- Keep this file outside the `.opencode` release submodule. Consuming
  repositories own their root `INDEX.md` content.
