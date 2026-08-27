# Local Task Guide

GitHub Mirror: https://github.com/codegeist-ai/codegeist-agent-kit

This directory owns the canonical task specifications and statuses accepted for
this repository. The confirmed GitHub mirror provides concise public Issues for
discovery and discussion, but an Issue never replaces its local task file.

## Linkage

```text
Codegeist roadmap -> repository Issue -> local task -> branch -> pull request -> merge
```

- The [Codegeist roadmap](https://github.com/users/codegeist-ai/projects/1) gives
  the account-wide view.
- A repository [Issue](https://github.com/codegeist-ai/codegeist-agent-kit/issues)
  owns the concise public summary, discussion, priority, and assignment.
- A local task is the source of truth for the implementation goal, acceptance
  criteria, status, file scope, non-goals, and verification.
- Every task Issue links its canonical local task path, and the task's `Public
  Tracking` field links back with the full Issue URL.
- The implementation branch and pull request link both the Issue and task. The
  pull request reports verification and updates the task status when practical.
- Roadmap state remains a public coordination action. `/task` does not mirror
  intermediate local statuses, but it closes a validated linked Issue as
  completed before it records the canonical task as `solved`. Historical task
  files remain implementation records, not ready work.

Tasks start as `docs/tasks/TNNN_<slug>.md`, using the next numeric ID not present
in current files or Git history. Task IDs are never recycled. Only introduce
nested task directories when a task genuinely needs child tasks. Every top-level
and child task gets its own Issue when the declared mirror is confirmed and the
user approves its exact preview. Entries in `docs/tasks/backlog.md` are ideas,
not tasks, and do not get Issues.

## Project Eligibility

This repository uses `codegeist-agent-kit` as its initialized `.opencode` Git
submodule, so the shared GitHub Issue workflow applies. The released workflow
applies automatically to every consuming project with the same `.opencode`
submodule contract and a confirmed GitHub mirror. It verifies the `.gitmodules`
path, gitlink, initialized checkout, runtime files, and credential-free
repository identity before checking the mirror or `GH_TOKEN`.

Projects without that `.opencode` submodule keep task files local and do not run
GitHub CLI operations through this workflow. Their tasks use `Public Tracking:
not applicable (codegeist-agent-kit is not mounted at .opencode)` when they have
never linked an Issue. An existing full Issue URL is never replaced by a later
eligibility or no-mirror result; the task blocks until its public counterpart can
be validated and completed safely.

## Mirror Verification

`/task` checks this file's `GitHub Mirror` declaration before any GitHub access.
Use `GitHub Mirror: none` in repositories without a mirror. The declaration is
authoritative and lets contributors use the public workflow without access to a
separate source forge. When the declaration is absent, one unambiguous root-level
`github.com` remote may be confirmed and recorded; submodule remotes never count.

When no root remote identifies GitHub, `/task` may inspect one unambiguous source
repository's configured push mirrors with the read-only `tea api` command added
in Tea `v0.12.0`. Tea discovery uses only an already configured non-interactive
login, requires repository administrator access on the source forge, and runs
with `GH_TOKEN` removed so the GitHub token cannot be sent to another service.
The raw push-mirror response is never printed or persisted.

Missing Tea capability, login, access, or an unambiguous result does not prove
that no mirror exists. The task remains `blocked`, preserving an existing Issue
URL or using `Public Tracking: pending GitHub mirror verification` when no link
exists, until this file declares `GitHub Mirror: <URL|none>`. A successful Tea
response with no GitHub destination makes tracking not applicable for that run
but does not write `GitHub Mirror: none`, because manual mirrors and later
configuration changes remain possible.

GitHub operations require a valid `GH_TOKEN` in the OpenCode process environment
and force `GH_HOST=github.com`. `GH_TOKEN` is the only supported token environment
variable. The workflow never uses stored GitHub CLI credentials or browser login,
and it never stores or prints the token. A declared mirror must exist, be
unarchived, have Issues enabled, and not be a fork. GitHub's mirror metadata is
not used because manually synchronized mirrors do not reliably populate it.

## Issue Approval

Before creating a new Issue, `/task` shows the exact repository, title, and full
body, including its hidden tracking marker. The Issue is created only after the
user explicitly approves that preview in the current conversation. Creating or
specifying the task is not approval. Approval is single-use and must be requested
again when the preview changes or an earlier creation attempt fails. Declining or
deferring leaves the local task blocked with pending public tracking and creates
no Issue. Reusing an existing Issue does not create a new Issue and therefore does
not use this creation gate.

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

## Statuses

- `open` - accepted local work that has not entered implementation.
- `specified` - the task is clear enough to implement through `/task impl`.
- `in progress` - implementation is active when the repository records this
  intermediate state.
- `blocked` - implementation cannot proceed until a named dependency or decision
  is resolved.
- `solved` - implementation and verification are complete and any validated
  linked Issue has been confirmed closed with reason `completed`; review or
  other final handoff can still remain.
- `finalized` - review and required handoff are complete and the task is kept as
  a historical record.
- `cancelled` - the task will not be implemented; the task records why.

Local task status is authoritative but does not make work publicly ready. Public
readiness is coordinated separately through the Issue or Roadmap. A task for a
confirmed mirror must contain its Issue URL in `Public Tracking`; failed mirror,
Issue linkage, or completion-close operations, and pending or declined approval,
leave it `blocked` and retryable.

Backlog ideas without accepted scope stay in the repository Issue tracker or
`docs/tasks/backlog.md`; they are not presented as ready implementation tasks.

## Required Task Fields

Each task includes `Status`, `Public Tracking`, a random immutable `Tracking
Key`, `Goal`, `Acceptance Criteria`, `Files`, `Non-Goals`, and `Verification`.
Keep the specification small enough that a contributor can tell when it is
complete. The Issue contains only the one-sentence Goal, canonical task path,
source-of-truth notice, and hidden tracking marker.
