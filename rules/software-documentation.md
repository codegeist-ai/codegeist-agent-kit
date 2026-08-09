# Software Documentation

Use these rules whenever you create or update repo-local software
documentation.

## Purpose

- Keep software documentation focused on current behavior, usage, and
  maintenance-relevant context.
- Help a later human or AI understand what the software does, how it is used,
  and where the sharp edges are.

## What To Document

- Purpose and scope.
- The current contract or behavior, not stale plans.
- Important entrypoints, commands, file paths, and related files.
- Inputs, outputs, dependencies, and relevant configuration.
- Constraints, failure modes, and operational sharp edges.
- Important runtime events, log fields, and diagnostic conventions when
  operators, tests, LLMs, or automation depend on them.
- Real workflows or examples when they make usage clearer.

## Recommended Structure

- Start with a clear title and a one-line summary.
- Split larger topics into small sections with concrete headings.
- Use short command examples or file references when they improve clarity.
- Name related files and entrypoints explicitly when readers need to move
  between them.
- Use stable repository-relative links and section anchors when source comments
  or other docs need deeper rationale, diagrams, examples, or operational detail.
- Prefer a focused Markdown document when the explanation would make source
  comments hard to scan. Keep a short contract summary in the source and link
  the document back to the relevant implementation files.
- Keep background material short unless it changes implementation or usage.

## Diagrams

- Use diagrams when they give a faster overview than prose alone.
- Prefer PlantUML for structured technical views such as component, class,
  sequence, deployment, activity, or state diagrams.
- Prefer Excalidraw for editable overview sketches, freeform system maps, or
  diagrams that need lightweight annotation and discussion.
- Use diagrams both for high-level overviews and for focused detail views when a
  subsystem has non-obvious structure or flow.
- Keep diagram source files alongside the documentation they support so updates
  stay local and discoverable.
- When using Excalidraw exports, follow the separate `.excalidraw.svg` format
  rule in `excalidraw.md`.

## Writing Style

- Document the current truth, not an aspirational future state.
- Prefer concise, high-signal sections over long prose.
- Explain why and constraints; avoid paraphrasing obvious code.
- Make source-to-document relationships explicit enough that a reviewer can
  move in either direction without searching by guesswork.
- Rewrite stale sections instead of appending contradictory updates.
- Keep examples minimal and realistic.
- Call out assumptions or open gaps explicitly when they still matter.

## Maintenance

- Update documentation in the same task when behavior changes.
- Remove or rewrite obsolete statements promptly.
- Keep documentation proportional to the complexity of the software.
- Validate repo-relative source and documentation links when either side moves.
- Refresh related diagrams when the documented architecture or behavior changes.
- Follow repo-local path, structure, and language rules when a repo defines
  them.
