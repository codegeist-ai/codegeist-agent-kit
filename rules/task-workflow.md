# Task Workflow

Keep task handoff small, traceable, and easy to resume.

## Sources Of Truth

- The local task file owns scope, acceptance criteria, status, files, and
  verification. A linked GitHub Issue is only a concise public pointer and
  discussion surface.
- `commands/task.md` owns the detailed `spec`, `impl`, `cancel`, and `backlog`
  execution procedure, including project eligibility, mirror discovery, GitHub
  authentication, Issue linkage, and completion checks.
- A repository's `docs/tasks/README.md` owns local fields, statuses, mirror
  declaration, and repository-specific task conventions.

## Before Changing Code

- Read the relevant rules, repository docs, task file, and dirty worktree.
- Use `/task spec "<title/context>"` to create or sharpen an accepted task before
  implementation when tracked handoff is useful.
- Use `/task impl <task-ref> [instructions]` for implementation. Clarify and
  update an underspecified task before editing runtime files.
- Keep one task focused on one behavior or workflow change and update matching
  documentation in the same task.

## Local Task Records

- Keep task documents under `docs/tasks/` in English and follow the repository's
  template and ID hierarchy. Never recycle an ID found in current files or Git
  history.
- Give every task one immutable random `Tracking Key`. New tasks default to
  `Public Tracking: not requested`; public tracking remains available if tracking
  is requested later through `/task spec`.
- Keep backlog ideas local to `docs/tasks/backlog.md`. `/task backlog` does not
  create an Issue, stage files, commit, or push.
- Keep `spec` minimal and `impl` limited to lines justified by the acceptance
  criteria or implementation notes.

## Public Tracking Invariants

- Do not inspect project eligibility, mirrors, Tea, `GH_TOKEN`, or GitHub for an
  unlinked task unless the current user explicitly requests public tracking.
- Once public tracking is requested, follow `commands/task.md` without bypassing
  its eligibility, credential isolation, mirror validation, or retry rules.
- Public tracking selection never approves a remote mutation. Show the exact
  repository, title, and complete body before creating an Issue and require
  explicit single-use approval of that preview.
- Preserve every full Issue URL as binding. Never replace or ignore it to bypass
  validation, linkage repair, or completion closure.
- Keep uncertain mirror, authentication, creation, linkage, and closure results
  `blocked` so a later invocation can reconcile them without duplicate Issues or
  repeated implementation side effects.
- Do not synchronize labels, projects, readiness, cancellation, or intermediate
  task status. For a linked task, close and read back the validated Issue with
  reason `completed` before persisting local status `solved`.
- A sufficiently specified unlinked task may become `solved` after local
  verification only when public tracking is inactive or confirmed not
  applicable.

## Finishing A Task

- Run targeted verification for the changed behavior and record meaningful
  results in the task file.
- Capture durable rule changes through `@.opencode/commands/learn.md` when that
  workflow fits the repository.
- Report `@.opencode/commands/save.md` as an available follow-up, but never
  execute or delegate to it unless the current user request explicitly
  authorizes a commit.

## Repo-Specific Conventions

- Record stricter branch naming, Issue fields, or public-readiness conventions in
  repo-local docs. Local refinements must keep the task file authoritative and
  preserve the shared public-tracking safety invariants.
