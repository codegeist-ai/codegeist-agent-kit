---
description: Plan one implementation task from an existing task
agent: build
---

Plan one concrete implementation task from an existing repo task together with
the user.

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
/plan-task <task-ref> [context/instructions]
```

## Purpose

Use this command when an existing architecture, planning, backlog, or solution
task should become one concrete implementation plan. This command creates or
updates task documentation only. It does not implement runtime code, change build
files, or solve the planned task.

Phase dependency: `/specify-task`. Before planning, the source or existing
implementation task should have a specification pass recorded. If no current
specification status exists and the missing context affects planning safety,
stop and recommend `/specify-task <task-ref> [context/instructions]` first.

## Workflow

1. Parse the first argument as the source task reference and treat remaining
   arguments as user-provided context or instructions. Stop if the task reference
   is missing.
2. Resolve the source by exact repo-relative path, exact task filename, exact
   task folder name, or exact task id such as `TNNN` or `TNNN_25`. If the source
   is a directory, require and use its canonical `task.md`. Stop and list options
   if the reference is ambiguous, and stop if a referenced task directory has no
   `task.md`.
3. Read the source task, parent `task.md` when present, child tasks when the
   source is an epic, dependency tasks, adjacent open tasks, and task templates or
   README files when present.
4. Discover and read applicable hints according to @.opencode/rules/task-phases.md.
5. Read central architecture, planning, or design docs named by the source task.
6. Inspect existing tasks under `docs/tasks/` so the plan does not duplicate an
   existing implementation task.
7. Start collaboratively. If the source can produce more than one safe slice,
   present 2-3 concrete implementation plan options before writing files. Each
   option should include:
   - proposed task title
   - goal
   - concrete solution direction
   - target files, packages, modules, classes, interfaces, records,
     configuration files, documentation files, or tests likely to be needed
   - verification command or strategy
   - dependencies and tradeoffs
8. Ask focused questions only when the implementation slice, public contract,
   target files, verification depth, or boundary with later tasks is materially
   unclear. Otherwise choose the smallest correct details from repo conventions.
9. If the user chooses an option, a variant, or provides a clearer focus, refine
   exactly one implementation task. Do not silently create multiple tasks.
10. If a matching implementation task already exists, sharpen that task with the
    new source information, context, or user instructions instead of creating a
    duplicate. Create a duplicate only when the user explicitly confirms the
    distinction.
11. When creating a new task, follow @.opencode/rules/task-workflow.md for task
    placement, parent directories, and canonical `task.md` migration.
12. Make the target task self-contained and implementation-ready. Include at
    least:
    - title and source reference
    - goal and context
    - concrete solution direction
    - scope and non-goals
    - planned files, modules, classes, interfaces, records, configuration,
      documentation, and tests to add or change
    - implementation steps in expected order
    - acceptance criteria
    - verification plan, including expected commands and what they prove
    - dependencies
    - open questions, or `None` when no decision is pending
    - plan workflow handoff with resolved source task, parent task, user context,
      selected option, duplicate check result, discovered hints, related context
      files read, and recommended next phase
13. Record or update this phase's status in the target implementation task
    according to @.opencode/rules/task-phases.md, and write top-level
    `status: planned` after a successful planning pass.
14. Update `docs/memory-bank/chat.md` when planning changes the active project
    focus, current task set, or durable workflow state.
15. Run targeted verification after writing the task. At minimum, run:

```bash
git --no-pager diff --check
```

16. Report the source task, user context or instructions considered, created or
    sharpened task file, selected option, discovered hints considered, detailed
    implementation plan, verification result, user decisions, and recommended next
    phase.

## Rules

- Create or update planning documentation only; do not implement source code or
  tests in this command.
- Treat repeated runs as plan refinement.
- After a successful pass, the target implementation task must contain top-level
  `status: planned`.
- Create at most one implementation task unless the user explicitly asks for
  more.
- Do not create broad epic-level follow-ups when one narrow implementation task
  would be enough.
- Keep durable documentation in English unless the repository records a specific
  language exception.
