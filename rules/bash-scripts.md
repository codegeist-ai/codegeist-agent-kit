# Bash Script Rules

Use these rules whenever you create or update repo-owned Bash scripts.

## Purpose

- Keep Bash scripts short, direct, and easy to scan.
- Prefer a straight execution path over defensive boilerplate.
- Treat the expected runtime environment as part of the script contract.
- Make important execution decisions and side effects reviewable from comments
  and logs without requiring a reader to reconstruct the whole script.

## Defaults

- Prefer Bash for small repo entrypoints and glue scripts.
- Start Bash scripts with `#!/usr/bin/env bash` and `set -euo pipefail`
  unless a concrete reason requires different behavior.
- Keep scripts non-interactive by default.

## Keep Scripts Small

- Keep one-off Bash scripts linear and compact.
- Avoid helper functions when logic is only used once.
- Avoid extra abstraction layers for simple command handoff.
- Prefer a few explicit variables over large wrapper structures.

## Avoid Useless Checks

- Do not add `command -v`, `require_cmd`, or similar checks for tools that are
  part of the expected environment.
- Do not add defensive variable-content validation when the script contract and
  `set -euo pipefail` already make incorrect usage fail clearly.
- Do not wrap commands in `if ! ...; then exit 1; fi` when direct execution
  already gives the real failure path.
- Do not add fallback branches for unsupported or unintended inputs unless the
  script must present a clearer user-facing contract.

## Inputs And Flow

- Prefer explicit arguments and env vars over hidden defaults.
- Resolve important paths once, then use them directly.
- Keep option parsing minimal and proportional to the script's real needs.
- Prefer direct `exec ...` handoff when the script does not need host-side
  cleanup after launching the target command.

## Comments

- Keep comments in English.
- Give non-trivial scripts a short header that explains purpose, inputs, side
  effects, failure behavior, and related entrypoints or docs.
- Comment the contract of non-trivial functions and explain why important
  branches, destructive actions, or sharp edges exist.
- Link to a repo-owned Markdown file and section when deeper rationale,
  diagrams, or operational instructions would otherwise overload the script.
  Keep a concise local summary beside the link.
- Do not narrate obvious shell syntax line by line.

## Logging

- Emit logs at meaningful operation boundaries: start, selected non-secret
  inputs or targets, important decisions, side effects, completion, and failure.
- Prefer stable one-line records with explicit fields and shared logging helpers.
  Use JSON when it is the established machine-readable contract.
- Send diagnostics to stderr and keep stdout available for documented payloads.
- Make LLM-facing output deterministic and easy to scan: use stable event names,
  explicit status values, useful paths or counts, and actionable failure detail.
- Avoid per-line or per-iteration noise, interactive spinners, ANSI-only state,
  secrets, credentials, and unbounded dumps.

## Review

- Remove validation or structure that does not add real safety.
- Prefer the smallest script that still makes the contract clear.
- Remove boilerplate that obscures the contract, but retain the explanatory
  comments and operation-boundary logs needed to review behavior safely.
