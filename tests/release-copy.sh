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
assert_file "README.md"
assert_file "opencode.json"
assert_file "plugin/graphify.js"
assert_file "plugin/graphify.md"
assert_dir "ai-scripts"
assert_dir "commands"
assert_dir "rules"
assert_dir "skills"
assert_dir "plugin"

assert_absent ".git"
assert_absent ".gitmodules"
[ ! -e "${target}/INDEX.md" ] \
  || fail "INDEX.md must stay outside the .opencode release bundle"
assert_absent ".opencode"
assert_absent ".devcontainer"
assert_absent ".oc_local"
assert_absent "Taskfile.yml"
assert_absent "compose.local.yml"
assert_absent "README_release.md"
assert_absent "commands/specify-task.md"
assert_absent "commands/plan-task.md"
assert_absent "commands/solve-task.md"
assert_absent "commands/finalize-task.md"
assert_absent "commands/work-task.md"
assert_absent "rules/task-phases.md"

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
  (.instructions | index("plugin/graphify.md")) and
  (.plugin | index("plugin/graphify.js")) and
  (.permission.external_directory["/tmp/**"] == "allow") and
  (.mcp.context7.type == "local") and
  (.mcp.grep_app.type == "remote") and
  (.mcp.fetch.type == "local") and
  (.mcp.repomix.type == "local")
' "${target}/opencode.json" >/dev/null \
  || fail "release opencode.json is missing expected OpenCode config"
node --check "${target}/plugin/graphify.js" >/dev/null \
  || fail "release graphify plugin has invalid syntax"

printf 'PASS: release-copy bundle smoke test\n'
