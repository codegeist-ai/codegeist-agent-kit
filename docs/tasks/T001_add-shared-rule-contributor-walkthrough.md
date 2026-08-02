# T001 Add Shared Rule Contributor Walkthrough

Status: open

Public Tracking: pending issue creation

## Goal

Add a beginner-safe documentation walkthrough showing how a contributor can
propose one generic shared rule without editing generated release or consuming
submodule files.

The repository currently explains the ownership boundary and normal check, but
does not provide an end-to-end example of a small shared rule change.

## Acceptance Criteria

- A focused guide follows one fictional rule from the root `rules/` source path
  through any required `opencode.json` registration and release documentation
  decision.
- The guide contrasts a genuinely generic rule with behavior that belongs in a
  consuming repository's `.oc_local/` overlay.
- The example directs contributors to run `task test` and explains that they do
  not publish `release` or update consuming submodules.
- `CONTRIBUTING.md` and `INDEX.md` link the walkthrough without duplicating it.
- The documentation introduces no runtime rule or configuration change.

## Files

- `docs/contributing/shared-rule-walkthrough.md`
- `CONTRIBUTING.md`
- `INDEX.md`

## Non-Goals

- Do not add a real shared rule solely to support the example.
- Do not document maintainer release publication as a contributor step.
- Do not change `.opencode/` or another repository's `.oc_local/` files.

## Verification

- Follow the walkthrough against the current source and release path names.
- Verify every new repository-local link resolves.
- Run `task test`.
- Run `git diff --check`.
