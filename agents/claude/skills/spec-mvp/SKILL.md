---
name: spec-mvp
version: 1.0.0
description: |
  Distill a task spec down to its MVP — the smallest vertical slice that
  proves the feature actually works. Use when a spec (usually one produced by
  `/tasks:new` or `/tasks:brief`) has grown past ~200 net LoC, bundles
  nice-to-haves with the core, or the user asks "what's the MVP here", "cut
  this spec down", "what's the minimum to validate this". The skill first
  states what problem the spec exists to solve, then classifies every
  component as core or deferrable, and proposes a trimmed spec of ≤200 net
  LoC whose Verify step exercises the real user-observable outcome — not
  just a smoke test that the code runs.
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

# Spec MVP: the smallest slice that proves it works

A spec balloons the same way every time: the core idea is 80 LoC, and then
config options, extra flags, error taxonomies, second output formats, and
"while we're here" refactors push it past 1000. This skill reverses that. You
find the one thing the spec exists to prove, keep the thinnest end-to-end
path that proves it, and defer everything else — explicitly, so nothing is
silently lost.

The governing rule: **the MVP is a vertical slice, not a horizontal layer.**
"Just the domain types" is not an MVP — nothing observable works. The MVP
cuts through every layer the feature needs (CLI → service → store, or
whatever the project's stack is) but takes the narrowest possible path
through each: one command, one happy path, one honest error, hardcoded
defaults. Target: **≤200 net LoC** (added + modified + deleted, excluding
generated code, lockfiles, and fixtures).

## Step 1: Extract the hypothesis

Before touching components, write down what the spec is trying to solve as a
single falsifiable sentence in the shape:

> A user can **\<do X\>** and observe **\<outcome Y\>**.

Derive it from the spec's container description and the original brief. If
the spec never states its problem — only its solution — reconstruct the
problem from the components and confirm it with AskUserQuestion. Everything
downstream keys off this sentence: a component is core only if the sentence
becomes unprovable without it.

If you find **two or more independent hypotheses** in one spec, that is a
split, not a trim — say so and hand off to `/tasks:brief` rather than
picking a favorite.

## Step 2: Classify every component

Walk each `- [ ]` component and assign exactly one class:

| Class | Test | Fate |
|---|---|---|
| **Core** | Removing it makes the hypothesis unprovable | Keep |
| **Enabler** | Core cannot compile or run without it (wiring, registration, minimal schema) | Keep, at minimum width |
| **Deferrable** | The hypothesis is provable without it; it hardens, broadens, or polishes | Cut, record |
| **Speculative** | Serves a future need no current component consumes | Cut, record |

Common deferrables to hunt for — each of these is a cut unless the
hypothesis literally requires it:

| Bloat pattern | MVP replacement |
|---|---|
| Config option / flag with a sensible default | Hardcode the default; no flag |
| Multiple input surfaces (CLI + TUI + API) | The one surface the hypothesis names |
| Multiple output formats (json + table + csv) | One format |
| Error taxonomy with typed variants | One honest error path with a clear message |
| Retry / backoff / caching / perf work | Do it slow and correct |
| Interface + single implementation | Concrete type; extract the interface when a second impl exists |
| Backfill / data migration for old rows | Schema change only; new rows only |
| Edge-case handling for inputs the hypothesis never produces | Reject with an error |
| Docs beyond a CHANGELOG entry | CHANGELOG entry only |
| "While we're here" refactors | Separate spec |

Enablers get trimmed too: if a component is load-bearing but wider than the
core path needs (a store method with four query variants when the slice uses
one), keep the component and cut it to the one variant.

## Step 3: The validation bar — working, not smoking

The reason this skill exists is that a small spec can still be a fake one: a
`Verify:` step that runs the command and checks the exit code proves the code
runs, not that the feature works. The MVP's final `Verify:` must observe
**outcome Y from the hypothesis, through the real stack**.

| Smoke test (rejected) | Real validation (required) |
|---|---|
| Command exits 0 | The row exists in the DB with the values the user entered |
| Endpoint returns 200 | The response body contains the computed result, and a second call reflects the first call's write |
| UI renders without panic | The user's action changes what the UI shows, and the change survives restart |
| Webhook fires | The receiving end got the payload with the right fields |

Concretely, the trimmed spec must keep or gain:

- A final `- [ ] Verify:` that walks the hypothesis sentence end-to-end and
  names the observable evidence (file contents, DB row, rendered output,
  received payload) — not process-level signals.
- At least one `Test:` line covering the one honest error path you kept, so
  "working" includes failing loudly rather than silently doing nothing.
- Persistence round-trips where state is involved: write through the real
  store, read it back, restart if cheap.

If the slimmest provable slice genuinely exceeds ~200 LoC (an atomic
migration, a protocol that has no smaller shape), say so with the
per-component numbers and recommend the overrun instead of shipping a slice
that proves nothing — an MVP that cannot validate the hypothesis is worse
than a big spec.

## Step 4: Estimate and cut to budget

Estimate net LoC per kept component (one line of reasoning each — mirror the
style of `/tasks:review`'s scope scoring). Sum them. While the sum exceeds
~200, revisit the kept list: narrow an enabler, hardcode another default,
drop another format. Cut breadth before cutting the validation bar — never
balance the budget by weakening `Test:` lines or the `Verify:` step.

## Report format

Write the report to chat (not a file) before editing anything:

```
MVP of <slug>.md

Hypothesis: A user can <X> and observe <Y>.

Keep (core + enablers):                          ~<n> LoC total
  1. <component> — <class> — ~<n> LoC — <one line>
  2. ...

Cut (deferrable + speculative):
  a. <component> — <one-line reason it does not affect the hypothesis>
  b. ...

Validation: <the Verify step in one sentence, naming the observable evidence>

Verdict: <fits in ~<n> LoC | irreducibly ~<n> LoC because <reason>>
```

Keep it skimmable — the questions that follow do the deciding.

## Refine with AskUserQuestion

Immediately after the report, ask the refinement questions with
AskUserQuestion — one batched call, not free-form "shall I proceed?" prose.
Build the questions from what the review actually found; the usual set:

1. **Hypothesis** (only if you reconstructed or doubted it) — present your
   sentence as the recommended option plus the plausible alternatives you
   rejected. A wrong hypothesis invalidates every classification, so this
   question comes first and, if the answer surprises you, re-run Step 2
   before asking anything else.
2. **Borderline cuts** (multiSelect) — list the components whose class was a
   judgment call ("keep these, cut whatever you don't select"). Components
   that are obviously core or obviously bloat do not need a question; asking
   about everything drowns the real decisions.
3. **Deferred scope destination** — follow-up specs via `/tasks:brief`
   (recommended), a one-line-per-item `tasks/backlog.md`, or drop entirely.
4. **Budget overrun** (only if the irreducible slice exceeds ~200 LoC) —
   accept the overrun with the stated justification, or pick which
   dimension of the slice to narrow further.

Skip any question the report makes moot — a spec with no borderline
components gets no question 2. Never exceed 4 questions; if more decisions
exist, the extras were not borderline enough to ask about.

## Applying the trim (only after the answers)

- Edit the spec in place. Delete the cut components' checkboxes entirely;
  narrow the kept enablers' text and code blocks to the slice width.
- The result must still conform to `tasks/new.md`: frontmatter intact with
  `updated_at` bumped, C4 annotations on every remaining checkbox, at least
  one `Test:` per component, the Version bump item (type only), and the
  final `Verify:` item. `/tasks:do` must be able to execute the trimmed spec
  unchanged.
- Move every cut item into a follow-up: either suggest the exact
  `/tasks:brief` invocation that would spec them properly (preferred), or —
  if the user wants a lightweight record — append them to
  `tasks/backlog.md` as one-line bullets. Never leave cut scope existing
  only in chat history.
- Do not annotate the spec with what was removed ("trimmed to MVP on ...").
  A spec describes work to do, not its own history.

## Rules

- **Hypothesis first.** No classification, no cutting, until the one-sentence
  hypothesis is written and (if reconstructed) confirmed.
- **Report, then ask, then edit.** Same contract as `/tasks:review`, with
  the confirmation carried by AskUserQuestion — the spec does not change
  until the refinement answers are in.
- **Vertical, never horizontal.** If the kept set does not produce a
  user-observable outcome through the real stack, it is not an MVP —
  re-slice.
- **The budget bends before the validation bar does.** Exceed ~200 LoC with
  justification rather than ship a slice that only smoke-tests.
- **Cuts are recorded, not lost.** Every cut component ends up in a
  follow-up spec suggestion or the backlog file.
- **One hypothesis per spec.** Two hypotheses is a split — hand off to
  `/tasks:brief`.
- **Estimate concretely.** Per-component LoC with one-line reasoning; no
  single hand-waved total.
