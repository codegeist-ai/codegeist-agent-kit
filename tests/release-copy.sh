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
assert_file "commands/task.md"
assert_file "commands/update-documentation.md"
assert_file "commands/verify-documentation.md"
assert_file "rules/ai-ready-documentation.md"
assert_file "rules/bash-scripts.md"
assert_file "rules/scripting-best-practices.md"
assert_file "rules/software-documentation.md"

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
assert_absent "plugin"
assert_absent "skills/graphify"

if grep -R -E \
    'rules/(chat|memory-bank)\.md|commands/(update-chat|memory-bank)\.md|docs/memory-bank/chat\.md' \
    "${target}/commands" "${target}/rules" >/dev/null; then
  fail "release commands or rules still reference removed memory-bank files"
fi

cmp "LICENSE" "${target}/LICENSE" \
  || fail "release LICENSE content mismatch"

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
  (.instructions | index("INDEX.md")) and
  ((.instructions | index(".opencode/INDEX.md")) | not) and
  ((.instructions | index(".opencode/rules/task-phases.md")) | not) and
  ((.instructions | index(".opencode/rules/chat.md")) | not) and
  ((.instructions | index(".opencode/rules/memory-bank.md")) | not) and
  (.instructions | index(".opencode/rules/tools.md")) and
  ((.instructions | map(select(test("graphify"; "i"))) | length) == 0) and
  ((has("plugin")) | not) and
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

printf 'PASS: release-copy bundle smoke test\n'
