# Add An Automatically Maintained Documentation Index

- **ID:** T005
- **Type:** feature
- **Parent:** none
- **Status:** specified
- **Public Tracking:** https://github.com/codegeist-ai/codegeist-agent-kit/issues/12
- **Tracking Key:** 6f7b2d49-1c8e-4a73-9d05-b2e61f84c390

## Goal

Ensure every repository with a `docs/` directory has a concise, self-contained
`docs/index.html` that OpenCode creates and keeps aligned with the project's
current navigation, commands, and test setup.

## Context

The shared documentation workflows currently maintain Markdown documentation but
do not provide a directly openable project landing page. Users should be able to
open one local HTML file and quickly understand the project, find important
files, run common commands, and start its test workflow.

## Scope

- Define `docs/index.html` as a shared documentation convention for repositories
  that already contain a `docs/` directory.
- Extend `/update-documentation` to create a missing index and refresh stale
  project information.
- Extend `/verify-documentation` to report a missing, stale, broken, or
  file-incompatible index.
- Make `/save` run the documentation refresh after submodule updates and before
  reviewing or staging changes when `docs/` exists.
- Add this repository's own `docs/index.html` as the reference implementation.
- Document and test the shared behavior and release boundary.

## Acceptance Criteria

- `/update-documentation` creates `docs/index.html` when `docs/` exists and the
  file is missing.
- Repositories without a `docs/` directory do not receive a new documentation
  tree automatically.
- The page contains a concise project overview, starting points, important paths,
  documentation links, common commands, setup instructions, and the canonical
  test command when one is documented.
- Project facts are derived from current authoritative repository files and do
  not include invented, aspirational, secret, or machine-specific information.
- The page works when opened directly through `file://`.
- HTML, CSS, content, and JavaScript are self-contained; initial rendering uses
  no fetch requests, module imports, CDNs, external fonts, or required server.
- Core content remains readable without JavaScript.
- JavaScript provides useful progressive enhancement such as local search,
  filtering, or compact section navigation.
- The page is semantic, keyboard-accessible, responsive on desktop and mobile,
  and visually tailored to the project rather than using a generic dashboard.
- Relative links resolve from `docs/index.html` to existing project files.
- Existing graphics may be reused when useful; a compact inline SVG may be added
  when it clarifies project structure without introducing an asset pipeline.
- The source repository page explains the source-to-release-to-consumer model and
  identifies `task test` as the normal non-publishing verification command.
- `docs/index.html` remains excluded from the generated `.opencode` release;
  consumers receive the shared rules and commands that create their own page.
- `task test` and a direct-file browser smoke test pass.

## Files

- `rules/software-documentation.md`
- `rules/README.md`
- `commands/update-documentation.md`
- `commands/verify-documentation.md`
- `commands/save.md`
- `commands/README.md`
- `docs/index.html`
- `README.md`
- `README_release.md`
- `INDEX.md`
- `Taskfile.yml`
- `tests/docs-index.sh`
- `tests/release-copy.sh`

## Non-Goals

- Adding a static-site generator, application framework, package dependency, or
  documentation server.
- Reading repository files dynamically from the browser.
- Deploying the page to GitHub Pages or another hosting service.
- Shipping source-repository documentation in the release bundle.

## Implementation Hints

- Treat "dynamic" as client-side interaction over embedded HTML content; OpenCode
  workflows, not browser-time repository access, refresh the project data.
- Preserve intentional project-specific styling when refreshing an existing
  index instead of replacing it with a universal template.
- Add the `/save` documentation step after `/update-submodules` so it inspects
  the final pre-commit repository state.
- Keep the source page compact and use an inline project-flow diagram only if it
  improves navigation or understanding.

## Verification

```bash
git --no-pager diff --check
task test
```

Open `docs/index.html` directly as a `file://` URL at desktop and mobile viewport
sizes. Verify search or filtering behavior, local links, keyboard navigation,
and the absence of console errors or initial network requests.

## Dependencies

- None.

## Open Questions

None.
