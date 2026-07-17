---
name: spec-visuals
version: 1.0.0
description: |
  Add visuals to a spec file so it is faster to understand and shorter to read.
  Use when the user wants a spec (a task spec in `tasks/`, a project `spec.md`,
  a design doc, an RFC) visualized, condensed, or made easier to grasp. Visuals
  are ASCII diagrams, Mermaid diagrams, and tables — never emojis, never images.
  Visuals replace prose rather than decorating it: every diagram or table added
  must delete the paragraphs it makes redundant, without losing key concepts,
  constraints, or machine-readable structure the spec's tooling depends on.
license: MIT
compatibility: claude-code opencode
allowed-tools:
  - Read
  - Write
  - Edit
  - Grep
  - Glob
  - Bash
  - AskUserQuestion
---

# Spec Visuals: replace prose with structure

You rework a spec so that its structure carries the information instead of its
sentences. A reader should be able to scan the visuals and understand the
system; the remaining text exists only for what a diagram or table cannot say.

The governing rule: **a visual earns its place by deleting text.** If you add a
diagram and keep the paragraphs it summarizes, you made the spec longer and
worse. Every visual must replace the prose it covers. If nothing can be
deleted, the visual is decoration — leave it out.

## What counts as a visual

Three forms, in order of preference:

| Form | Use for | Renders where |
|---|---|---|
| Table | Enumerable facts: lists with 2+ attributes per item, comparisons, mappings, options | Everywhere |
| ASCII diagram | Topology: boxes and arrows, layered architecture, data flow, layout, trees | Everywhere, including plain terminals |
| Mermaid | Relationships too dense for ASCII: sequence diagrams, state machines, dependency graphs with cross-links | GitHub, editors, artifact viewers — not plain terminals |

Prefer ASCII over Mermaid when both work: specs are read in terminals and by
agents, and ASCII degrades nowhere. Reach for Mermaid when the ASCII version
would need crossing lines or more than ~6 interacting participants.

**Never use emojis.** Not in diagrams, not as bullet markers, not as status
indicators. Box-drawing characters, arrows (`->`, `-->`, `│ ─ ┌ ┐ └ ┘ ├ ┤`),
and plain ASCII punctuation are the full palette. Status is words (`done`,
`pending`) or checkbox syntax, never symbols like check marks or crosses
outside of markdown `- [x]` syntax.

## Content-to-visual mapping

Scan the spec for these prose patterns and convert them:

| Prose pattern | Convert to |
|---|---|
| Paragraph describing how parts connect ("X calls Y which writes to Z") | ASCII box-and-arrow diagram |
| Layered/tiered description (CLI over service over store over DB) | ASCII stacked-box diagram |
| Bullet list where each item has a path + a reason, or a name + 2+ attributes | Table |
| Narrated call sequence ("first the client sends..., then the server...") | Mermaid `sequenceDiagram`, or numbered ASCII flow if short |
| Lifecycle / status transitions described in sentences | Mermaid `stateDiagram-v2` or ASCII state chain (`draft -> active -> archived`) |
| Comparison prose ("unlike A, B does...; C on the other hand...") | Table with one row per alternative |
| Directory or file layout described in words | ASCII tree |
| Dependency or coordination notes scattered through the text | One dependency graph near the top |
| Config keys, flags, enum variants explained one per sentence | Table: name, type, default, meaning |
| Formula or calculation buried in a paragraph | Extracted into a fenced block or small table of variables |

Content that should **stay as text**: rationale ("why this approach"),
constraints and invariants ("must never block the UI thread"), warnings, and
anything normative that tooling or an implementing agent parses (see the
contract section below). One sentence of prose stating a hard rule beats a
diagram that implies it.

## ASCII conventions

- Max width 80 columns so nothing wraps in a terminal.
- Use box-drawing characters (`┌ ─ ┐ │ └ ┘ ├ ┤ ┬ ┴ ┼`) for boxes, `-->` or
  `──▶` for directed edges. Pick one arrow style per spec and stick to it.
- Label every arrow that carries non-obvious meaning (`--writes-->`,
  `-- SIGTERM -->`).
- Align boxes on a grid; ragged diagrams read worse than the prose they
  replaced.
- Put diagrams in fenced code blocks with no language tag (or `text`) so
  markdown renderers preserve the whitespace.

Example — this paragraph:

> The CLI parses the command and hands it to the task service. The service
> validates against the rules engine and, if valid, persists through the
> store, which owns the SQLite connection. The TUI subscribes to store change
> events and re-renders.

becomes:

```
┌─────┐     ┌──────────────┐  validate   ┌──────────────┐
│ CLI │────▶│ task service │────────────▶│ rules engine │
└─────┘     └──────┬───────┘             └──────────────┘
                   │ persist
                   ▼
            ┌────────────────┐  change events   ┌─────┐
            │ store (SQLite) │─────────────────▶│ TUI │
            └────────────────┘                  └─────┘
```

and the paragraph is deleted. The only prose worth keeping from it is a
constraint, if one existed ("the store owns the only SQLite connection"),
stated in one line under the diagram.

## Mermaid conventions

A Mermaid block with a syntax error renders as a raw code block with no
warning, so keep the syntax conservative:

- Quote any node or edge label containing `(`, `)`, `/`, `:`, or `,`:
  `A["store (SQLite)"]`.
- In `sequenceDiagram`, alias participants whose names contain spaces:
  `participant TS as task service`.
- No `style`, `classDef`, or theme directives — specs must render the same in
  every viewer, and color is not information.
- Prefer `graph TD` over `graph LR` once there are more than ~4 nodes;
  top-down survives narrow viewports.
- Keep one diagram per fenced block, tagged `mermaid`.

## Tables

- Every column must differentiate rows. A column with the same value in every
  row is a sentence above the table, not a column.
- Keep cells short: fragments, paths, numbers. If a cell needs a full
  sentence, that row's content is rationale — leave it as prose.
- A two-item comparison is usually better as one sentence. Tables start
  earning their keep at 3+ rows.

Example — a **Read before starting** list from a task spec:

```markdown
**Read before starting (whole-milestone context):**
- `internal/store/store.go` — Store interface this task extends
- `internal/cli/add.go` — command-registration pattern to mirror
- `spec.md` — "Timers" section: duration rounding rules
- `tasks/webhooks.md` — shares the event bus introduced here
```

becomes:

```markdown
**Read before starting (whole-milestone context):**

| File | Why |
|---|---|
| `internal/store/store.go` | Store interface this task extends |
| `internal/cli/add.go` | command-registration pattern to mirror |
| `spec.md` ("Timers") | duration rounding rules |
| `tasks/webhooks.md` | shares the event bus introduced here |
```

## The spec contract: what you must not break

Task specs in this setup (see `commands/tasks/new.md` and `commands/tasks/do.md`)
are executed by an agent that walks their structure. These elements are
machine-read — keep them byte-compatible:

| Element | Rule |
|---|---|
| YAML frontmatter (`title`, `description`, `created_at`, `updated_at`) | Untouched, except bump `updated_at` to today |
| `- [ ]` / `- [x]` checkbox lines | Keep as checkboxes; you may tighten wording, never merge or split items |
| `Test:` lines | Verbatim — each is a required test case |
| Sub-bullet labels (`**Read:**`, `**Update callers:**`, `**Docs to fetch:**`, `**Stdlib / built-ins:**`, `**New dependency:**`, `**Migration:**`, `**Tools the agent should use:**`) | Keep label + content; multiple parallel entries under one label may become a table under that label |
| Code fences with type/function signatures | Untouched — they are the interface contract |
| File paths and line ranges | Verbatim, everywhere |
| **Version bump** item and its "do not pre-compute" instruction | Untouched |
| Final `- [ ] Verify:` item | Keep the checkbox; the steps inside may become a numbered flow |
| `**Depends on:**` / `**Coordinate with:**` links | Keep the links; may additionally appear in a dependency diagram |
| C4 depth annotations (`(Code)`, `(Component)`, `(Container)`) | Verbatim on every checkbox item |

What this leaves you free to visualize inside a task spec: the container
description paragraphs (usually the biggest win — turn them into an
architecture diagram plus 1-2 sentences of rationale), the **Read before
starting** list (table), behavioral notes under components (flow or state
diagrams), multi-entry **Update callers** lists (table), and the Verify steps
(numbered flow).

For free-form specs (`spec.md`, design docs, RFCs) there is no execution
contract — apply the mapping table everywhere it fits.

If you cannot tell whether a prose block is machine-read by some tool, use
AskUserQuestion rather than guessing — a wrongly deleted contract line is the
one mistake this skill must never make.

## Specs that already have visuals

Re-running this skill on a spec that was already visualized must not stack
diagrams. For each existing visual: verify it still matches the surrounding
text and the code it describes; update it in place if stale; never add a
second diagram or table covering ground an existing one already covers —
extend or replace the existing one instead.

## Process

1. **Read the whole spec first.** Note which tooling consumes it (task spec
   vs. free-form) to know which elements are contractual.
2. **Mark candidates.** For each section, ask: does the prose describe
   structure, sequence, or enumerable facts? If yes, it is a candidate.
3. **Convert, then delete.** Write the visual, then remove every sentence it
   now covers. Keep only rationale, constraints, and normative rules as text
   near the visual.
4. **Verify nothing was lost.** Diff mentally against the original: every
   file path, number, constraint, edge case, and warning from the deleted
   prose must appear in a visual or a surviving sentence. If something has no
   home, it was a constraint — restore it as one line of text.
5. **Verify the contract.** For task specs: same number of checkboxes, same
   `Test:` lines, frontmatter intact (with `updated_at` bumped), all sub-bullet
   labels present.
6. **Check rendering.** Confirm ASCII blocks are fenced, under 80 columns, and
   aligned; confirm Mermaid blocks are syntactically valid; confirm tables
   have consistent column counts.
7. **Report the line count.** State the spec's original and final line counts.
   If the spec grew, you decorated instead of replaced — remove the weakest
   visual or delete the prose it should have displaced.

## Calibration

- A short spec (under ~40 lines) rarely needs more than one visual. Do not
  manufacture diagrams for content a reader absorbs in one glance.
- A visual that needs a paragraph to explain it has failed — simplify it or
  revert to prose.
- When the user asks you to *write* a spec (not rework one), apply this skill
  from the start: draft structure-heavy sections directly as diagrams and
  tables instead of writing prose you would then convert.
