# Local Task Guide

GitHub owns public work discovery and status. This directory keeps the focused
implementation specifications accepted for this repository.

## Linkage

```text
Codegeist roadmap -> repository Issue -> local task -> branch -> pull request -> merge
```

- The [Codegeist roadmap](https://github.com/users/codegeist-ai/projects/1) gives
  the account-wide view.
- A repository [Issue](https://github.com/codegeist-ai/codegeist-agent-kit/issues)
  owns public discussion, priority, assignment, and status.
- A local task owns the implementation goal, acceptance criteria, file scope,
  non-goals, and verification.
- A ready Issue links its local task path, and the task's `Public Tracking`
  field links back with the full Issue URL.
- The implementation branch and pull request link both the Issue and task. The
  pull request reports verification and updates the task status when practical.
- Merge closes the Issue and moves the public roadmap item to its completed
  state. Historical task files remain implementation records, not ready work.

Tasks start as `docs/tasks/TNNN_<slug>.md`, using the next available numeric ID.
Only introduce nested task directories when a task genuinely needs child tasks.

## Statuses

- `open` - accepted local work that has not entered implementation.
- `specified` - the task is clear enough to implement through `/task impl`.
- `in progress` - implementation is active when the repository records this
  intermediate state.
- `blocked` - implementation cannot proceed until a named dependency or decision
  is resolved.
- `solved` - implementation, acceptance criteria, and local verification are
  complete, but review or final handoff can still remain.
- `finalized` - review and required handoff are complete and the task is kept as
  a historical record.
- `cancelled` - the task will not be implemented; the task records why.

Local task status does not make work publicly ready. Public readiness is tracked
separately: `Public Tracking` must contain an Issue URL, and the Issue or Roadmap
item must be marked ready. A locally `open` or `specified` task with pending
public tracking is not yet advertised contributor work.

Backlog ideas without accepted scope stay in the repository Issue tracker or
`docs/tasks/backlog.md`; they are not presented as ready implementation tasks.

## Required Task Fields

Each public candidate includes `Status`, `Public Tracking`, `Goal`, `Acceptance
Criteria`, `Files`, `Non-Goals`, and `Verification`. Keep the specification
small enough that a contributor can tell when it is complete.
