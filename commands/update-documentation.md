---
description: Refresh documentation affected by recent changes
agent: build
---
Review the current repository state, recent git changes, and existing docs.
Follow @.opencode/rules/learn.md,
@.opencode/rules/ai-ready-documentation.md,
@.opencode/rules/language-policy.md, and
@.opencode/rules/software-documentation.md.

If the user provided extra focus, use it as a hint:
$ARGUMENTS

Then:
1. Identify which docs actually need updates based on the recent changes.
2. When a repository-root `docs/` directory exists, always inspect
   `docs/index.html`. Create it when missing, or refresh stale project facts,
   commands, paths, and links while preserving useful project-specific styling.
   Keep it a compact, scan-friendly developer map rather than a marketing site
   or decorative dashboard. Keep its core content, CSS, and progressive
   JavaScript self-contained and directly usable through `file://` as required
   by the software documentation rule, including a restrictive content security
   policy that blocks runtime connections and external assets.
3. Validate the resulting index's relative local links and fragments. Confirm
   that its essential content remains available without JavaScript and that its
   initial load requires no server, runtime repository reads, or external
   resources. Do not create a `docs/` directory when the repository does not
   already have one.
4. Prefer updating the small set of repo-owned docs most likely to drift, for
   example `README.md`, `CONTRIBUTING.md`, and any directly affected docs under
   `docs/` if that tree exists.
5. Refresh counts, command lists, and file-path references when they are now
   stale.
6. Create a focused Markdown document when rationale, diagrams, examples, log
   fields, or operational detail would overload source comments. Add stable
   repository-relative links from the source and a backlink to the relevant
   implementation files.
7. Keep documentation proportional; do not create a large new docs structure
   unless the change truly requires it.
8. Report which files were updated, what changed, and any remaining manual
   follow-up.

Do not rewrite unrelated documentation just to make it look uniform.
Do not edit documentation inside checked-out dependencies or generated or
mounted paths such as `.opencode/` and `.devcontainer/` unless the user
explicitly targets that checkout as the source repository.
