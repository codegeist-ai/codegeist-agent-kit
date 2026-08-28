---
description: Manage local tasks and GitHub mirror Issues
agent: build
---
Review the current repository state and existing task docs.
Follow @.opencode/rules/command-execution.md,
@.opencode/rules/task-workflow.md,
@.opencode/rules/language-policy.md,
@.opencode/rules/software-documentation.md, and
@.opencode/rules/software-tests.md.

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
   `docs/tasks/TNNN_<slug>.md` by default. Treat ids found in current files or Git
   history as used; never recycle a deleted task id.
6. When a task later gains child tasks, migrate that task from
   `TNNN_<slug>.md` to `docs/tasks/TNNN_<slug>/task.md` before creating the first
   child task under `docs/tasks/TNNN_<slug>/tasks/`.
7. Use the same migration rule recursively for child tasks: they also start as
   standalone `<parent-id>_NN_<slug>.md` files and move to `task.md` only when
   they gain their own child tasks.

## GitHub Mirror Tracking

The local task file is always the source of truth. Apply this section to every
top-level or child task created by `spec`, and repair missing tracking before
`impl`. Do not apply it to `backlog` entries.

### Project Eligibility

Apply GitHub Mirror Tracking automatically only when the repository uses
`codegeist-agent-kit` as an initialized `.opencode` Git submodule:

1. Before mirror discovery or any `GH_TOKEN` or `gh` check, require `.gitmodules`
   to register a submodule whose path is exactly `.opencode` and require the Git
   index entry for `.opencode` to use submodule mode `160000`.
2. Require `git submodule status -- .opencode` to identify an initialized
   checkout, and require `.opencode/opencode.json`,
   `.opencode/commands/task.md`, and `.opencode/rules/task-workflow.md` to exist.
3. Read the matching `.gitmodules` URL without printing or persisting the raw
   value. Strip credentials, transport syntax, and a trailing `.git`, then require
   its repository basename to be exactly `codegeist-agent-kit`. Do not require or
   disclose a particular source host.
4. If any eligibility check fails and the task has never linked an Issue, keep
   task management local, set `Public Tracking` to not applicable, and state that
   codegeist-agent-kit is not mounted at .opencode. Do not inspect GitHub mirrors
   or `GH_TOKEN`, do not run `gh`, and stop this section. Do not treat
   ineligibility as a task failure.
5. Never replace an existing full Issue URL with a not-applicable value. If
   eligibility now fails for a task that already links an Issue, preserve the
   URL, keep the task `blocked`, and report that eligibility must be restored
   before `/task` can validate or close its public counterpart.

### Mirror Discovery

1. Write the canonical local task before any remote action. For a new task or
   missing tracking, use `Public Tracking: pending GitHub mirror verification`
   and status `blocked`. Generate one random UUID as `Tracking Key` when the task
   does not already have one, and never change or recycle it. Preserve an
   existing full Issue URL until it has been validated or deliberately replaced.
2. Resolve a mirror candidate before checking `GH_TOKEN` or running any `gh`
   command:
   - When `Public Tracking` already contains a full GitHub Issue URL, preserve it
     and derive its repository as the candidate. Require any mirror declaration
     to agree with that repository. A conflicting `none`, URL, or remote result
     is an ambiguity to resolve, never permission to discard the Issue link.
   - First read `docs/tasks/README.md`. One exact `GitHub Mirror: <URL>`
     declaration is authoritative. Treat `GitHub Mirror: none` as an explicit
     decision that the repository has no GitHub mirror. Block on malformed or
     multiple declarations rather than guessing.
   - When the declaration is absent, inspect only remotes of the repository root.
     Ignore submodule remotes. Normalize raw URLs without printing them, and use
     a candidate directly only when the remotes identify exactly one distinct
     `github.com` repository.
   - When no root remote identifies a GitHub repository, continue to Tea Push
     Mirror Discovery below. Multiple distinct non-GitHub source repositories,
     no safely identifiable source repository, or conflicting candidates leave
     the mirror unknown.
   - From every source, extract only the credential-free
     `<owner>/<repository>` GitHub identity. Never print or persist a raw remote
     URL, user information, query, embedded credential, or complete API response.
3. For Tea Push Mirror Discovery, require exactly one safely selected non-GitHub
   root remote and verify that `env -u GH_TOKEN tea api --help` succeeds. Tea
   `v0.12.0` introduced the required `api` command. Do not install Tea, invoke
   `tea login add`, start an authentication flow, or change Tea configuration
   from `/task`.
4. Invoke Tea non-interactively for the explicit root remote with `GH_TOKEN`
   removed from that process environment, using this command shape:
   `env -u GH_TOKEN tea api --include --remote "<remote>" "<endpoint>"`. This is
   mandatory because Tea can otherwise treat `GH_TOKEN` as a source-forge token.
   Use Tea's already configured non-interactive login only.
5. Read every page of the GET endpoint
   `"repos/{owner}/{repo}/push_mirrors?page=<page>&limit=<limit>"`. Capture the
   HTTP status and response without allowing the raw response to reach tool
   output or a durable file, require status `200`, and parse only each
   `remote_address` into a credential-free GitHub identity. The endpoint normally
   requires source-repository administrator access.
6. A successful Tea response with no GitHub destination means no mirror was
   declared or discovered for this run. When no full Issue URL already exists,
   set `Public Tracking: not applicable (no GitHub mirror declared or discovered)`
   and restore the task's intended status, but do not automatically persist the
   explicit `GitHub Mirror: none` declaration; an empty push-mirror list does not
   rule out a synchronized mirror and can change later. Preserve and block on any
   existing Issue URL instead of downgrading it. Exactly one distinct GitHub
   destination becomes the candidate; several destinations require a declaration.
7. If Tea is unavailable, lacks the `api` command, cannot resolve a login, lacks
   access, returns a non-`200` response, produces invalid output, or mirror
   discovery is otherwise unknown or ambiguous, keep the task `blocked`. Preserve
   an existing full Issue URL; otherwise set `Public Tracking` to pending GitHub
   mirror verification. Ask for an exact `GitHub Mirror: <URL|none>` declaration
   and stop this section. Do not inspect `GH_TOKEN` and do not run `gh`.
8. For an explicit `GitHub Mirror: none` and no existing Issue URL, set `Public
   Tracking` to `not applicable (no GitHub mirror)` and restore the task's
   intended status. Do not inspect `GH_TOKEN`, invoke Tea, or run `gh`. If an
   Issue URL already exists, preserve it and block on the contradiction instead.

### GitHub Validation And Issue Linkage

9. When a mirror candidate exists, require a non-empty `GH_TOKEN` before any
   `gh` command. Use `GH_TOKEN` as the only supported GitHub token environment
   variable. Never print, inspect, persist, or ask the user to paste its value.
   Do not use stored GitHub CLI credentials, `gh auth login`, or browser
   authentication. Force `GH_HOST=github.com` and set `GH_PROMPT_DISABLED=1` for
   every `gh` invocation so ambient host configuration cannot redirect the
   operation.
10. Validate the token non-interactively with `gh api user`, capture the active
   login without logging it, and set `GH_HOST=github.com` plus
   `GH_PROMPT_DISABLED=1`. Then invoke `gh repo view` with the explicit
   `"<owner>/<repository>"` operand and
   `nameWithOwner,url,isArchived,hasIssuesEnabled,isFork` as JSON fields. Require
   the repository to exist, not be archived, have Issues enabled, and not be a
   fork. After validation, record only the canonical URL returned by GitHub as
   the durable `GitHub Mirror` declaration. GitHub's `isMirror` and `mirrorUrl`
   fields are not authoritative for manually synchronized mirrors and must not
   gate this workflow.
11. Identify task linkage with the unguessable hidden marker
   `<!-- canonical-task-key: <tracking-key> -->`; the marker must not contain the
   mutable task path. Before every creation attempt, invoke
   `gh api --paginate --slurp` with `GH_HOST=github.com` and
   `GH_PROMPT_DISABLED=1` against the quoted
   endpoint `"repos/<owner>/<repository>/issues?state=all&per_page=100"`. Capture
   and parse every page without allowing raw pages or unmatched Issue bodies to
   reach tool output or a durable file. Ignore pull requests and expose only the
   match count plus the minimum metadata needed to validate exact marker matches.
   When `Public Tracking` has no stored Issue URL, an automatic marker-only match
   is reusable only when its author is the captured active login and its bounded
   canonical-link block exactly identifies this task id and Tracking Key. Its
   path may be an earlier canonical path after a task move and must then be
   refreshed. Reuse one valid match, create when there is no match, and keep the
   task blocked for clarification when any match is invalid or several match.
12. For an Issue URL supplied by the user or already stored in `Public Tracking`,
   validate through the explicit repository API that it is an Issue, not a pull
   request, belongs to the confirmed mirror, and has been inspected completely
   without printing its raw body. If marker lookup found an Issue, require the
   supplied or stored URL to equal that Issue URL. Reject an Issue containing
   another task key or a canonical-link block for another task.
   - Reuse an already stored URL automatically when its exact Tracking Key and
     bounded block identify this task; the stored canonical link records a prior
     approved adoption even when another account authored the Issue. A URL newly
     supplied in the current conversation is automatic only when the same exact
     linkage is present and its author is the captured active login.
   - For a newly supplied exact cross-author link, show the repository, Issue URL,
     and complete existing block and require explicit single-use approval before
     storing it; no body edit is needed. For an unmarked or incomplete Issue,
     prepare the exact bounded-block update while preserving all other content,
      show the same preview, and require approval before invoking
      `gh issue edit --repo "<owner>/<repository>" --body-file -` under the normal
      GitHub environment contract. An already stored exact cross-author link
      remains exempt from repeated approval. Merely supplying a URL is not
      approval.
   - Immediately after approval and before an edit, read the complete Issue again
     without logging its body. Reject new conflicting or duplicate canonical
     material. Append the approved block only when none exists; replace exactly
     one safely bounded incomplete or stale same-task block instead of adding a
     duplicate. Block when existing material cannot be isolated safely.
   - After an approved edit, read the Issue back without exposing its body,
     verify that all non-canonical content from the fresh pre-edit body is
     unchanged, and require marker lookup to return that URL as its sole valid
     match before persisting linkage. Declined, deferred, or changed approval
     before the edit leaves the Issue unchanged. If the edit succeeds but
     read-back validation fails, preserve the URL, keep the task blocked, and
     report that the remote Issue changed but linkage could not yet be confirmed.
     GitHub does not provide a conditional Issue-body update for this endpoint,
     so report the narrow concurrent-edit race rather than claiming atomicity.
   Bound the block with `<!-- canonical-task-link:start -->` and
   `<!-- canonical-task-link:end -->`. It contains the task id, canonical task
   path, stable Tracking Key marker, and this exact sentence: "The task file is
   the source of truth for scope, acceptance criteria, status, and verification."
13. When no existing Issue will be reused, prepare but do not create the new
   Issue. Use the title `[<id>] <task title>` and a short body containing only the
   one-sentence Goal and canonical-link block. Show the user the exact confirmed
   repository, title, and complete body, including hidden markers, in a readable
   plaintext preview. Do not include the full task, secrets, sensitive
   configuration, or vulnerability details.
14. Ask one focused approval question for that exact preview immediately before
   creation. Only an explicit affirmative response in the current conversation
   authorizes `gh issue create`. Invoking `/task spec`, requesting the feature,
   approving a different Issue, or remaining silent does not count. Approval is
   single-use: a changed repository, title, or body, or a failed creation attempt,
   requires a new preview and approval. For multiple new Issues, obtain approval
   for each exact preview. Existing Issue reuse does not create an Issue and does
   not use this creation gate.
15. If the user declines or defers approval, keep the task `blocked`, set `Public
    Tracking` to `pending user approval for GitHub Issue creation`, report that no
    Issue was created, and stop the creation path.
16. Only after approval, invoke `gh issue create` with `GH_HOST=github.com`,
    `GH_PROMPT_DISABLED=1`, explicit `--repo "<owner>/<repository>"`, `--title`,
    and `--body-file -`, then capture its returned URL. Repeat the paginated
    marker lookup and require the returned URL to be its sole valid match before
    persisting it.
17. Store the full returned or reused Issue URL in `Public Tracking` and restore
   the task's intended specification status. Whenever any task path changes,
   apply the same private fresh-read, safely bounded replacement, non-canonical
   content comparison, and private read-back sequence before updating the block.
   Block instead of editing when canonical material is ambiguous.
18. Do not add labels, projects, readiness state, assignees, or milestones, and
    do not synchronize intermediate task statuses. Closing the linked Issue as
    completed immediately before `impl` persists `solved` is the only automatic
    task-status projection to GitHub; the local task otherwise remains
    authoritative.
19. If mirror discovery, token validation, mirror validation, Issue lookup,
    Issue creation, linkage update, URL persistence, completion closure, or
    completion verification fails, keep the local task `blocked`, preserve its
    existing Issue URL or pending tracking value, and report the exact non-secret
    failure. A later `/task spec <task-ref>` or `/task impl <task-ref>` must retry
    safely without duplicating an Issue or repeating implementation side effects.

## `spec`

Syntax:

```text
/task spec "feature user managed ui"
```

Use `spec` to create and specify a task together with the user.

1. First try to resolve the first remaining argument as an exact existing task
   reference. When it resolves, update that task in place, treat any later text
   as additional context, and never allocate another id. Otherwise treat all
   remaining arguments as the title, context, and user-provided implementation
   hints for a new task. Stop and ask one focused question if the intended task
   is too vague to create or update.
2. For a new task, create the next unused top-level `TNNN` unless the arguments
   clearly request `under <task-ref>`. For child tasks, resolve the parent first
   and use the recursive task-directory rules above.
3. Create one canonical task document from the task template when available,
   then apply GitHub Mirror Tracking before reporting the task as specified.
4. Keep the task minimal and focused. Do not produce a broad option catalog or a
   speculative architecture proposal.
5. Work interactively with the user. Ask focused follow-up questions when scope,
   constraints, expected outcome, acceptance criteria, or tradeoffs are unclear.
6. Capture direct implementation instructions when the user provides them, but do
   not implement code during `spec`.
7. Fill or sharpen title, id, type, parent, status, Public Tracking, Tracking Key,
   goal, context, scope, non-goals, acceptance criteria, relevant files or areas,
   implementation hints, verification, dependencies, and open questions.
8. Use status `specified` when the task is clear enough to implement and GitHub
   Mirror Tracking did not leave it blocked. Never overwrite a tracking-related
   `blocked` status merely because the local specification is ready. Use
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
2. Apply GitHub Mirror Tracking before editing runtime files. When the repository
   has a confirmed mirror, repair pending or missing tracking first and do not
   implement until the task contains its validated Issue URL.
3. Prefer implementing leaf tasks. If the target has unresolved child tasks that
   should stay separate, stop and report the next child task instead of silently
   collapsing that structure.
4. If the task lacks enough specification to implement safely, pause
   implementation, ask focused clarification questions, update the task, and only
   continue when the task is sufficiently specified.
5. In plan mode, do not write files. Show and explain the full intended
   implementation: files to touch, exact behavioral changes, verification, risks,
   and documentation updates.
6. Outside plan mode, implement the smallest correct change. Every line of code
   must earn its place; avoid speculative abstractions, boilerplate, and broad
   rewrites.
7. Make changed behavior reviewable as required by the documentation and
   scripting rules. Add or update contract-level comments and docstrings for
   non-trivial modules, classes, functions, and blocks; link focused repo-owned
   Markdown docs for deeper context; and add meaningful operation-boundary logs
   where runtime behavior must be reconstructed by humans, LLMs, or automation.
8. Update tests, documentation, and implementation notes according to the task's
   acceptance criteria and repo rules. The intermediate status `in progress` may
   be recorded now, but defer `solved` until the completion steps below finish.
9. Run enough verification to prove the acceptance criteria. At minimum, run:

```bash
git --no-pager diff --check
```

10. After verification passes, inspect the validated linked Issue when the
    `Public Tracking` field contains one. Revalidate its repository, task id,
    Tracking Key, and complete canonical-link block before changing either remote
    or local state.
11. If the validated Issue is open, close it with `gh issue close`, explicit
    `--repo "<owner>/<repository>"`, and `--reason completed`, using the required
    `GH_HOST=github.com`, `GH_PROMPT_DISABLED=1`, and `GH_TOKEN` contract. This
    completion close follows the approved task workflow and does not require a
    separate per-close preview. If it is already closed, require its state reason
    to be `completed`; do not silently reinterpret another close reason.
12. Read the Issue back without exposing its complete body and require GitHub to
    report closed state, completed state reason, the same repository and
    non-pull-request identity, and the exact task id, Tracking Key, and complete
    canonical-link block. Only after that full confirmation may the local task be
    written as `solved`. If the close or read-back fails, keep the task `blocked`,
    preserve its Issue URL, and report that implementation verification passed
    but public completion remains pending. A retry accepts an already completed
    and fully linked Issue and persists `solved` without repeating implementation
    side effects.
13. When the task has no full Issue URL and is ineligible for GitHub tracking or
    has a confirmed no-mirror result, write `solved` after local verification
    without a remote close. Never use a later eligibility or mirror result to
    bypass closure of an Issue that was already linked.
14. Use `blocked` when a user decision, failing dependency, unresolved
    specification gap, or required Issue closure prevents completion.

## `cancel`

1. Mark the target task with the repo's canonical cancelled-status value; default
   to `cancelled` if the template does not define one.
2. Record the reason under the repo's existing cancellation-reason field when
   present; otherwise use `Cancellation Reason`.
3. If the cancellation clearly applies to open child tasks too, update them in
   the same pass; otherwise report the required follow-up.
4. Cancellation is not solved completion. Do not close, label, or otherwise
   update a linked GitHub Issue automatically when a task is cancelled; the local
   cancellation status remains authoritative.

## `backlog`

1. Treat the remaining arguments as one idea title and stop if they are missing.
2. Create `docs/tasks/backlog.md` with a small English explanation when missing.
3. Record the current branch and whether it was already synchronized with its
   upstream before writing the backlog entry.
4. Append exactly one new `* <idea>` line to `docs/tasks/backlog.md`.
5. Stage and commit only `docs/tasks/backlog.md`, even when other worktree
   changes exist.
6. Do not update task files or other docs for this quick-capture path.
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
11. Do not inspect GitHub mirrors, require `GH_TOKEN`, or create an Issue for a
    backlog entry.

Report the created or updated task files, final statuses, mirror decision, Issue
approval result, Issue URL when applicable, implementation result, verification
commands, and any follow-up. Never include token values or credential details.

Do not create a heavier planning system than `docs/tasks/` plus recursive
`tasks/` directories created only when needed.
Do not write task docs outside `docs/tasks/`, including the `backlog` action,
which writes only `docs/tasks/backlog.md`.
Do not invent extra task actions beyond `spec`, `impl`, `cancel`, and `backlog`.
