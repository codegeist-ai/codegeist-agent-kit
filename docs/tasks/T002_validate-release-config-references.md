# T002 Validate Release Config References

Status: open

Public Tracking: pending issue creation

## Goal

Add deterministic structural validation that catches repository-owned file
references in released OpenCode configuration when their target is missing from
the generated bundle.

The current release test checks selected known references but does not validate
the complete configured reference set.

## Acceptance Criteria

- `task test` validates every repository-owned path referenced by released
  `opencode.json` against the copied bundle, including instruction entries,
  plugin entries, and file arguments embedded in MCP command arrays such as
  `.opencode/playwright-mcp.json`.
- The validation maps `.opencode/...` runtime paths to bundle-relative paths and
  explicitly permits documented non-bundle references such as the
  consumer-owned root `INDEX.md`.
- A missing target fails with the configuration value and expected bundle path
  in the error message.
- Focused regression coverage proves a valid bundle plus missing-target failures
  from a top-level list and an MCP command argument without network access or
  Git writes.
- Existing release manifest and `INDEX.md` exclusion assertions continue to
  pass.

## Files

- `tests/release-copy.sh`
- `tests/` for a focused helper or fixture only if needed
- `Taskfile.yml` only if the test entrypoint needs wiring

## Non-Goals

- Do not add a full OpenCode JSON schema validator.
- Do not fetch remote MCP, plugin, action, or package references.
- Do not change runtime configuration merely to make validation simpler.
- Do not build or publish the generated `release` branch.

## Verification

- Run the focused valid and missing-target assertions.
- Run `task test`.
- Run `git diff --check`.
