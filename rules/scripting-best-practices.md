# Scripting Best Practices

Guidance for repo-owned automation scripts and shell entrypoints.

## Choose The Smallest Tool

- Prefer existing repo entrypoints and shared helpers over new wrappers.
- Use Bash or POSIX shell for repo entrypoints unless a concrete requirement
  justifies another tool.
- Keep scripts small, explicit, and non-interactive.

## Documentation Lookup

- When unsure about CLI flags or tool behavior, use Context7 or authoritative
  docs before guessing.
- Prefer documented contracts for Docker, git, shell tooling, and repo helpers.

## Paths And Inputs

- Use explicit repo-root or absolute paths for non-trivial scripts.
- Do not rely on caller cwd when the script can resolve its own paths.
- Prefer clear parameters and env vars over hidden defaults.
- If a tool is required for normal repo behavior, install it through the repo's
  normal environment setup and cover it with smoke tests instead of scattering
  `require_cmd` wrappers everywhere.

## Option Parsing And Exec

- For repo shell entrypoints with more than trivial flags, prefer `getopt` or
  `getopts` over hand-rolled parsing loops.
- Keep bootstrap launchers on a straight `getopt` plus handoff path; avoid
  source guards, mount sprawl, or extra argument-rejection branches unless a
  concrete runtime requirement needs them.
- When `set -euo pipefail` already enforces the failure path, avoid redundant
  `if ! ...; then exit 1; fi` wrappers unless they add a clearer user-facing
  error or a real recovery branch.
- Use `exec docker run ... "$cmd"` when the launcher can hand off directly with
  no host-side cleanup, `docker run ... "$cmd"` plus `trap` when the launcher
  must clean up host resources like a temporary socket listener, `exec "$cmd"`
  for direct host-side execution, and `bash -lc` only when the intended
  contract is to run a shell snippet.

## Comments And Logging

- Comments stay in English and explain the script contract, important branches,
  rationale, or sharp edges rather than narrating obvious shell syntax.
- Non-trivial scripts and functions should name related repo-owned Markdown docs
  when those files contain deeper workflow, safety, or operational context. Keep
  a concise local summary beside the relevant code.
- Reuse shared logging or helper libraries when the repo already has them
  instead of creating one-off wrappers.
- Emit meaningful logs at each operation boundary: start, selected non-secret
  inputs or targets, important decisions, externally visible side effects,
  completion summary, and failures with actionable context.
- Prefer stable, line-oriented records with explicit fields such as
  `level=info event=release_copy status=started target=...`. Use JSON when it is
  the established downstream contract.
- When an LLM or automation will inspect output, use stable event names, preserve
  expected-versus-actual values on failures, and include useful paths, counts,
  and result summaries. Avoid spinners, ANSI-only state, and transient progress
  output that cannot be reviewed later.
- Send diagnostic logs to stderr and reserve stdout for the command's documented
  payload when callers may parse it.
- Keep raw `printf` only for exact command output, help text, or
  machine-readable data that must stay unprefixed.
- Do not log every loop iteration or trivial helper call. Log enough operation
  boundaries to reconstruct what ran and why without producing noise.
- Never print secrets or credentials.

## Script Review

- Keep script code short, direct, and easy to scan.
- Prefer the real failure at the call site over defensive boilerplate that does
  not add real user-facing value.
- When scripts run in a defined environment, do not add separate `command -v`
  or similar presence checks for tools that are required anyway.
- Add a pre-check only when it gives a clearer error, safer behavior, or a real
  recovery path.
- Review whether shared helpers should be exported or centralized instead of
  copied across multiple scripts.
- Review whether repo shell scripts use the available shared helpers instead of
  custom status output.
- Review whether the logs make the successful path, selected branches, side
  effects, and failure point understandable without reading the implementation.

## Verification

- Re-run the affected repo script after changing it.
- Prefer short assertions over broad environment dumps.
- Keep output structured, easy to scan, and focused on the contract being
  verified.
