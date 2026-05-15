---
description: Specify an existing repo task without implementing it
agent: build
---

Review the current repository state and existing task docs.

Follow @.opencode/rules/task-workflow.md,
@.opencode/rules/task-phases.md,
@.opencode/rules/language-policy.md,
@.opencode/rules/software-documentation.md, and @.opencode/rules/chat.md.

Also read and apply relevant project-specific overlays under `.oc_local/rules/`
when they exist. Keep domain-specific behavior in local overlays instead of
hard-coding it into this shared command.

User input:

```text
$ARGUMENTS
```

Expected syntax:

```text
/specify-task <task-ref> [context/instructions]
```

## Purpose

Use this command to run a repeatable specification pass over an existing task.
The target task must already have a meaningful description, goal, or scope. This
phase clarifies the task; it does not create, solve, or implement it.

Phase dependency: none. This is the normal entry point for the phased task
workflow and may be repeated later when new information changes the source or
planned implementation task.

## Workflow

1. Parse the first argument as the target task reference and treat remaining
   arguments as user-provided context or instructions for this specification
   pass. Stop if the task reference is missing.
2. Resolve the task reference by exact repo-relative path, exact task filename,
   exact task folder name, or exact task id such as `TNNN` or `TNNN_07`. Stop and
   list options if the reference is ambiguous. When the resolved reference is a
   directory, require `<directory>/task.md` and use that file as the target task;
   stop if the directory has no canonical `task.md`.
3. If the resolved target is a task file under a task directory, read the nearest
   parent `task.md` before specifying the task. If a referenced task directory has
   a `tasks/` child directory but no `task.md`, stop and report the broken task
   structure instead of guessing the parent.
4. Read the target task first. If the task is only a stub without a meaningful
   description, goal, or scope, stop and ask the user to describe the intended
   task before specifying it further.
5. Apply any user-provided context or instructions as the main reason for this
   pass. On repeated runs, focus on the requested clarification, new information,
   or changed boundary instead of rewriting generically.
6. Read directly relevant task docs before editing, including parent task,
   directly adjacent child tasks, dependency tasks, and task templates or README
   files when present.
7. Discover and read applicable hints according to @.opencode/rules/task-phases.md.
   Use hints to clarify scope, boundaries, dependencies, verification, and
   implementation-readiness questions only; do not solve or implement the task
   from hint content.
8. Preserve the task's intended scope. Do not add runtime code, change build
   files, or implement the described behavior.
9. Deepen the task where needed:
   - sharpen goal, context, scope, non-goals, deliverable, acceptance criteria,
     verification, dependencies, and open questions
   - add assumptions, constraints, and decision records when useful
   - add implementation-readiness questions, but keep them at specification depth
   - update the task when decisions changed, new instructions arrived, or
     acceptance criteria, dependencies, non-goals, or follow-up boundaries need
     to stay current
10. Record or update this phase's status in the target task according to
    @.opencode/rules/task-phases.md, and write top-level `status: specified`
    after a successful specification pass.
11. If the task changes central project documentation, update that documentation
    in the same pass so task and docs stay consistent.
12. Update `docs/memory-bank/chat.md` only when the specification changes durable
    project state or current task focus.
13. Run a targeted documentation check, at minimum:

```bash
git --no-pager diff --check
```

14. Report updated files, user context or instructions considered, parent task
    considered, discovered hints considered, what was clarified, what remains
    open, and the next recommended workflow phase.

## Rules

- Do not create a new task.
- Do not solve the task.
- Do record this phase's status in the task file whenever the pass changes or
  confirms durable workflow state.
- After a successful pass, the target task must contain top-level
  `status: specified`.
- Do not split the task unless it is clearly too broad to remain safe or
  executable.
- Keep durable documentation in English unless the repository records a specific
  language exception.
