# Task Phase Workflow

Use these rules for the shared task phase commands:

- `/specify-task <task-ref> [context/instructions]`
- `/plan-task <task-ref> [context/instructions]`
- `/solve-task <task-ref> [context/instructions]`
- `/finalize-task <task-ref> [context/instructions]`
- `/work-task <task-ref> [context/instructions]`

## Purpose

- Keep task work resumable by recording each phase in the task file itself.
- Separate clarification, implementation planning, verified solving, and final
  impact/documentation review.
- Let consuming repositories add domain-specific overlays without changing the
  shared command behavior.

## Phase Order

1. `/specify-task` clarifies the task without implementing it.
2. `/plan-task` creates or sharpens the implementation plan without changing
   runtime code.
3. `/specify-task` may run again after planning to verify the planned task is
   still clear and current.
4. `/solve-task` implements and verifies the planned task.
5. `/finalize-task` checks task impact after solving and updates affected
   documentation.

`/work-task` orchestrates that full sequence and stops when a phase needs a user
decision or another preparation pass.

## Phase Dependencies

- `/specify-task` has no prior phase dependency.
- `/plan-task` depends on a current `/specify-task` status when that status is
  needed for safe planning.
- `/solve-task` depends on a current `/plan-task` status and an implementation
  plan with enough detail to build and verify safely.
- `/finalize-task` depends on a current successful `/solve-task` status and
  top-level `status: solved` in the target implementation task.

## Required Phase Status

Each phase must record or update its status in the target task when the phase
changes or confirms durable workflow state. A useful phase status names:

- phase command
- context or instructions considered
- discovered hints considered
- upstream phase dependency and whether it is satisfied
- result or outcome
- open decisions or blockers
- next recommended phase

Each successful phase must also keep a top-level `status:` field in the target
task synchronized with the latest completed phase:

- `/specify-task` writes `status: specified`
- `/plan-task` writes `status: planned`
- `/solve-task` writes `status: solved`
- `/finalize-task` writes `status: finalized`

`/work-task` must write the same top-level status after each successful phase it
orchestrates, including the second `/specify-task` pass after planning and the
final `/finalize-task` pass after solving. Do not write a success status for a
blocked or failed phase; record the blocker in the phase status instead.

## Hint Discovery

Each phase should discover applicable hints from task documents instead of
relying only on explicit command arguments. Search the target task, parent tasks,
direct child tasks, dependency tasks, and adjacent task docs for:

- sections named `Default Solve Hints`, `Hints`, or `Guidance`
- repo-relative paths that point to hint or guidance files
- files under `docs/tasks/hints/` when that directory exists

`docs/tasks/hints/` is an optional project-local convention. Its absence is not
an error. Missing files that are explicitly referenced by a task should be
reported because they can change the task contract.

## Task Updates

Every phase may update the target task or directly affected task files when
decisions change, new instructions arrive, or acceptance criteria, non-goals,
implementation plans, dependencies, or follow-up boundaries need to stay current.

Keep project-specific domain decisions, architecture references, and product
terms in repo-local overlays such as `.oc_local/rules/*.md`.
