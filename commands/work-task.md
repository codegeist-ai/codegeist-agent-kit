---
description: Run the full task workflow through specify, plan, solve, and finalize
agent: build
---

Run the complete task-to-finalization workflow for one task together with the
user.

Follow @.opencode/rules/task-workflow.md,
@.opencode/rules/task-phases.md,
@.opencode/rules/language-policy.md,
@.opencode/rules/software-documentation.md,
@.opencode/rules/software-tests.md, and @.opencode/rules/chat.md.

This command orchestrates the shared phase commands. Keep phase-specific behavior
in `/specify-task`, `/plan-task`, `/solve-task`, `/finalize-task`, and
@.opencode/rules/task-phases.md instead of duplicating detailed phase rules here.

User input:

```text
$ARGUMENTS
```

Expected syntax:

```text
/work-task <task-ref> [context/instructions]
```

## Purpose

Use this command when the user wants the complete workflow to run from task
clarification through detailed planning, verified implementation, impact review,
and documentation finalization.

The command runs these phases in order with the same argument contract:

```text
/specify-task <task-ref> [context/instructions]
/plan-task <task-ref> [context/instructions]
/specify-task <task-ref> [context/instructions]
/solve-task <task-ref> [context/instructions]
/finalize-task <task-ref> [context/instructions]
```

The second `/specify-task` pass is intentional. It checks the planned
implementation task after `/plan-task` has created or sharpened it, before
runtime code changes begin.

## Workflow

1. Parse the first argument as the initial task reference and treat remaining
   arguments as user-provided context or instructions for every phase. Stop if the
   task reference is missing.
2. Resolve the initial task reference by exact repo-relative path, exact task
   filename, exact task folder name, or exact task id such as `TNNN` or
   `TNNN_01`.
   Stop and list options if the reference is ambiguous. When the resolved
   reference is a directory, require `<directory>/task.md`.
3. Read the initial task, parent `task.md` when present, directly relevant child
   tasks, dependencies, and task workflow rules before starting.
4. Run `/specify-task <task-ref> [context/instructions]` phase semantics on the
   resolved task, record that phase status, and write top-level
   `status: specified` in the target task after the phase succeeds.
5. Run `/plan-task <task-ref> [context/instructions]` phase semantics with the
   same task reference and context. If this phase creates or identifies a
   different concrete implementation task, switch the workflow target to that task
   for the remaining phases. After the phase succeeds, write top-level
   `status: planned` in the concrete implementation task.
6. Stop and report if planning leaves multiple possible implementation tasks,
   unresolved material decisions, or no safe concrete implementation task.
7. Run `/specify-task <task-ref> [context/instructions]` phase semantics again on
   the concrete implementation task selected by planning. After the phase
   succeeds, write top-level `status: specified` in that implementation task.
8. Stop and report if the implementation task is still missing required planning
   details, open decisions block implementation, or the task status recommends
   another `/plan-task` pass before solving.
9. Run `/solve-task <task-ref> [context/instructions]` phase semantics on the
   concrete implementation task. After the phase succeeds, write top-level
   `status: solved` in that implementation task.
10. Run `/finalize-task <task-ref> [context/instructions]` phase semantics on
    the solved implementation task. This phase must check whether the solved
    changes affect other tasks, must execute
    @.opencode/commands/update-documentation.md, and after success must write
    top-level `status: finalized` in the implementation task.
11. Update directly affected task files when decisions change during any phase.
12. Update `docs/memory-bank/chat.md` only when the workflow changes durable
     project state or future sessions would otherwise miss important context.
13. Run the verification required by the final solve and finalize phases. At
    minimum, run:

```bash
git --no-pager diff --check
```

14. Report the initial task, final implementation task, context or instructions
    used, phase statuses written, discovered hints considered, files changed,
    impacted tasks, documentation updates, verification commands and results,
    acceptance criteria status, open decisions, and remaining follow-ups.

## Stop Conditions

Stop before implementation and report the exact blocker when:

- the task reference is ambiguous or points to a non-canonical task directory
- `/specify-task` determines the task is too vague to plan safely
- `/plan-task` finds multiple viable implementation tasks and needs a user choice
- `/plan-task` cannot identify or create a concrete implementation task
- the planned task is missing files, modules, implementation steps, acceptance
  criteria, or verification details needed by `/solve-task`
- `/solve-task` did not complete successfully, because `/finalize-task` may only
  run after a successful solve phase
- the provided context changes scope enough that another `/specify-task` or
  `/plan-task` pass is required before solving

## Rules

- Use the same `<task-ref> [context/instructions]` argument contract for every
  phase.
- Do not bypass the phase commands' requirements. Each phase must discover hints,
  honor dependencies, write its own phase status in the target task, and update
  the task's top-level `status:` after successful completion.
- Do not write `status: specified`, `status: planned`, `status: solved`, or
  `status: finalized` for a phase that stopped on a blocker or failed
  verification.
- Do not silently solve a source task when `/plan-task` created or selected a
  different concrete implementation task. Switch to the concrete task and report
  the switch.
- Do not continue into `/solve-task` when `/plan-task` or the second
  `/specify-task` leaves material implementation decisions open.
- Do not continue into `/finalize-task` unless `/solve-task` completed
  successfully on the same concrete implementation task.
- Keep durable documentation in English unless the repository records a specific
  language exception.
