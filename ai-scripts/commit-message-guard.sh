#!/usr/bin/env bash
# commit-message-guard.sh - validate commit message inputs and optionally commit
#
# Why this exists:
# - prevent literal \n escape sequences from leaking into git commit messages
# - standardize a safe env-var based git commit command for AI workflows
# - verify the stored commit message after execution instead of trusting drafts
#
# Inputs:
# - ARG_COMMIT_SUBJECT: required commit subject line
# - ARG_COMMIT_BODY: optional commit body with real newlines when needed
# - ARG_EXECUTE: set to 1 to run git commit after validation
#
# Related files:
# - .opencode/rules/commit.md
# - .opencode/commands/commit.md
# - .opencode/commands/save.md

set -euo pipefail

subject="${ARG_COMMIT_SUBJECT-}"
body="${ARG_COMMIT_BODY-}"
execute="${ARG_EXECUTE-0}"

fail() {
  printf 'STATUS=error\n'
  printf 'MESSAGE=%s\n' "$1"
  exit 1
}

contains_literal_newline_escape() {
  [[ "$1" == *\\n* ]]
}

if [[ -z "$subject" ]]; then
  fail 'ARG_COMMIT_SUBJECT is required'
fi

if contains_literal_newline_escape "$subject"; then
  fail 'ARG_COMMIT_SUBJECT must not contain literal \\n sequences'
fi

if contains_literal_newline_escape "$body"; then
  fail 'ARG_COMMIT_BODY must not contain literal \\n sequences'
fi

printf 'STATUS=ok\n'
printf 'EXECUTE=%s\n' "$execute"
printf 'HAS_BODY=%s\n' "$([[ -n "$body" ]] && printf yes || printf no)"

if [[ -n "$body" ]]; then
  printf 'COMMAND=git commit -m "$ARG_COMMIT_SUBJECT" -m "$ARG_COMMIT_BODY"\n'
else
  printf 'COMMAND=git commit -m "$ARG_COMMIT_SUBJECT"\n'
fi

if [[ "$execute" != "1" ]]; then
  exit 0
fi

if [[ -n "$body" ]]; then
  git commit -m "$subject" -m "$body"
else
  git commit -m "$subject"
fi

stored_message="$(git --no-pager log -1 --format=%B)"
if contains_literal_newline_escape "$stored_message"; then
  fail 'git stored a literal \\n sequence in the final commit message'
fi

printf 'COMMIT=%s\n' "$(git --no-pager rev-parse --short=12 HEAD)"
