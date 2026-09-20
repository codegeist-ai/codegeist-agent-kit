#!/usr/bin/env bash
# release-copy.sh - smoke-test the release bundle file set.
#
# Why this exists:
# - `task release-copy` is shared by `release-build` and `test-release`.
# - The Taskfile invokes that internal task, then this script verifies the copied
#   bundle without creating branches, commits, pushes, or starting OpenCode.
#
# Inputs:
# - $1: release bundle directory created by `task test`.
#
# Related files:
# - Taskfile.yml

set -euo pipefail

target=${1:-}

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

assert_file() {
  [ -f "${target}/$1" ] || fail "missing file: $1"
}

assert_dir() {
  [ -d "${target}/$1" ] || fail "missing directory: $1"
}

assert_absent() {
  [ ! -e "${target}/$1" ] || fail "unexpected release path: $1"
}

command -v jq >/dev/null || fail "jq is required for config assertions"

if [ -z "${target}" ]; then
  fail "release bundle directory argument is required"
fi

if [ ! -d "${target}" ]; then
  fail "release bundle directory does not exist: ${target}"
fi

assert_file ".gitignore"
assert_file "LICENSE"
assert_file "README.md"
assert_file "opencode.json"
assert_file "playwright-mcp.json"
assert_dir "ai-scripts"
assert_dir "commands"
assert_dir "rules"
assert_dir "skills"
assert_file "commands/create-ai-script.md"
assert_file "commands/save.md"
assert_file "commands/task.md"
assert_file "commands/update-documentation.md"
assert_file "commands/verify-documentation.md"
assert_file "rules/ai-ready-documentation.md"
assert_file "rules/bash-scripts.md"
assert_file "rules/commit.md"
assert_file "rules/scripting-best-practices.md"
assert_file "rules/software-documentation.md"
assert_file "rules/task-workflow.md"
assert_file "skills/commit-message-guard/SKILL.md"

assert_absent ".git"
assert_absent ".gitmodules"
[ ! -e "${target}/INDEX.md" ] \
  || fail "INDEX.md must stay outside the .opencode release bundle"
assert_absent ".opencode"
assert_absent ".devcontainer"
assert_absent ".oc_local"
assert_absent ".github"
assert_absent "CONTRIBUTING.md"
assert_absent "docs"
assert_absent "tests"
assert_absent "Taskfile.yml"
assert_absent "compose.local.yml"
assert_absent "README_release.md"
assert_absent "commands/specify-task.md"
assert_absent "commands/plan-task.md"
assert_absent "commands/solve-task.md"
assert_absent "commands/finalize-task.md"
assert_absent "commands/work-task.md"
assert_absent "commands/memory-bank.md"
assert_absent "commands/update-chat.md"
assert_absent "rules/task-phases.md"
assert_absent "rules/chat.md"
assert_absent "rules/memory-bank.md"
assert_absent "rules/commit-conventions.md"
assert_absent "plugin"
assert_absent "skills/gh-auth"
assert_absent "skills/graphify"

if grep -R -E \
    'rules/(chat|memory-bank)\.md|commands/(update-chat|memory-bank)\.md|docs/memory-bank/chat\.md' \
    "${target}/commands" "${target}/rules" >/dev/null; then
  fail "release commands or rules still reference removed memory-bank files"
fi
if grep -R -F '@.opencode/skills/gh-auth/SKILL.md' \
    "${target}/ai-scripts" "${target}/commands" "${target}/rules" \
    "${target}/skills" "${target}/README.md" >/dev/null; then
  fail "release runtime still references the removed gh-auth skill"
fi
if grep -R -E '^[[:space:]]*([A-Z_][A-Z0-9_]*=[^[:space:]]+[[:space:]]+)*gh[[:space:]]+auth[[:space:]]+(login|status)([[:space:]]|$)' \
    "${target}/ai-scripts" "${target}/commands" "${target}/rules" \
    "${target}/skills" "${target}/README.md" >/dev/null; then
  fail "release runtime still invokes interactive or stored gh authentication"
fi
if grep -R -E '^[[:space:]]*tea[[:space:]]+login[[:space:]]+add([[:space:]]|$)' \
    "${target}/ai-scripts" "${target}/commands" "${target}/rules" \
    "${target}/skills" "${target}/README.md" >/dev/null; then
  fail "release runtime must not start Tea login setup during mirror discovery"
fi
if grep -R -F 'GITHUB_TOKEN' \
    "${target}/ai-scripts" "${target}/commands" "${target}/rules" \
    "${target}/skills" "${target}/README.md" >/dev/null; then
  fail "release runtime must use GH_TOKEN as the only GitHub token variable"
fi

cmp "LICENSE" "${target}/LICENSE" \
  || fail "release LICENSE content mismatch"
cmp "README_release.md" "${target}/README.md" \
  || fail "release README content mismatch"
cmp "commands/task.md" "${target}/commands/task.md" \
  || fail "release task command content mismatch"
cmp "commands/save.md" "${target}/commands/save.md" \
  || fail "release save command content mismatch"
cmp "commands/update-documentation.md" \
  "${target}/commands/update-documentation.md" \
  || fail "release documentation update command content mismatch"
cmp "commands/verify-documentation.md" \
  "${target}/commands/verify-documentation.md" \
  || fail "release documentation verification command content mismatch"
cmp "rules/software-documentation.md" \
  "${target}/rules/software-documentation.md" \
  || fail "release software documentation rule content mismatch"
cmp "rules/task-workflow.md" "${target}/rules/task-workflow.md" \
  || fail "release task workflow rule content mismatch"
cmp "rules/command-execution.md" "${target}/rules/command-execution.md" \
  || fail "release command execution rule content mismatch"

expected_gitignore=$(mktemp /tmp/opencode-release-gitignore.XXXXXX)
trap 'rm -f "${expected_gitignore}"' EXIT
cat >"${expected_gitignore}" <<'GITIGNORE'
node_modules/
bun.lock
package.json
package-lock.json
GITIGNORE

cmp "${expected_gitignore}" "${target}/.gitignore" \
  || fail "release .gitignore content mismatch"

jq -e '
  (.instructions == [
    "INDEX.md",
    ".opencode/rules/ai-ready-documentation.md",
    ".opencode/rules/ai-scripts.md",
    ".opencode/rules/command-execution.md",
    ".opencode/rules/commit.md",
    ".opencode/rules/tools.md",
    ".opencode/rules/devcontainer-tools.md",
    ".opencode/rules/directory-index.md",
    ".opencode/rules/excalidraw.md",
    ".opencode/rules/language-policy.md",
    ".opencode/rules/learn.md",
    ".opencode/rules/scripting-best-practices.md",
    ".opencode/rules/session-titles.md",
    ".opencode/rules/software-documentation.md",
    ".opencode/rules/software-tests.md",
    ".opencode/rules/task-workflow.md",
    ".opencode/rules/taskfile-and-script-creation.md",
    ".opencode/rules/temporary-storage.md"
  ]) and
  ((.instructions | map(select(test("graphify"; "i"))) | length) == 0) and
  ((has("plugin")) | not) and
  (.watcher.ignore | index("**/.codegeist/.local.env")) and
  (.watcher.ignore | index("**/.codegeist/secrets/**")) and
  (.permission.read[".codegeist/.local.env"] == "deny") and
  (.permission.read[".codegeist/secrets"] == "deny") and
  (.permission.read[".codegeist/secrets/**"] == "deny") and
  (.permission.external_directory["/tmp/**"] == "allow") and
  (.mcp.context7.type == "local") and
  (.mcp.playwright.type == "local") and
  (.mcp.playwright.command == ["npx", "-y", "@playwright/mcp@latest", "--sandbox", "--config", ".opencode/playwright-mcp.json"]) and
  (.mcp.playwright.environment.PLAYWRIGHT_MCP_USER_DATA_DIR == ".chrome") and
  ((.mcp.playwright.environment.PLAYWRIGHT_MCP_USER_DATA_DIR | contains("/mnt/codegeist")) | not) and
  (.mcp.grep_app.type == "remote") and
  (.mcp.fetch.type == "local") and
  ((.mcp | has("repomix")) | not)
' "${target}/opencode.json" >/dev/null \
  || fail "release opencode.json is missing expected OpenCode config"
if ! grep -F 'Store persistent secrets that are not disposable test fixtures under the' \
    "${target}/rules/temporary-storage.md" >/dev/null; then
  fail "temporary-storage rule is missing from the release"
fi
if ! grep -F 'In a non-disposable repository, never create a Git commit unless the current' \
    "${target}/rules/command-execution.md" >/dev/null \
    || ! grep -F 'do not ask for a second commit confirmation.' \
      "${target}/rules/command-execution.md" >/dev/null \
    || ! grep -F 'Do not select, invoke, or delegate to a commit-producing command' \
      "${target}/rules/command-execution.md" >/dev/null \
    || ! grep -F 'Requests merely to save files, persist edits, record' \
      "${target}/rules/command-execution.md" >/dev/null; then
  fail "command execution rule must require explicit commit authorization"
fi
if ! grep -F 'This file defines how to create an already-authorized commit; it never grants' \
    "${target}/rules/commit.md" >/dev/null; then
  fail "commit rule must not authorize commits"
fi
if grep -R -F '@.opencode/rules/commit-conventions.md' \
    "${target}/commands" "${target}/rules" "${target}/README.md" >/dev/null; then
  fail "release runtime must use commit.md as the sole commit convention"
fi
if ! grep -F 'Report `@.opencode/commands/save.md` as an available follow-up' \
    "${target}/rules/task-workflow.md" >/dev/null \
    || ! grep -F 'execute or delegate to it unless the current user request explicitly' \
      "${target}/rules/task-workflow.md" >/dev/null; then
  fail "task completion must not invoke save automatically"
fi
if ! grep -F 'Do not stage, commit, or push the backlog change.' \
    "${target}/commands/task.md" >/dev/null \
    || grep -F 'Stage and commit only `docs/tasks/backlog.md`' \
      "${target}/commands/task.md" >/dev/null; then
  fail "task backlog must remain an uncommitted local edit"
fi
if ! grep -F 'Invoking `/add-agent-kit` or asking for an upstream change is' \
    "${target}/commands/add-agent-kit.md" >/dev/null; then
  fail "add-agent-kit must stop for explicit commit authorization"
fi
if ! grep -F 'Execute this workflow only when the current user request explicitly invokes' \
    "${target}/commands/commit.md" >/dev/null \
    || ! grep -F 'Invoking `/save` is itself explicit authorization' \
      "${target}/commands/save.md" >/dev/null; then
  fail "commit-producing commands must enforce their direct authorization gates"
fi
if ! grep -F 'Do not ask for' "${target}/commands/save.md" >/dev/null \
    || ! grep -F 'a separate commit confirmation after invocation.' \
      "${target}/commands/save.md" >/dev/null; then
  fail "save invocation must not require redundant commit confirmation"
fi
if ! grep -F 'use the repo-local `/commit` workflow' \
    "${target}/rules/command-execution.md" >/dev/null \
    || ! grep -F 'full commit, rebase, and push workflow' \
      "${target}/commands/save.md" >/dev/null; then
  fail "plain commits must not inherit save side effects"
fi
if ! grep -F 'Stage only the intended coherent change set' \
    "${target}/commands/commit.md" >/dev/null \
    || ! grep -F 'Do not fetch, rebase, synchronize, or push a touched submodule' \
      "${target}/commands/commit.md" >/dev/null \
    || ! grep -F 'Do not push any repository or submodule unless the current user request' \
      "${target}/commands/commit.md" >/dev/null; then
  fail "commit command must stay local and exclude unrelated worktree changes"
fi
if ! grep -F 'Invoking `/release-build` is itself explicit authorization' \
    ".oc_local/commands/release-build.md" >/dev/null; then
  fail "local release invocation must authorize its documented write workflow"
fi
if ! grep -F 'release commit and push plus the full parent repository commit, rebase, and' \
    ".oc_local/commands/release-build.md" >/dev/null \
    && ! grep -F 'release commit and push plus the full parent repository commit, shared-submodule' \
      ".oc_local/commands/release-build.md" >/dev/null; then
  fail "local release authorization must disclose the complete save workflow"
fi
if grep -F 'ask one focused confirmation question' \
    ".oc_local/commands/release-build.md" >/dev/null; then
  fail "local release workflow must not request redundant commit confirmation"
fi
if grep -F '@.opencode/commands/update-submodules.md' \
    ".oc_local/commands/release-build.md" >/dev/null; then
  fail "local release workflow must not refresh shared submodules twice"
fi
jq -e '
  (.outputDir == ".chrome/playwright-mcp") and
  (.browser.browserName == "chromium") and
  (.browser.launchOptions.executablePath == "/usr/local/bin/chrome") and
  (.browser.launchOptions.headless == false) and
  (.browser.launchOptions.chromiumSandbox == true) and
  (.browser.launchOptions.ignoreDefaultArgs | index("--disable-blink-features=AutomationControlled")) and
  (.browser.contextOptions | not)
' "${target}/playwright-mcp.json" >/dev/null \
  || fail "release playwright-mcp.json is missing expected browser config"
if ! grep -F 'mktemp -d "${TMPDIR:-/tmp}/opencode-agent-kit.XXXXXX"' \
    "${target}/commands/add-agent-kit.md" >/dev/null; then
  fail "add-agent-kit command must recommend a user-owned temp source checkout"
fi
if ! grep -F 'command|rule|skill|config <description of the shared behavior>' \
    "${target}/commands/add-agent-kit.md" >/dev/null; then
  fail "add-agent-kit command must support shared config changes"
fi
if grep -F 'under `/tmp/opencode`' "${target}/commands/add-agent-kit.md" >/dev/null; then
  fail "add-agent-kit command must not recommend fixed /tmp/opencode checkout path"
fi
if ! grep -F 'The local task file is always the source of truth.' \
    "${target}/commands/task.md" >/dev/null; then
  fail "task command must keep the local task authoritative"
fi
if ! grep -F 'Optional GitHub Issue Tracking' "${target}/commands/task.md" >/dev/null; then
  fail "task command must define optional GitHub Issue tracking"
fi
if ! grep -F 'Supported actions are `spec`, `impl`,' \
    "${target}/commands/task.md" >/dev/null \
    || ! grep -F 'Do not invent extra task actions beyond `spec`, `impl`, `cancel`, and `backlog`.' \
      "${target}/commands/task.md" >/dev/null; then
  fail "task command must keep the existing action set"
fi
if ! grep -F 'collapse it back to its' "${target}/commands/task.md" >/dev/null \
    || ! grep -F 'Keep exactly one canonical representation for every task' \
      "${target}/commands/task.md" >/dev/null \
    || ! grep -F 'Keep every child task self-contained' \
      "${target}/commands/task.md" >/dev/null; then
  fail "task command must preserve recursive task hierarchy invariants"
fi
if ! grep -F 'For a task without a full GitHub Issue URL, enter Project Eligibility and the' \
    "${target}/commands/task.md" >/dev/null; then
  fail "task command must gate public tracking for unlinked tasks"
fi
if ! grep -F 'only when the user explicitly requests public' \
    "${target}/commands/task.md" >/dev/null; then
  fail "task command must require an explicit public-tracking request"
fi
if ! grep -F 'A pending value' "${target}/commands/task.md" >/dev/null \
    || ! grep -F 'does not authorize mirror discovery,' \
      "${target}/commands/task.md" >/dev/null; then
  fail "task command must not treat an old pending value as GitHub authorization"
fi
if ! grep -F 'Public Tracking: pending user approval for GitHub' \
    "${target}/commands/task.md" >/dev/null \
    || ! grep -F 'without an Issue, set `Public Tracking: not requested (user declined GitHub' \
      "${target}/commands/task.md" >/dev/null; then
  fail "task command must let pending unlinked tasks return to local implementation"
fi
if ! grep -F 'Preserve and keep `blocked` any other unlinked pending value from an earlier' \
    "${target}/commands/task.md" >/dev/null \
    || ! grep -F 'so it cannot be downgraded to `not requested`.' \
      "${target}/commands/task.md" >/dev/null; then
  fail "task command must reconcile uncertain pending remote results"
fi
if ! grep -F 'A full Issue URL in `Public Tracking` always activates the existing linked' \
    "${target}/commands/task.md" >/dev/null; then
  fail "task command must keep existing Issue URLs binding"
fi
if ! grep -F 'For a new task or a missing `Public' \
    "${target}/commands/task.md" >/dev/null \
    || ! grep -F 'Tracking` field, use `Public Tracking: not requested`.' \
      "${target}/commands/task.md" >/dev/null; then
  fail "task command must default new tasks to no public tracking"
fi
if ! grep -F -- '- **Public Tracking:** not requested' \
    "docs/tasks/template.md" >/dev/null; then
  fail "task template must default to no public tracking"
fi
if ! grep -F 'Made GitHub Issue tracking optional for `/task`.' \
    "${target}/README.md" >/dev/null; then
  fail "release README must document optional GitHub Issue tracking"
fi
if ! grep -F 'public tracking remains available if tracking' \
    "${target}/rules/task-workflow.md" >/dev/null \
    || ! grep -F 'is requested later through `/task spec`.' \
      "${target}/rules/task-workflow.md" >/dev/null; then
  fail "task workflow must allow later public-tracking opt-in through task spec"
fi
if ! grep -F 'path is exactly `.opencode`' \
    "${target}/commands/task.md" >/dev/null; then
  fail "task command must require the exact .opencode submodule path"
fi
if ! grep -F 'submodule mode `160000`' \
    "${target}/commands/task.md" >/dev/null; then
  fail "task command must verify the .opencode gitlink"
fi
if ! grep -F 'git submodule status -- .opencode' \
    "${target}/commands/task.md" >/dev/null; then
  fail "task command must require an initialized .opencode submodule"
fi
if ! grep -F 'repository basename to be exactly `codegeist-agent-kit`' \
    "${target}/commands/task.md" >/dev/null; then
  fail "task command must identify the codegeist-agent-kit submodule"
fi
if ! grep -F 'not mounted at .opencode' \
    "${target}/commands/task.md" >/dev/null; then
  fail "task command must keep ineligible repositories local"
fi
if ! grep -F 'the user has not explicitly requested public' \
    "${target}/commands/task.md" >/dev/null \
    || ! grep -F 'records declined Issue creation, or is a not-applicable result, do not inspect' \
      "${target}/commands/task.md" >/dev/null \
    || ! grep -F 'project eligibility, GitHub mirrors, Tea, or `GH_TOKEN`, and do not run `gh`.' \
      "${target}/commands/task.md" >/dev/null; then
  fail "task command must skip all public-tracking inspection when not requested"
fi
if ! grep -F 'Use `GH_TOKEN` as the only supported GitHub token environment' \
    "${target}/commands/task.md" >/dev/null; then
  fail "task command must require GH_TOKEN as its only token variable"
fi
if ! grep -F 'public-tracking request without an Issue URL, use `Public Tracking: pending' \
    "${target}/commands/task.md" >/dev/null \
    || ! grep -F 'GitHub mirror verification` and status `blocked` while tracking setup is' \
      "${target}/commands/task.md" >/dev/null; then
  fail "task command must distinguish active unknown-mirror tracking"
fi
if ! grep -F '`env -u GH_TOKEN tea api --help` succeeds' \
    "${target}/commands/task.md" >/dev/null; then
  fail "task command must isolate GH_TOKEN during the Tea capability check"
fi
if ! grep -F 'env -u' "${target}/commands/task.md" >/dev/null \
    || ! grep -F 'GH_TOKEN tea api --include --remote "<remote>" "<endpoint>"' \
      "${target}/commands/task.md" >/dev/null; then
  fail "task command must remove GH_TOKEN from Tea push-mirror requests"
fi
if ! grep -F '"repos/{owner}/{repo}/push_mirrors?page=<page>&limit=<limit>"' \
    "${target}/commands/task.md" >/dev/null; then
  fail "task command must query every page of source push mirrors"
fi
if ! grep -F 'require status `200`' \
    "${target}/commands/task.md" >/dev/null; then
  fail "task command must distinguish successful Tea responses"
fi
if ! grep -F 'requires source-repository administrator access' \
    "${target}/commands/task.md" >/dev/null; then
  fail "task command must document Tea push-mirror access requirements"
fi
if ! grep -F 'without allowing the raw response to reach tool' \
    "${target}/commands/task.md" >/dev/null; then
  fail "task command must not expose raw push-mirror responses"
fi
if ! grep -F 'Ask for an exact' "${target}/commands/task.md" >/dev/null \
    || ! grep -F '`GitHub Mirror: <URL|none>` declaration' \
      "${target}/commands/task.md" >/dev/null; then
  fail "task command must block unknown mirrors pending a declaration"
fi
if ! grep -F '`gh api --paginate --slurp`' \
    "${target}/commands/task.md" >/dev/null; then
  fail "task command must search every Issue page before creation"
fi
if ! grep -F 'without allowing raw pages or unmatched Issue bodies to' \
    "${target}/commands/task.md" >/dev/null; then
  fail "task command must not expose unrelated Issue bodies during lookup"
fi
if ! grep -F 'Never replace an existing full Issue URL with a not-applicable value.' \
    "${target}/commands/task.md" >/dev/null; then
  fail "task command must not discard existing Issue linkage"
fi
if ! grep -F 'an existing full Issue URL; otherwise set `Public Tracking` to pending GitHub' \
    "${target}/commands/task.md" >/dev/null; then
  fail "task command must preserve linkage when mirror discovery becomes unknown"
fi
if ! grep -F 'show the same preview, and require approval before invoking' \
    "${target}/commands/task.md" >/dev/null; then
  fail "task command must require approval before adopting an existing Issue"
fi
if ! grep -F 'validate through the explicit repository API that it is an Issue, not a pull' \
    "${target}/commands/task.md" >/dev/null; then
  fail "task command must reject pull request URLs during Issue adoption"
fi
if ! grep -F 'Reuse an already stored URL automatically when its exact Tracking Key and' \
    "${target}/commands/task.md" >/dev/null; then
  fail "task command must make approved cross-author Issue adoption idempotent"
fi
if ! grep -F 'When `Public Tracking` has no stored Issue URL, an automatic marker-only match' \
    "${target}/commands/task.md" >/dev/null; then
  fail "task command must scope author checks to untrusted marker-only discovery"
fi
if ! grep -F '`gh issue edit --repo "<owner>/<repository>" --body-file -`' \
    "${target}/commands/task.md" >/dev/null; then
  fail "task command must transport approved Issue edits safely"
fi
if ! grep -F 'report that the remote Issue changed but linkage could not yet be confirmed.' \
    "${target}/commands/task.md" >/dev/null; then
  fail "task command must report post-edit validation failures accurately"
fi
if ! grep -F 'Immediately after approval and before editing, read the complete Issue again' \
    "${target}/commands/task.md" >/dev/null \
    && ! grep -F 'Immediately after approval and before an edit, read the complete Issue again' \
      "${target}/commands/task.md" >/dev/null; then
  fail "task command must refresh Issue content immediately before adoption edits"
fi
if ! grep -F 'verify that all non-canonical' \
    "${target}/commands/task.md" >/dev/null; then
  fail "task command must preserve unrelated Issue content during adoption"
fi
if ! grep -F 'replace exactly' "${target}/commands/task.md" >/dev/null \
    || ! grep -F 'duplicate. Block when existing material cannot be isolated safely.' \
      "${target}/commands/task.md" >/dev/null; then
  fail "task command must replace rather than duplicate stale canonical blocks"
fi
if ! grep -F 'does not provide a conditional Issue-body update' \
    "${target}/commands/task.md" >/dev/null; then
  fail "task command must disclose the non-atomic GitHub Issue edit constraint"
fi
if ! grep -F '<!-- canonical-task-key: <tracking-key> -->' \
    "${target}/commands/task.md" >/dev/null; then
  fail "task command must use an unguessable path-independent Issue marker"
fi
if ! grep -F 'Generate one random UUID as `Tracking Key`' \
    "${target}/commands/task.md" >/dev/null; then
  fail "task command must generate one immutable random tracking key"
fi
if ! grep -F 'its author is the captured active login' \
    "${target}/commands/task.md" >/dev/null; then
  fail "task command must validate automatically matched Issue authors"
fi
if ! grep -F '<!-- canonical-task-link:start -->' \
    "${target}/commands/task.md" >/dev/null \
    || ! grep -F '<!-- canonical-task-link:end -->' \
      "${target}/commands/task.md" >/dev/null; then
  fail "task command must validate a bounded canonical Issue block"
fi
if ! grep -F '"repos/<owner>/<repository>/issues?state=all&per_page=100"' \
    "${target}/commands/task.md" >/dev/null; then
  fail "task command must quote its paginated all-state Issue endpoint"
fi
if ! grep -F 'invoke `gh repo view` with the explicit' \
    "${target}/commands/task.md" >/dev/null; then
  fail "task command must validate the explicit mirror target"
fi
if ! grep -F 'First try to resolve the first remaining argument as an exact existing task' \
    "${target}/commands/task.md" >/dev/null; then
  fail "task spec retries must update an existing task in place"
fi
if ! grep -F 'extract only the credential-free' \
    "${target}/commands/task.md" >/dev/null; then
  fail "task command must not persist credentials from Git remote URLs"
fi
if ! grep -F 'supplied or stored URL to equal that Issue URL' \
    "${target}/commands/task.md" >/dev/null; then
  fail "task command must reconcile supplied URLs with marker lookup"
fi
if ! grep -F 'marker lookup and require the returned URL to be its sole valid match before' \
    "${target}/commands/task.md" >/dev/null; then
  fail "task command must verify post-create Issue uniqueness"
fi
if ! grep -F 'Show the user the exact confirmed' \
    "${target}/commands/task.md" >/dev/null; then
  fail "task command must preview the exact Issue before creation"
fi
if ! grep -F 'Only an explicit affirmative response in the current conversation' \
    "${target}/commands/task.md" >/dev/null; then
  fail "task command must require explicit current user approval"
fi
if ! grep -F 'single-use: a changed repository, title, or body, or a failed creation attempt,' \
    "${target}/commands/task.md" >/dev/null; then
  fail "task command must not reuse stale Issue approval"
fi
if ! grep -F 'If the user declines or defers approval, set `Public Tracking: not requested' \
    "${target}/commands/task.md" >/dev/null \
    || ! grep -F '(user declined GitHub Issue creation)`' \
      "${target}/commands/task.md" >/dev/null; then
  fail "task command must record declined Issue creation as unrequested"
fi
if ! grep -F 'without the tracking blocker, report that no Issue was created, and stop only' \
    "${target}/commands/task.md" >/dev/null \
    || ! grep -F 'the public-tracking path. Continue the local `spec` or `impl` workflow.' \
      "${target}/commands/task.md" >/dev/null; then
  fail "task command must restore local progress when Issue creation is declined"
fi
if ! grep -F 'Only after approval, invoke `gh issue create`' \
    "${target}/commands/task.md" >/dev/null; then
  fail "task command must gate gh issue create behind approval"
fi
if ! grep -F 'An explicit request for public tracking is not approval to create or edit an' \
    "${target}/commands/task.md" >/dev/null; then
  fail "task command must keep public-tracking selection separate from approval"
fi
if ! grep -F 'Whenever any task path changes' \
    "${target}/commands/task.md" >/dev/null; then
  fail "task command must repair Issue linkage after every task path change"
fi
if ! grep -F 'completion closure, or completion' "${target}/commands/task.md" >/dev/null \
    || ! grep -F 'verification fails, keep the local task `blocked`' \
      "${target}/commands/task.md" >/dev/null; then
  fail "task command must block active or linked tracking when GitHub work fails"
fi
if ! grep -F 'close it with `gh issue close`' \
    "${target}/commands/task.md" >/dev/null; then
  fail "task command must close linked Issues after implementation verification"
fi
if ! grep -F '`--reason completed`' \
    "${target}/commands/task.md" >/dev/null; then
  fail "task command must close solved task Issues as completed"
fi
if ! grep -F 'canonical-link block. Only after that full confirmation may the local task be' \
    "${target}/commands/task.md" >/dev/null \
    || ! grep -F 'written as `solved`. If the close or read-back fails' \
      "${target}/commands/task.md" >/dev/null; then
  fail "task command must confirm Issue closure before persisting solved"
fi
if ! grep -F 'non-pull-request identity, and the exact task id, Tracking Key, and complete' \
    "${target}/commands/task.md" >/dev/null \
    || ! grep -F 'canonical-link block. Only after that full confirmation' \
      "${target}/commands/task.md" >/dev/null; then
  fail "task command must revalidate canonical linkage after Issue closure"
fi
if ! grep -F 'Read the Issue back without exposing its complete body' \
    "${target}/commands/task.md" >/dev/null; then
  fail "task command must keep completion read-back bodies private"
fi
if ! grep -F 'and fully linked Issue and persists `solved` without repeating implementation' \
    "${target}/commands/task.md" >/dev/null \
    || ! grep -F 'side effects.' "${target}/commands/task.md" >/dev/null; then
  fail "task command must make completion closure retryable"
fi
if ! grep -F 'Never overwrite an active tracking-related' \
    "${target}/commands/task.md" >/dev/null; then
  fail "task spec must preserve active tracking-related blocked status"
fi
if ! grep -F 'When the task has no full Issue URL and `Public Tracking` is `not requested`,' \
    "${target}/commands/task.md" >/dev/null \
    || ! grep -F 'An unresolved pending value is not eligible for this local completion' \
      "${target}/commands/task.md" >/dev/null; then
  fail "task impl must solve verified unlinked tasks locally"
fi
if ! grep -F 'Do not inspect GitHub mirrors, require `GH_TOKEN`, or create an Issue' \
    "${target}/commands/task.md" >/dev/null; then
  fail "task command must exclude backlog entries from GitHub tracking"
fi
if ! grep -F 'GH_PROMPT_DISABLED=1' \
    "${target}/rules/command-execution.md" >/dev/null; then
  fail "command execution rule must disable interactive GitHub prompts"
fi
if ! grep -F 'GH_HOST=github.com' \
    "${target}/rules/command-execution.md" >/dev/null; then
  fail "command execution rule must force the GitHub.com host"
fi
if ! grep -F 'test -n "${GH_TOKEN:-}" && \' \
    "${target}/README.md" >/dev/null; then
  fail "release README must stop before gh when GH_TOKEN is missing"
fi
if ! grep -F 'GH_HOST=github.com GH_PROMPT_DISABLED=1 gh api user' \
    "${target}/README.md" >/dev/null; then
  fail "release README must validate GH_TOKEN against GitHub.com"
fi

printf 'PASS: release-copy bundle smoke test\n'
