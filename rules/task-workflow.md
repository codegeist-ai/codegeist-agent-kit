# Task Workflow

Keep task handoff small, traceable, and easy to resume.

## Before You Change Code

- Read the relevant rules and repo docs.
- Inspect the current scripts, docs, and dirty worktree directly.
- Choose the smallest reasonable scope for the change.

## Working Style

- Prefer a dedicated branch or worktree when the change is more than trivial.
- Keep one task focused on one behavior or workflow change.
- Use repo-local commands, docs, and reference material when they already
  exist.
- When behavior changes, update the matching docs in the same task.

## Repo Task Files

- Use local `docs/tasks/` when the repo needs tracked task handoff files.
- Treat each local task file as the source of truth for its scope, acceptance
  criteria, status, files, and verification. A GitHub Issue is a concise public
  pointer and discussion surface, not a duplicate specification.
- Use top-level task files as `docs/tasks/TNNN_<slug>.md` by default, starting
  at `T001`. Never reuse an id found in current task files or Git history.
- When a task gains child tasks, migrate it to `docs/tasks/TNNN_<slug>/task.md`
  and create child tasks under `docs/tasks/TNNN_<slug>/tasks/`.
- When a migrated task no longer has child tasks, collapse it back to the flat
  `docs/tasks/TNNN_<slug>.md` form and remove the empty task directory.
- Use the same migration rule recursively for child tasks under
  `<parent-task-dir>/tasks/`.
- Use child task ids as `<parent-id>_NN`, for example `T001_01` or
  `T001_01_01`.
- Keep one canonical representation per task: either `TNNN_<slug>.md` or
  `TNNN_<slug>/task.md`, never both.
- Keep each task self-contained; a task under another task still needs its own
  goal, acceptance criteria, verification, and file targets, with the `Parent`
  field linking back to the owning task.
- Give every task one random immutable `Tracking Key`. Use that key, rather than
  a predictable id or mutable path, to identify its linked Issue during retries.
- Keep task docs under `docs/` in English, even when the user discussion is in
  another language.
- Apply shared GitHub Issue tracking only when the repository registers
  `codegeist-agent-kit` as an initialized `.opencode` Git submodule. Verify the
  `.gitmodules` path, index gitlink mode `160000`, initialized submodule status,
  expected runtime files, and credential-free repository basename before mirror
  discovery or authentication. Do not require or disclose a particular source
  host.
- For repositories that do not meet the `.opencode` submodule contract, keep
  tasks without existing Issue links local, record `Public Tracking: not
  applicable (codegeist-agent-kit is not mounted at .opencode)`, and do not
  inspect GitHub mirrors, `GH_TOKEN`, or run `gh`. Ineligibility is not a task
  failure.
- Never replace an existing full Issue URL with a not-applicable value. When a
  previously linked task no longer meets project eligibility or conflicts with a
  later no-mirror result, preserve the URL and block until the contradiction is
  resolved; eligibility drift must not bypass required Issue completion.
- Declare the repository's GitHub mirror in `docs/tasks/README.md` as `GitHub
  Mirror: <URL>`. Use `GitHub Mirror: none` when no mirror exists. A declaration
  is authoritative and avoids requiring contributors to access the source forge.
- When no declaration exists, one unambiguous root-level `github.com` remote may
  be used and recorded; never infer a mirror from submodule remotes. If no GitHub
  remote exists, `/task` may inspect one unambiguous non-GitHub root repository's
  configured push mirrors through the read-only `tea api` command.
- Tea discovery requires the `api` capability introduced in Tea `v0.12.0`, an
  already configured non-interactive login, and source-repository administrator
  access. Remove `GH_TOKEN` from every Tea process because Tea can otherwise use
  it as a source-forge token. Never start Tea login setup or expose its raw API
  response; retain only credential-free GitHub repository identities.
- Treat unavailable Tea, missing login or access, non-success responses,
  ambiguous source repositories, and multiple GitHub push destinations as an
  unknown mirror. Keep the task `blocked`, preserve an existing Issue URL or use
  `Public Tracking: pending GitHub mirror verification` when none exists, do not
  inspect `GH_TOKEN` or run `gh`, and request an exact `GitHub Mirror:
  <URL|none>` declaration.
- A successful Tea result with no GitHub destination makes tracking not
  applicable for that run, but must not automatically persist `GitHub Mirror:
  none`; the push-mirror configuration can change and cannot rule out a manual
  mirror.
- Before creating GitHub state, require the declared or inferred mirror to exist,
  be unarchived, have Issues enabled, and not be a fork. Verify those properties
  with explicit-repository `gh` commands using only `GH_TOKEN`, while forcing
  `GH_HOST=github.com`. Do not rely on GitHub's mirror metadata because manually
  synchronized repositories do not reliably populate it.
- Create or reuse exactly one concise GitHub Issue for every top-level and child
  task when a mirror is confirmed. Store the full Issue URL in `Public Tracking`
  and include the task's Tracking Key in a hidden Issue marker so retries can
  avoid duplicates even when the task path changes. Automatic marker reuse must
  also validate the Issue author and complete canonical-link block.
- Reject pull requests and Issues linked to another task. An unmarked or
  incomplete Issue requires a preview of the exact canonical-link block plus
  explicit single-use user approval before `/task` edits it. A newly supplied
  exact cross-author link requires approval before storage but no body edit;
  merely supplying an Issue URL is not approval. Read approved linkage back and
  require its URL to be the sole valid marker match before persisting it.
- Treat an already stored URL with this task's exact Tracking Key and canonical
  block as a previously approved adoption even when another account authored the
  Issue. A newly supplied URL does not gain that trust until its author matches
  the active login or the user approves the exact linkage adoption.
- Immediately before an approved linkage edit, privately re-read the complete
  Issue and apply the approved block to that fresh body. Append only when no
  canonical material exists; replace one safely bounded stale or incomplete
  same-task block and reject ambiguous or duplicate material. Afterward,
  privately verify that all non-canonical content remains unchanged and that the
  URL is the sole valid marker match. GitHub offers no conditional Issue-body
  update for this endpoint, so keep the final race window explicit and block on
  any detected mismatch instead of claiming atomic preservation.
- Before creating any new Issue, show the user the exact repository, title, and
  complete body and obtain explicit approval for that preview in the current
  conversation. A task request or `/task spec` invocation is not approval.
  Approval is single-use and must be requested again after any preview change or
  failed creation attempt. Reusing an existing Issue does not require creation
  approval because it creates no new Issue.
- Create the local task before its Issue. If mirror verification, token
  validation, user approval, or Issue creation fails or remains pending, keep the
  task `blocked` with pending public tracking, or its existing Issue URL when one
  is under validation, so `/task spec` can retry safely.
- Do not require GitHub access for repositories without a mirror and without an
  existing Issue URL. Record `Public Tracking: not applicable (no GitHub mirror)`
  for those tasks, but never use a later no-mirror result to discard a link.
- Do not create Issues for backlog entries. Do not synchronize labels, projects,
  readiness, cancellation, or intermediate task statuses after linkage; only
  repair the canonical task path when a task moves and close the linked Issue as
  completed when verified implementation is ready to become `solved`.
- Use `/task spec "<title/context>"` to create and specify a task with the user
  before implementation.
- Use `/task impl <task-ref> [instructions]` to implement a sufficiently
  specified task. If the task is too vague, clarify and update the task before
  editing runtime files.
- Before implementing a task in an eligible repository with a confirmed mirror,
  require a validated Issue URL in `Public Tracking`; repair pending linkage
  first.
- For a task with a validated Issue, close that Issue with reason `completed`
  after implementation verification passes, read it back, and persist local
  status `solved` only after GitHub confirms the closed state, completed reason,
  non-pull-request identity, and complete canonical linkage. An already completed
  and fully linked Issue is an idempotent success. Any closure or read-back
  failure leaves the task `blocked` with its Issue URL so `/task impl` can retry
  completion without repeating implementation side effects.
- Capture paginated Issue and push-mirror API responses without writing raw
  pages, unmatched Issue bodies, remote addresses, or source-forge errors to tool
  output or durable files. Emit only normalized identities and the minimum match
  metadata required for a non-secret decision.
- Keep task work iterative: `spec` and `impl` can repeat as new constraints,
  implementation facts, or user instructions appear.
- Never let specification readiness overwrite a `blocked` status established by
  mirror discovery, authentication, approval, linkage, or completion handling.
- Keep `spec` focused and minimal. Capture direct implementation instructions
  when useful, but do not build broad option catalogs or implement code.
- Keep `impl` small and justified. Every changed line should support the task's
  acceptance criteria or documented implementation notes.
- Use the repo-local `/task` command for `spec`, `impl`, `cancel`, and `backlog`
  work when that workflow fits the task.
- Use `/task backlog <title>` when you want to save an idea quickly without
  turning it into an active task yet.
- For `/task backlog`, only local `docs/tasks/backlog.md` should be staged and
  committed; unrelated worktree changes must stay out of that quick-save path.

## Finishing A Task

- Run targeted verification for the changed behavior.
- Capture durable rule changes in `.opencode/rules/` when they belong in the
  shared workflow.
- Use `@.opencode/commands/learn.md` or `@.opencode/commands/save.md` when that
  workflow fits the repo.

## Repo-Specific Conventions

- Record stricter branch naming, Issue fields, or public-readiness conventions in
  repo-local docs instead of relying on implicit habits. Repo-local additions may
  refine the shared mirror workflow but must keep the local task authoritative.
