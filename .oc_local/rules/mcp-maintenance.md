# MCP Maintenance Check On Save

Check this repository's enabled MCP integrations during every `/save` workflow,
including `/save` invoked by `/release-build`, before creating the save commit.
This is an agent workflow instruction, not an editor file-save hook.

## Check Procedure

- Inspect the effective OpenCode configuration and compare it with source
  `opencode.json`, local overrides, and the consumed `.opencode` release.
  Check every effectively enabled server, not only tools used in the current
  conversation. Identify planned removals and source/release differences.
- Consult current official documentation, package registries, and upstream
  repositories to verify supported package names, endpoints, versions, launch
  options, replacements, and deprecation or archival notices. Follow the normal
  GitHub authentication rules when using `gh`; never expose credentials.
- For pinned packages, compare the configured version with the latest supported
  upstream release and review relevant migration notes. For unpinned packages or
  `@latest`, verify that the package and integration are still maintained;
  a floating version alone is not evidence of maintenance or compatibility.
- For remote services, confirm the official endpoint and available maintenance
  evidence. Do not infer maintenance guarantees, audits, or an SLA from a working
  endpoint or a well-known operator alone.
- Check connectivity with `opencode mcp list` or the equivalent supported
  diagnostic. Distinguish connection failures, rate limits, missing credentials,
  and unavailable research sources from obsolete or unmaintained integrations.
- If one MCP research tool fails, use other available authoritative sources.
  Mark unresolved questions as `not verifiable`; do not invent a successful
  check or treat missing evidence as proof of abandonment.

## Changes And Reporting

- Report a concise result for each enabled server in the save response:
  configured package/version or endpoint, currency and maintenance findings,
  connectivity result, and relevant source links or unresolved evidence.
- Do not create a recurring repository report, timestamp file, or commit merely
  to record a check. An inconclusive check is reported and does not itself block
  saving otherwise verified work.
- Do not automatically upgrade, replace, remove, or reconfigure servers solely
  because of this check. Report actionable findings and obtain user direction
  unless the current request already authorizes that specific change.
- Keep shared configuration fixes in source paths and propagate them through the
  release workflow. Explain when a consumed release still contains an integration
  already removed from source. Restart OpenCode after configuration updates.
