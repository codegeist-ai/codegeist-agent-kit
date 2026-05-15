---
description: Finalize a solved task and update affected docs
agent: build
---

Finalize an already solved task by checking task impact and refreshing affected
documentation.

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
/finalize-task <task-ref> [context/instructions]
```

## Purpose

Use this command after `/solve-task` has successfully implemented and verified a
task. This phase checks whether the task's changes affect other task docs,
dependencies, follow-ups, or durable documentation, then updates the affected
files so the task can be handed off cleanly.

Phase dependency: `/solve-task`. Before finalizing, the target task must have a
current solve phase status and top-level `status: solved`. If the solve result is
missing, stale, failed, or contradicted by the current repository state, stop and
recommend `/solve-task <task-ref> [context/instructions]` first.

## Workflow

1. Parse the first argument as the target task reference and treat remaining
   arguments as user-provided context or finalization instructions. Stop if the
   task reference is missing.
2. Resolve the task reference by exact repo-relative path, exact task filename,
   exact task folder name, or exact task id such as `TNNN` or `TNNN_07`. Stop and
   list options if the reference is ambiguous. When the resolved reference is a
   directory, require `<directory>/task.md` and use that file as the target task;
   stop if the directory has no canonical `task.md`.
3. Read the target task, parent `task.md` when present, child tasks, dependency
   tasks, adjacent open tasks, and task templates or README files when present.
4. Verify that the target task has a current successful `/solve-task` status and
   top-level `status: solved`. Stop if solving is not complete.
5. Review the solved changes and task notes to identify affected tasks:
   - parent tasks whose progress, acceptance criteria, or next steps changed
   - child tasks made obsolete, unblocked, duplicated, or newly necessary
   - dependency tasks whose assumptions or ordering changed
   - adjacent open tasks that now need updated scope, non-goals, or follow-ups
6. Update directly affected task files with concise impact notes, dependency
   changes, follow-ups, blockers, or completion state. Do not invent broad new
   tasks unless the solved work clearly created a separate follow-up that must be
   tracked.
7. Execute @.opencode/commands/update-documentation.md with the same task
   reference and user context so READMEs, repo docs, memory files, and rule docs
   affected by the solved task are reviewed and updated when needed.
8. If finalization reveals that implementation or verification is incomplete,
   stop and report the exact gap instead of writing a success status.
9. Run targeted verification after finalization. At minimum, run:

```bash
git --no-pager diff --check
```

10. Record or update this phase's status in the target task according to
    @.opencode/rules/task-phases.md, including impacted tasks, documentation
    updates, remaining follow-ups, and verification results. After a successful
    finalization pass, write top-level `status: finalized`.
11. Report updated task files, documentation files reviewed or changed, affected
    tasks, remaining follow-ups, verification commands and results, and whether
    the task is finalized.

## Rules

- Do not run before `/solve-task` has successfully completed.
- Do not modify runtime code except for a tiny correction that is required to
  make the solved task internally consistent; if more implementation work is
  needed, return to `/solve-task` instead.
- Do call @.opencode/commands/update-documentation.md or apply its documented
  semantics during this phase.
- Do not write `status: finalized` when impacted tasks, documentation updates,
  or verification are blocked.
- Keep durable documentation in English unless the repository records a specific
  language exception.
