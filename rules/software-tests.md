# Software Tests

Use these rules whenever you add, update, or review software tests.

## Purpose

- Keep tests focused on real behavior and user-visible contracts.
- Prefer small, deterministic tests over broad or fragile coverage.
- Treat tests as part of the implementation, not as optional follow-up work.

## Test-First Mindset

- When a behavior changes, add or update the relevant test first when feasible.
- For bug fixes, prefer a regression test that fails before the fix and passes after it.
- Keep the test scope as small as possible while still proving the behavior.

## What To Test

- Test observable behavior, inputs, outputs, exit codes, and side effects.
- Prefer contract-level assertions over implementation details.
- Cover the main success path first, then add failure-path coverage when it matters.
- Add edge-case checks only when they protect a real risk or known bug class.

## Test Style

- Use the repo's existing test entrypoints and conventions when they exist.
- Keep tests easy to read, easy to run, and easy to debug.
- Use clear expected-versus-actual failures.
- Keep test fixtures and setup minimal.

## Reliability

- Keep tests deterministic and non-interactive.
- Avoid time-sensitive, network-dependent, or environment-fragile checks unless the repo explicitly needs them.
- Prefer local smoke tests when they verify the real contract cheaply.
- Mock only when the real dependency is too heavy, too slow, or too unstable for the intended test scope.

## Maintenance

- Update tests in the same task when behavior changes.
- Do not delete or weaken a failing test without intentionally replacing the lost coverage.
- If a behavior cannot be tested reasonably, state that clearly in the task result.

## Verification

- Re-run the affected tests after changing code.
- Prefer the narrowest test command that proves the change.
- Use the repo's main test entrypoint for final verification when that path exists.
