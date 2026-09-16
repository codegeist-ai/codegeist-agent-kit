# Local Task Guide

GitHub Mirror: https://github.com/codegeist-ai/codegeist-agent-kit

This directory owns the canonical task specifications and statuses accepted for
this repository. The confirmed GitHub mirror can provide concise public Issues
for discovery and discussion when requested, but an Issue never replaces its
local task file.

## Linkage

```text
Codegeist roadmap -> optional repository Issue -> local task -> branch -> pull request -> merge
```

- The [Codegeist roadmap](https://github.com/users/codegeist-ai/projects/1) gives
  the account-wide view.
- An optional repository
  [Issue](https://github.com/codegeist-ai/codegeist-agent-kit/issues) owns the
  concise public summary, discussion, priority, and assignment when public
  tracking is requested.
- A local task is the source of truth for the implementation goal, acceptance
  criteria, status, file scope, non-goals, and verification.
- Every linked task Issue identifies its canonical local task path, and the
  task's `Public Tracking` field links back with the full Issue URL.
- The implementation branch and pull request link the local task and any linked
  Issue. The pull request reports verification and updates the task status when
  practical.
- Roadmap state remains a public coordination action. `/task` does not mirror
  intermediate local statuses. It closes a validated linked Issue as completed
  before it records that task as `solved`; a task whose public tracking is
  inactive becomes `solved` after local verification. Historical task files
  remain implementation records, not ready work.

Tasks start as `docs/tasks/TNNN_<slug>.md`, using the next numeric ID not present
in current files or Git history. Task IDs are never recycled. Only introduce
nested task directories when a task genuinely needs child tasks. Every top-level
and child task gets one random immutable Tracking Key, but defaults to `Public
Tracking: not requested`. Public tracking can be requested for that task through
a later `/task spec` invocation. Entries in `docs/tasks/backlog.md` are ideas,
not tasks, and do not get Issues.

## Project Eligibility

This repository uses `codegeist-agent-kit` as its initialized `.opencode` Git
submodule, so optional GitHub Issue tracking is available. The workflow checks
eligibility only after a user explicitly requests public tracking or when a task
already contains a full Issue URL. It then verifies the `.gitmodules` path,
gitlink, initialized checkout, runtime files, and credential-free repository
identity before checking the mirror or `GH_TOKEN`.

For an unlinked task whose public tracking is not requested, `/task` does not
inspect project eligibility, GitHub mirrors, Tea, `GH_TOKEN`, or run `gh`.

When public tracking is requested in a project without that `.opencode`
submodule, task files remain local and GitHub CLI does not run through this
workflow. Such tasks use `Public Tracking: not applicable (codegeist-agent-kit
is not mounted at .opencode)`. An existing full Issue URL is never replaced by a
later eligibility or no-mirror result; the task blocks until its public
counterpart can be validated and completed safely.

## Mirror Verification

After public tracking is requested or an Issue URL is already linked, `/task`
checks this file's `GitHub Mirror` declaration before any GitHub access. Use
`GitHub Mirror: none` in repositories without a mirror. The declaration is
authoritative and lets contributors use the public workflow without access to a
separate source forge. When the declaration is absent, one unambiguous root-level
`github.com` remote may be confirmed and recorded; submodule remotes never count.

When no root remote identifies GitHub, `/task` may inspect one unambiguous source
repository's configured push mirrors with the read-only `tea api` command added
in Tea `v0.12.0`. Tea discovery uses only an already configured non-interactive
login, requires repository administrator access on the source forge, and runs
with `GH_TOKEN` removed so the GitHub token cannot be sent to another service.
The raw push-mirror response is never printed or persisted.

During an active public-tracking request, missing Tea capability, login, access,
or an unambiguous result does not prove that no mirror exists. The task remains
`blocked`, preserving an existing Issue URL or using `Public Tracking: pending
GitHub mirror verification` when no link exists, until this file declares
`GitHub Mirror: <URL|none>`. A successful Tea response with no GitHub destination
makes tracking not applicable for that run but does not write `GitHub Mirror:
none`, because manual mirrors and later configuration changes remain possible.

GitHub operations require a valid `GH_TOKEN` in the OpenCode process environment
and force `GH_HOST=github.com`. `GH_TOKEN` is the only supported token environment
variable. The workflow never uses stored GitHub CLI credentials or browser login,
and it never stores or prints the token. A declared mirror must exist, be
unarchived, have Issues enabled, and not be a fork. GitHub's mirror metadata is
not used because manually synchronized mirrors do not reliably populate it.

## Issue Approval

Requesting public tracking and approving an Issue are separate decisions. Before
creating a new Issue, `/task` shows the exact repository, title, and full body,
including its hidden tracking marker. The Issue is created only after the user
explicitly approves that preview in the current conversation. Creating or
specifying the task, or requesting public tracking, is not approval. Approval is
single-use and must be requested again when the preview changes or an earlier
creation attempt fails. Declining or deferring creates no Issue, records `Public
Tracking: not requested (user declined GitHub Issue creation)`, restores the
task's intended local status, and keeps implementation available. Reusing an
existing Issue does not create a new Issue and therefore does not use this
creation gate.

An existing URL still needs a trustworthy canonical link. `/task` rejects pull
requests and Issues linked to another task. If the Issue lacks this task's exact
Tracking Key and bounded canonical-link block, `/task` previews the proposed
block and requires separate explicit, single-use approval before editing the
Issue. A newly supplied exact link authored by another account requires approval
before storage but no body edit. Supplying or storing a URL alone is not
approval. After approved linkage is read back and its URL is stored in the task,
the exact Tracking Key and canonical block make later retries idempotent across
authors.

Immediately before an approved edit, `/task` reads the Issue again and applies
the approved block to that fresh body. It appends only to an unmarked body,
replaces one safely bounded same-task block, and rejects duplicates or ambiguous
material. Private read-back checks all other content. GitHub does not support a
conditional Issue-body update here, so the workflow reports the narrow remaining
race and blocks on any detected mismatch rather than promising atomicity.

## Issue Completion

After `/task impl` verifies a task with a linked Issue, it validates the Issue's
repository, Tracking Key, and canonical-link block again. It closes an open Issue
with reason `completed`, reads the Issue back, and only then records the local
task as `solved`. An Issue already closed as completed is accepted for a safe
retry only when its complete canonical linkage still matches. A close or
read-back failure leaves the task `blocked` with its Issue URL; local verification
does not override an incomplete public handoff.

This completion close does not need a separate preview approval. It is the one
automatic terminal status projection defined by the accepted task workflow.
Labels, projects, readiness, cancellation, and intermediate task statuses remain
outside automatic synchronization.

A task whose public tracking is not requested, declined, or not applicable does
not perform this remote completion step. After its implementation and local
verification pass, `/task impl` records it as `solved`. An unresolved pending
state must be reconciled first, and a full Issue URL can never be removed or
ignored to select this local-only path.

## Public Tracking Values

- `not requested` is the default for a new task and does not trigger eligibility,
  mirror, Tea, token, or GitHub inspection.
- `not requested (user declined GitHub Issue creation)` records an explicit
  opt-out after creation was offered and remains eligible for local
  implementation.
- `pending user approval for GitHub Issue creation` is a known pre-creation state.
  It does not authorize remote access in a later invocation; `/task` asks whether
  to resume tracking or continue locally.
- Any other pending value from an earlier invocation remains blocked until public
  tracking is explicitly resumed and reconciled because an Issue may already
  have been created or changed.
- A not-applicable value records an eligibility or no-mirror result reached after
  tracking was requested and does not block local implementation.
- A full GitHub Issue URL is binding. It must be validated before implementation
  and confirmed closed as completed before the task becomes `solved`.

## Statuses

- `open` - accepted local work that has not entered implementation.
- `specified` - the task is clear enough to implement through `/task impl`.
- `in progress` - implementation is active when the repository records this
  intermediate state.
- `blocked` - implementation cannot proceed until a named dependency or decision
  is resolved.
- `solved` - implementation and verification are complete, and any validated
  linked Issue has been confirmed closed with reason `completed`; review or other
  final handoff can still remain.
- `finalized` - review and required handoff are complete and the task is kept as
  a historical record.
- `cancelled` - the task will not be implemented; the task records why.

Local task status is authoritative but does not make work publicly ready. Public
readiness is coordinated separately through an Issue or Roadmap when used.
Failures during explicitly requested tracking and failures validating or closing
an existing link leave the task `blocked` and retryable. Declining Issue creation
does not block the authoritative local task.

Backlog ideas without accepted scope stay in the repository Issue tracker or
`docs/tasks/backlog.md`; they are not presented as ready implementation tasks.

## Required Task Fields

Each task includes `Status`, `Public Tracking`, a random immutable `Tracking
Key`, `Goal`, `Acceptance Criteria`, `Files`, `Non-Goals`, and `Verification`.
Keep the specification small enough that a contributor can tell when it is
complete. When public tracking is used, the Issue contains only the one-sentence
Goal, canonical task path, source-of-truth notice, and hidden tracking marker.
