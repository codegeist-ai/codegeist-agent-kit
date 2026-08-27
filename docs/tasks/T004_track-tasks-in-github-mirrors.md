# Track Tasks In GitHub Mirrors

- **ID:** T004
- **Type:** feature
- **Parent:** none
- **Status:** solved
- **Public Tracking:** https://github.com/codegeist-ai/codegeist-agent-kit/issues/10
- **Tracking Key:** df06bc98-76ae-4abc-a070-a6afcd71e060

## Goal

Create one concise GitHub Issue for every repository task when the repository
mounts `codegeist-agent-kit` as `.opencode` and declares or exposes a confirmed
GitHub mirror, then close that Issue before the verified local task becomes
`solved`, while keeping the local task file as the source of truth.

## Context

The shared `/task` workflow currently creates only local task files. GitHub CLI
authentication also depends on an interactive `gh-auth` skill. The workflow
must instead discover and verify a GitHub mirror before any GitHub operation and
must use only the `GH_TOKEN` environment variable for non-interactive access.
Repositories can use the kit without having a GitHub mirror, so missing mirror
information must not be inferred from kit eligibility alone. A source forge may
expose configured push mirrors through Tea, but that endpoint can require
administrator access and must never receive the GitHub token.

## Scope

- Verify that the repository uses `codegeist-agent-kit` as an initialized
  `.opencode` Git submodule before any mirror or GitHub access.
- Declare a canonical GitHub mirror in the repository task guide, with a single
  root-level GitHub remote as the fallback discovery mechanism.
- Use Tea's read-only push-mirror API as a final discovery fallback when no
  declaration or GitHub root remote exists, and block unknown results rather than
  assuming that a mirror is absent.
- Verify a mirror through the GitHub API before creating an Issue.
- Require `GH_TOKEN` as the only supported GitHub token environment variable,
  without using browser login or stored credentials.
- Create or reuse one Issue for every top-level and child task.
- Keep backlog entries local and exclude them from Issue creation.
- Keep the Issue concise and store its full URL in `Public Tracking`.
- Require explicit user approval of the exact repository, title, and full body
  preview immediately before every new Issue creation attempt.
- Preserve blocked local tasks when mirror verification or Issue creation fails.
- Close a validated linked Issue with reason `completed` and confirm the remote
  state before persisting local status `solved`.
- Remove the shared `gh-auth` skill and update affected documentation and tests.

## Acceptance Criteria

- The shared Issue workflow applies automatically to every project that mounts
  `codegeist-agent-kit` at `.opencode` and has a confirmed GitHub mirror.
- Repositories without the qualifying `.opencode` submodule keep tasks local and
  perform no GitHub access through `/task`.
- `/task spec` checks for a GitHub mirror before requiring GitHub access.
- Missing or inaccessible Tea discovery leaves tracking blocked until the task
  guide declares `GitHub Mirror: <URL|none>`.
- Tea push-mirror discovery removes `GH_TOKEN` from its process and never prints
  or persists the raw API response.
- A declared mirror is confirmed with `gh repo view` using `GH_TOKEN` before an
  Issue is created.
- Every top-level or child task for a confirmed mirror has exactly one Issue.
- The Issue identifies the canonical task path and states that the task file is
  the source of truth.
- No new Issue is created until the user explicitly approves its exact preview;
  declined or deferred approval leaves the task blocked.
- Missing or invalid GitHub access leaves the task blocked and retryable without
  creating duplicate Issues.
- `/task impl` closes a validated linked Issue as completed after verification
  and writes `solved` only after the closed state is confirmed.
- Failed Issue closure or read-back leaves the verified task blocked and
  retryable without repeating implementation side effects.
- Existing Issue URLs survive later eligibility or no-mirror results and cannot
  be downgraded to not-applicable tracking to bypass completion closure.
- Pull-request URLs are rejected. Unmarked or incomplete Issues require an
  approved linkage edit, while a newly supplied exact cross-author link requires
  approval before storage without rewriting its body.
- Repositories without a GitHub mirror continue with local tasks only.
- No runtime workflow invokes `gh auth login`, uses the removed `gh-auth` skill,
  or falls back to another token variable.
- Release documentation explains the consumer migration to `GH_TOKEN`.
- `task test` passes without making live GitHub requests.

## Files

- `commands/task.md`
- `commands/add-agent-kit.md`
- `rules/task-workflow.md`
- `rules/command-execution.md`
- `rules/tools.md`
- `rules/devcontainer-tools.md`
- `skills/gh-auth/SKILL.md`
- `docs/tasks/README.md`
- `docs/tasks/template.md`
- `CONTRIBUTING.md`
- `README.md`
- `README_release.md`
- `commands/README.md`
- `rules/README.md`
- `INDEX.md`
- `tests/release-copy.sh`

## Non-Goals

- Synchronizing labels, projects, readiness, cancellation, or intermediate task
  statuses to GitHub.
- Creating Issues for `docs/tasks/backlog.md` entries.
- Storing or generating GitHub tokens.
- Creating live GitHub test Issues in CI.
- Treating GitHub's `isMirror` or `mirrorUrl` metadata as authoritative, because
  manually synchronized mirrors do not reliably populate those fields.

## Implementation Hints

- Use `GitHub Mirror: <URL|none>` in `docs/tasks/README.md` as the durable
  declaration.
- Use `GH_PROMPT_DISABLED=1` for all GitHub CLI calls.
- Force `GH_HOST=github.com` for every GitHub CLI call.
- Check that `GH_TOKEN` is non-empty before invoking `gh`; never print it.
- Generate one random `Tracking Key` per task and use it in the Issue marker.
- Search every page of open and closed Issues before creating a replacement
  during retries.
- Treat approval as single-use and request it again after any preview change or
  failed Issue creation attempt.
- Use `env -u GH_TOKEN` or an equivalent environment scrub for every Tea API
  request so Tea cannot reuse the GitHub token for the source forge.
- Close an open linked Issue with `--reason completed`, read it back, and update
  local status last so `solved` never points to an open Issue.
- Capture paginated Issue and push-mirror responses without exposing unmatched
  bodies, remote addresses, credentials, or source-forge diagnostics.

## Verification

```bash
git --no-pager diff --check
task test
```

Both commands pass. The release smoke test verifies the generated bundle's
mirror discovery, token isolation, Issue approval, linkage idempotency, and
close-before-solved contracts without making live GitHub or Tea requests. The
linked Issue was separately read back as closed with reason `completed` and its
complete canonical linkage revalidated.

## Implementation Notes

- GitHub Issue #10 is linked with this task's immutable Tracking Key and current
  canonical path, and is closed with reason `completed` after final verification.
- The workflow validates an explicit GitHub.com mirror, never persists raw
  credential-bearing remote URLs, and blocks rather than guessing on ambiguous
  or failed linkage.
- Project eligibility is established from the `.opencode` gitlink, initialized
  submodule, runtime files, and credential-free kit repository identity without
  exposing a source host.
- Marker-only Issue discovery requires the active author, Tracking Key, task id,
  and bounded canonical-link block to match. A previously approved and stored URL
  with exact linkage remains reusable across authors. A post-create lookup
  detects concurrent duplicate creation before the Issue URL is persisted.
- New Issue creation requires explicit user approval after the complete preview;
  task creation itself never implies approval.
- Runtime behavior remains prompt-driven; smoke tests enforce the released
  command contract textually rather than making live GitHub calls.
- A missing or inaccessible Tea fallback leaves mirror tracking blocked; an
  explicit task-guide declaration avoids requiring source-forge access.
- The linked Issue is closed and read back before local status becomes `solved`;
  closure failure preserves the Issue URL and a retryable blocked task.
- Existing links cannot be erased by later eligibility or mirror discovery, and
  adoption of an unmarked or incomplete Issue requires approval before a remote
  edit. A newly supplied exact cross-author link requires approval but no edit;
  once validated and stored, it remains reusable across authors.
- Approved adoption applies its block to a fresh pre-edit body and verifies that
  all non-canonical content survives read-back. GitHub provides no conditional
  body update, so the final race window is reported rather than described as
  atomic. Completion read-back revalidates the complete linkage as well as closed
  state and reason.

## Dependencies

- A valid `GH_TOKEN` with repository metadata read access and Issue write access
  is required for live Issue creation and completion closure.
- Tea `v0.12.0` or newer plus an existing source-forge login with repository
  administrator access is required only for undeclared push-mirror discovery.
  A `GitHub Mirror: <URL|none>` declaration avoids this dependency.
- The Codegeist account policy must be updated separately because it currently
  describes some GitHub mirrors as not using GitHub Issues.

## Open Questions

None.
