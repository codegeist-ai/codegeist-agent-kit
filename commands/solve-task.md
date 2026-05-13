---
description: Solve an existing repo task collaboratively
agent: build
---

Solve an existing task from the repo's task documentation together with the user.

Follow @.opencode/rules/task-workflow.md,
@.opencode/rules/task-phases.md,
@.opencode/rules/language-policy.md,
@.opencode/rules/software-documentation.md,
@.opencode/rules/software-tests.md, and @.opencode/rules/chat.md.

Also read and apply relevant project-specific overlays under `.oc_local/rules/`
when they exist. Keep domain-specific behavior in local overlays instead of
hard-coding it into this shared command.

User input:

```text
$ARGUMENTS
```

Expected syntax:

```text
/solve-task <task-ref> [context/instructions]
```

## Purpose

Use this command when a task already exists and should move from implementation
plan to verified solution. It implements the chosen path, runs enough
verification to prove the acceptance criteria, and updates task state and related
docs when needed.

Phase dependency: `/plan-task`. Before solving, the target implementation task
should contain a current implementation plan from `/plan-task`. If the plan is
missing, stale, or contradicted by the provided context, update the task first or
recommend `/plan-task <task-ref> [context/instructions]` before implementation.

## Workflow

1. Parse the first argument as the target task reference and treat remaining
   arguments as user-provided context or implementation instructions. Stop if the
   task reference is missing.
2. Resolve the task reference by exact repo-relative path, exact task filename,
   exact task folder name, or exact task id such as `TNNN` or `TNNN_07`. Stop and
   list options if the reference is ambiguous. When the resolved reference is a
   directory, require `<directory>/task.md` and use that file as the target task;
   stop if the directory has no canonical `task.md`.
3. Read the target task, parent `task.md` when present, child tasks, dependency
   tasks, adjacent open tasks, and task templates or README files when present.
4. Discover and read applicable hints according to @.opencode/rules/task-phases.md.
5. Read relevant repo and project-specific rules before implementation.
6. Prefer solving leaf tasks. If the target has open child tasks that should stay
   separate, stop and report the next child task instead of silently collapsing
   that structure.
7. Inspect the files named by the task, hints, acceptance criteria, dependencies,
   and project-specific rules. Do not assume the task text is fully current.
8. Apply any user-provided context or implementation instructions as the main
   focus for this solve pass. If the instruction changes scope materially, update
   the task first or recommend another `/specify-task` or `/plan-task` pass before
   implementation.
9. Verify the task has a current `/plan-task` status and implementation plan.
   Stop or return to `/plan-task` when planned files, modules, classes, steps,
   acceptance criteria, or verification are missing enough to make solving unsafe.
10. Maintain a precise working note inside the target task throughout the solve
    pass. Record what should be done before implementation starts, what was done,
    why decisions were made, what changed, what remains open, and what the next
    step is.
11. Start collaboratively unless the task is trivial and already has a single
    obvious implementation path. Offer concrete starting options derived from the
    current task, hints, and repo context when tradeoffs matter.
12. Implement the chosen solution with the smallest reasonable change. Update
    tests, documentation, task status, and implementation notes according to the
    task's acceptance criteria and repo rules.
13. When decisions change while solving, update the task plan, acceptance
    criteria, non-goals, or affected follow-up tasks before continuing.
14. If solving reveals a reusable lesson, update the relevant hint file in the
    same pass. Keep hint updates concise and broadly applicable.
15. Update `docs/memory-bank/chat.md` only when the solution changes durable
    project state or future sessions would otherwise miss important context.
16. Run comprehensive verification for the task, including every relevant command
    named by the task and enough additional checks to prove all acceptance
    criteria are satisfied. At minimum, run:

```bash
git --no-pager diff --check
```

17. Record or update this phase's status in the target task according to
    @.opencode/rules/task-phases.md, including verification and acceptance
    criteria status.
18. Report updated files, discovered hints considered or updated, user context or
    implementation instructions considered, implemented solution, verification
    commands and results, acceptance criteria status, decisions made with the
    user, affected tasks, and remaining follow-ups.

## Rules

- Do not create a new task unless the current task is too broad to solve safely
  and the split is necessary for resumability.
- Do not collapse unresolved child tasks into the parent solution unless the user
  explicitly chooses that direction.
- Do not leave the target task without an up-to-date solve status.
- Update the target task when solving changes decisions, scope, acceptance
  criteria, implementation plan, or follow-up work.
- Keep durable documentation in English unless the repository records a specific
  language exception.
