---
description: Manage repo tasks with spec and impl actions
agent: build
---
Review the current repository state and existing task docs.
Follow @.opencode/rules/task-workflow.md,
@.opencode/rules/language-policy.md,
@.opencode/rules/software-documentation.md,
@.opencode/rules/software-tests.md, and @.opencode/rules/chat.md.

User input:
$ARGUMENTS

Then:
1. Parse the first argument as the action. Supported actions are `spec`, `impl`,
   `cancel`, and `backlog`. Stop and report the valid actions if the first
   argument is missing or invalid.
2. Inspect `docs/tasks/README.md` and `docs/tasks/template.md` before writing
   task files. Create the directory or helper docs only if they are missing.
3. Keep task docs under `docs/` in English, even when the user discussion is in
   another language.
4. Resolve task references by exact repo-relative path, exact task folder name,
   exact task filename, or exact task id such as `T001` or `T001_01`. Stop and
   list options when the reference is ambiguous.
5. Use top-level task ids as `T001`, `T002`, and so on, and store them as
   `docs/tasks/TNNN_<slug>.md` by default.
6. When a task later gains child tasks, migrate that task from
   `TNNN_<slug>.md` to `docs/tasks/TNNN_<slug>/task.md` before creating the first
   child task under `docs/tasks/TNNN_<slug>/tasks/`.
7. Use the same migration rule recursively for child tasks: they also start as
   standalone `<parent-id>_NN_<slug>.md` files and move to `task.md` only when
   they gain their own child tasks.

## `spec`

Syntax:

```text
/task spec "feature user managed ui"
```

Use `spec` to create and specify a task together with the user.

1. Treat the remaining arguments as the task title, context, and user-provided
   implementation hints. Stop and ask one focused question if the intended task
   is too vague to create.
2. Create the next top-level `TNNN` task unless the arguments clearly request
   `under <task-ref>`. For child tasks, resolve the parent first and use the
   recursive task-directory rules above.
3. Create one canonical task document from the task template when available.
4. Keep the task minimal and focused. Do not produce a broad option catalog or a
   speculative architecture proposal.
5. Work interactively with the user. Ask focused follow-up questions when scope,
   constraints, expected outcome, acceptance criteria, or tradeoffs are unclear.
6. Capture direct implementation instructions when the user provides them, but do
   not implement code during `spec`.
7. Fill or sharpen title, id, type, parent, status, goal, context, scope,
   non-goals, acceptance criteria, relevant files or areas, implementation hints,
   verification, dependencies, and open questions.
8. Use status `specified` when the task is clear enough to implement. Use
   `blocked` when required user decisions remain.
9. Split into child tasks only when that clearly improves clarity, safety, or
   resumability. Prefer one narrow task.

## `impl`

Syntax:

```text
/task impl T00X_0X_XX "optional implementation instructions"
```

Use `impl` to implement a task. The optional text is binding context for this
implementation pass.

1. Resolve the task reference, read the target task, parent task when present,
   directly relevant child tasks, dependencies, task templates, and referenced
   docs before editing runtime files.
2. Prefer implementing leaf tasks. If the target has unresolved child tasks that
   should stay separate, stop and report the next child task instead of silently
   collapsing that structure.
3. If the task lacks enough specification to implement safely, pause
   implementation, ask focused clarification questions, update the task, and only
   continue when the task is sufficiently specified.
4. In plan mode, do not write files. Show and explain the full intended
   implementation: files to touch, exact behavioral changes, verification, risks,
   and documentation updates.
5. Outside plan mode, implement the smallest correct change. Every line of code
   must earn its place; avoid speculative abstractions, boilerplate, and broad
   rewrites.
6. Document why non-obvious code changes exist in task notes or nearby durable
   docs. Add code comments only when they materially improve understanding.
7. Update tests, documentation, task status, and implementation notes according
   to the task's acceptance criteria and repo rules.
8. Run enough verification to prove the acceptance criteria. At minimum, run:

```bash
git --no-pager diff --check
```

9. Use status `implemented` when verification passes. Use `blocked` when a user
   decision, failing dependency, or unresolved specification gap prevents safe
   implementation.

## `cancel`

1. Mark the target task with the repo's canonical cancelled-status value; default
   to `cancelled` if the template does not define one.
2. Record the reason under the repo's existing cancellation-reason field when
   present; otherwise use `Cancellation Reason`.
3. If the cancellation clearly applies to open child tasks too, update them in
   the same pass; otherwise report the required follow-up.

## `backlog`

1. Treat the remaining arguments as one idea title and stop if they are missing.
2. Create `docs/tasks/backlog.md` with a small English explanation when missing.
3. Record the current branch and whether it was already synchronized with its
   upstream before writing the backlog entry.
4. Append exactly one new `* <idea>` line to `docs/tasks/backlog.md`.
5. Stage and commit only `docs/tasks/backlog.md`, even when other worktree
   changes exist.
6. Do not update `docs/memory-bank/chat.md`, task files, or other docs for this
   quick-capture path.
7. Push the current branch only when that push would publish just the new
   backlog-only commit; if the branch was already ahead before the new commit,
   stop and report that the push would include unrelated commits.
8. If the branch has no upstream but exactly one remote exists, set the upstream
   with `git push -u` only when that push would not include unrelated local
   commits.
9. If no suitable push target exists, stop and report that exact blocker after
   creating the local backlog commit.
10. After the backlog-only commit and push attempt, stop and report the result
    without treating the backlog item as the new active task context.

Update `docs/memory-bank/chat.md` when the task set changes the current focus or
durable repo memory.

Report the created or updated task files, final statuses, implementation result,
verification commands, and any follow-up.

Do not create a heavier planning system than `docs/tasks/` plus recursive
`tasks/` directories created only when needed.
Do not write task docs outside `docs/tasks/`, including the `backlog` action,
which writes only `docs/tasks/backlog.md`.
Do not invent extra task actions beyond `spec`, `impl`, `cancel`, and `backlog`.
