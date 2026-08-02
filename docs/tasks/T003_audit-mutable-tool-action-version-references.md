# T003 Audit Mutable Tool And Action Version References

Status: open

Public Tracking: pending issue creation

Contribution Level: intermediate

Effort: medium

## Goal

Audit executable tool, action, and package references that currently resolve
through mutable or unversioned identifiers, then introduce focused reproducible
pins where they improve contributor CI or released workspace stability without
changing runtime behavior.

Contributor CI actions and Task are pinned to immutable or exact versions, but
released MCP commands still include references such as `@latest` or unversioned
package names. The repository has no complete inventory, documented exception
list, or deterministic check for newly added mutable executable references.

## Acceptance Criteria

- A concise inventory covers executable references in
  `.github/workflows/ci.yml` and released `opencode.json`, including GitHub
  Actions, `npx`, and `uvx` package inputs.
- Every audited reference is either changed to a focused reproducible pin or
  recorded as an intentional exception with a concrete compatibility reason.
- Existing immutable GitHub Action SHAs and the exact Task version remain
  documented by the audit; package references selected for pinning use exact
  versions supported by their upstream tools.
- A deterministic repository test rejects new unreviewed mutable executable
  references and verifies the explicit exception set without network access.
- Existing CI, MCP command shape, Playwright browser settings, and release
  bundle behavior remain functionally unchanged.
- Consumer-visible pin changes and update implications are recorded in
  `README_release.md`; source-only audit detail stays in source documentation.

## Files

- `.github/workflows/ci.yml`
- `opencode.json`
- `tests/` for focused deterministic validation
- `Taskfile.yml` only if the existing `task test` entrypoint needs wiring
- `README_release.md` for consumer-visible changes
- A small source audit document under `docs/` only if rationale does not fit the
  test allowlist clearly

## Non-Goals

- Do not add an automatic dependency updater or broad lockfile system.
- Do not upgrade tools solely because a newer version exists.
- Do not change MCP capabilities, browser behavior, permissions, or provider
  configuration.
- Do not require network access during `task test`.
- Do not build or publish `release`, update consuming gitlinks, or edit nested
  submodules.

## Verification

- Run the focused mutable-reference inventory and exception assertions.
- Parse `.github/workflows/ci.yml` and `opencode.json`.
- Run `task test`.
- Run `git diff --check`.
