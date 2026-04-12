---
description: Manage repo task folders under docs/tasks
agent: build
---
Review the current repository state and existing task docs.
Follow @.opencode/rules/task-workflow.md,
@.opencode/rules/language-policy.md,
@.opencode/rules/software-documentation.md, and
@.opencode/rules/chat.md.

User input:
$ARGUMENTS

Then:
1. Parse the first argument as the action. Supported actions are `create`,
   `specify`, `solve`, `cancel`, and `backlog`. Stop and report the valid
   actions if the first argument is missing or invalid.
2. For `backlog`:
   - treat the remaining arguments as one idea title and stop if they are
     missing
   - create `docs/tasks/backlog.md` with a small explanation in the repo's docs
     language; default to English if the repo does not define one
   - record the current branch and whether it was already synchronized with its
     upstream before writing the backlog entry
   - append exactly one new `* <idea>` line to `docs/tasks/backlog.md`
   - stage and commit only `docs/tasks/backlog.md`, even when other worktree
     changes exist
   - do not update `docs/memory-bank/chat.md`, task files, or other docs for this quick-capture
     path
   - push the current branch only when that push would publish just the new
     backlog-only commit; if the branch was already ahead before the new commit,
     stop and report that the push would include unrelated commits
   - if the branch has no upstream but exactly one remote exists, set the
     upstream with `git push -u` only when that push would not include unrelated
     local commits
   - if no suitable push target exists, stop and report that exact blocker after
     creating the local backlog commit
   - after the backlog-only commit and push attempt, stop and report the result
     without treating the backlog item as the new active task context
3. Inspect `docs/tasks/README.md` and `docs/tasks/template.md` before writing
   task files. Create the directory or helper docs only if they are missing.
4. Follow the repo's language rules for task docs under `docs/`. If the repo
   does not define a language for that documentation tree, default to English.
5. Resolve task references by exact repo-relative path, exact task folder name,
   exact task filename, or exact task id such as `T001` or `T001_01`. Stop and
   list the
   options when the reference is ambiguous.
6. Use top-level task ids as `T001`, `T002`, and so on, and store them as
   `docs/tasks/TNNN_<task_slug>.md` by default.
7. When a task later gains child tasks, migrate that task from
   `TNNN_<task_slug>.md` to `TNNN_<task_slug>/task.md` before creating the first
   child task under `TNNN_<task_slug>/tasks/`.
8. Use the same migration rule recursively for child tasks: they also start as
   standalone `<parent-id>_NN_<task_slug>.md` files and move to `task.md` only
   when they gain their own child tasks.
9. For `create`:
   - create the next top-level `TNNN` task, starting at `T001`, as a standalone
     `.md` file unless
     the arguments clearly request `under <task-ref>`
   - when `under <task-ref>` is used, resolve the parent task first
   - if the parent currently exists as a standalone `.md` file, create the
     matching directory, move the file contents to `task.md`, and only then add
     the child task under the new `tasks/` directory
   - create child tasks as standalone `<parent-id>_NN_<task_slug>.md` files,
     where `NN` starts at `01` for each parent and grows only among that
     parent's direct children
   - create one canonical task document from the task template
   - fill title, id, type, parent, and the canonical open-status value used by
     the repo; default to `open` if the template does not define one
   - keep every created task self-contained with its own goal, acceptance
     criteria, verification, and file targets even when it sits under a parent
10. For `specify`:
    - read the target task first and preserve its intended scope
    - treat `specify` as a collaborative clarification step with the user, not
      as an implementation step
    - ask focused follow-up questions when scope, constraints, expected outcome,
      or tradeoffs are still unclear
    - deepen the task description until it is clear what should be done, why it
      matters, what is in scope, and what is explicitly out of scope
    - sharpen goal, context, acceptance criteria, verification, file targets,
      dependencies, and important constraints
    - document concrete solution approaches when they help clarify the intended
      work, but keep them at specification depth rather than implementing them
    - make concrete suggestions and alternatives when they help specify the task
      more deeply, but use them only to clarify the work and not to go beyond
      the specification phase
    - prefer making the task easier to understand and execute later over
      prematurely splitting or solving it
    - split the task into concrete child tasks only when that clearly improves
      clarity, safety, or resumability
11. For `solve`:
    - read the target task and the directly relevant child tasks first
    - prefer solving leaf tasks
    - if the target has unresolved child tasks that should stay separate, stop
      and report the next child task instead of silently collapsing that
      structure
    - implement the task, run verification, and update status and implementation
      notes
12. For `cancel`:
    - mark the target task with the repo's canonical cancelled-status value;
      default to `cancelled` if the template does not define one
    - record the reason under the repo's existing cancellation-reason field when
      present; otherwise use `Cancellation Reason`
    - if the cancellation clearly applies to open child tasks too, update them
      in the same pass; otherwise report the required follow-up
13. Update `docs/memory-bank/chat.md` when the task set changes the current
    focus or durable repo memory.
14. Report the created or updated task files, the final statuses, and any
    follow-up.

Do not create a heavier planning system than `docs/tasks/` plus recursive
`tasks/` directories created only when needed.
Do not write task docs outside `docs/tasks/`, including the `backlog` action,
which writes only `docs/tasks/backlog.md`.
Do not invent extra task actions beyond `create`, `specify`, `solve`,
`cancel`, and `backlog`.
