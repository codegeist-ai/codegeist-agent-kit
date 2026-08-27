# OpenCode Kit Index

Agent-owned navigation map for the shared OpenCode workspace.

## When To Read This

- Read this when starting work in the shared agent kit or when looking for the
  right command, rule, or skill file.
- In this source repository and consuming repositories, `opencode.json` loads
  this as the repository-root `INDEX.md`.

## Directory Map

- `ai-scripts/` - helper scripts used by shared commands and skills.
- `commands/` - reusable slash-command workflow definitions.
- `rules/` - durable instructions loaded by `opencode.json`.
- `skills/` - specialized workflows that can be loaded on demand.
- `docs/tasks/` - source-repository task guide and local implementation specs for
  accepted work.
- `.github/workflows/ci.yml` - read-only contributor CI that runs `task test`.
- `opencode.json` - runtime configuration that loads shared instructions,
  MCP servers, and permissions.
- `playwright-mcp.json` - Playwright MCP browser launch configuration copied
  into the generated release bundle.
- `README.md` - source-repository overview for maintainers.
- `CONTRIBUTING.md` - generic-versus-local ownership and source contribution
  workflow.
- `README_release.md` - source file copied to `README.md` on the generated
  `release` branch.
- `LICENSE` - canonical 0BSD license copied into the generated release bundle.
- `Taskfile.yml` - release-copy, release-build, and smoke-test entrypoints.
- `tests/release-copy.sh` - smoke test for the generated release bundle.

## Known Directory Indexes

- `INDEX.md` - this root index in the repository root.

## Key Workflows

- Start source contributions from `main`, keep the local task authoritative, use
  its linked GitHub mirror Issue, and never implement changes in generated
  `release` or `.opencode/` checkouts.
- Use `task test` after changing release runtime files or release-copy behavior.
- Maintainers use `task release-build` only after source review and
  `README_release.md` changelog updates for consumer-visible changes.
- Use `/task spec "<title/context>"` and `/task impl <task-ref> [instructions]`
  for tracked task work; eligible `.opencode` consumers with a GitHub mirror use
  linked Issues, and creating a new Issue requires explicit approval of its exact
  preview.
- Use `/update-index <directory>` to create or refresh directory-local indexes.

## Search Hints

- `RELEASE_PATHS` - release bundle source paths in `Taskfile.yml`.
- `docs/tasks/README.md` - GitHub mirror declaration plus Issue-to-task-to-PR
  linkage and status conventions.
- `LICENSE` - 0BSD terms that must remain in source and release output.
- `playwright-mcp.json` - browser config used by the shared Playwright MCP.
- `/update-index` - command for creating or refreshing directory indexes.
- `GitHub Mirror`, `GH_TOKEN`, `spec`, `impl` - task tracking and implementation
  workflow terms.
- `directory-index.md` - rule that defines the `INDEX.md` pattern.
- `instructions` - `opencode.json` entries loaded by OpenCode.

## Update Triggers

- Update this file when a new `INDEX.md` is added, moved, or removed.
- Update this file when top-level directories, release paths, or major shared
  entrypoints change.

## Agent Notes

- Keep this index compact because it is loaded into OpenCode instructions.
- Keep this file outside the `.opencode` release submodule while keeping
  `LICENSE` in that bundle. Consuming repositories own their root `INDEX.md`
  content.
