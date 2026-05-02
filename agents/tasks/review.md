Review an existing task spec file in `tasks/` and decide whether it is ready to implement, needs tightening, or should be broken down into smaller specs.

The argument is the slug or filename of a spec already in `tasks/` (with or without the `.md` extension). Examples:
- `/tasks:review webhook-notifications`
- `/tasks:review resume-position.md`
- `/tasks:review` (no argument — list specs in `tasks/` and ask which one)

This skill is the audit pass for a spec. It is the counterpart to `/tasks:brief` and `/tasks:new`: where those produce specs, this one **evaluates** a spec against the project's conventions and the 150-LoC-net budget, and reports back. It does not silently rewrite the spec. If a split or rewrite is warranted, it proposes the move and asks you before changing anything.

## Instructions

### 1. Locate and read the spec

Read `tasks/$ARGUMENTS` (with or without `.md`). If the argument is missing or the file is not found, list the unfinished specs in `tasks/` (skip `tasks/done/`) and ask which one to review. Do not invent a target.

Also read `tasks/new.md` so you know the structural rules the spec is supposed to follow, and `spec.md` + `CLAUDE.md` for project conventions. Run `git log --oneline -10` to spot recent context the spec might be stale against.

### 2. Score the spec on six dimensions

For each dimension, mark the spec as **OK / Concern / Blocker** with one sentence of evidence. A *Concern* is something that should be fixed but does not block implementation; a *Blocker* means the implementing agent will get stuck or guess.

1. **Scope size (LoC budget).** Estimate the net LoC change the spec will produce (added + modified + deleted, excluding generated code, lockfiles, fixtures). The target is **≤150 net LoC**. If it looks larger, this is a *Blocker* unless the spec body explicitly justifies the overrun (e.g., a single atomic migration). Show your estimate and how you got there — per-component sub-estimates beat one big number.
2. **Structural conformance.** Does the spec match `tasks/new.md`? Check: YAML frontmatter with `title`/`description`/`created_at`/`updated_at`; `Read before starting` list with 4–8 entries each with a *why*; every component has a C4 depth annotation; every component has at least one `Read:` pointer (ideally with line ranges); a Version bump item with a *type* only (not a pre-computed number); a Documentation item if any docs need updates; a final `Verify:` smoke test.
3. **Test coverage.** Every component must have at least one specific `Test:` line. Count components without tests. Vague tests ("test it works") count as missing. Note any tests that would not be observable until a sibling task lands — those are split-shape problems, not test problems.
4. **Verifiability.** Walk the components in order. Could an implementing agent run each `Test:` and the final `Verify:` against the code on disk after that step is done? If a step ends "no test possible until X is done," flag it.
5. **Resolved unknowns.** Re-read the spec hunting for places where the author punted: phrases like "decide later", "TBD", "if needed", "we may want", or vague behavior descriptions ("handle errors gracefully" without saying which errors or how). Each of these is a future blocker for the implementer. List them verbatim with file:line.
6. **Staleness.** First check `created_at` / `updated_at` in the frontmatter. If `updated_at` is not today, the spec may be out of date — run `git log --since="<updated_at>" --oneline` and `git diff --stat <commit-at-updated_at>..HEAD -- <files referenced in the spec>` to enumerate every change in the repo since the spec was last touched. Walk that diff against the spec's `Read:` pointers and inline code blocks: files renamed/moved? Line ranges shifted? Functions deleted or renamed? Dependencies bumped? Behavior the spec relies on changed? Use Grep to spot-check the symbols mentioned in code blocks inside the spec. List each drift verbatim with the commit SHA that caused it so the fix is auditable. If `updated_at` is today, you can skip the git walk and just spot-check symbols.

### 3. Decide on the recommendation

Pick exactly one of the following outcomes and justify it from the scores above:

- **Ready** — no Blockers, at most a few Concerns. Implementation can start. Note the Concerns inline so they get fixed in passing.
- **Tighten in place** — Concerns or Blockers that are localized: missing `Test:` lines, missing `Read:` pointers, vague behavior, stale line numbers, missing version-bump type. The fix is a small edit to the existing spec, not a structural change.
- **Break down** — the spec exceeds the LoC budget, or its components are not independently verifiable, or it bundles unrelated work. Propose a split.

Splitting follows the same rules as `/tasks:brief`:
- **Sequential** when later work needs earlier work to compile or function — link via `Depends on:`.
- **Parallel** when pieces are independent — link via `Coordinate with:`.
- **Every produced child must remain independently verifiable.** A child whose tests only fire after a sibling lands is a wrong split — fix the seam (behind a flag, stub the consumer, type-layer-first, prep-refactor-first) until each child stands on its own.

When proposing a split, sketch it concretely:

```
Proposed split of webhook-notifications.md (~280 LoC) → 3 specs:
  1. webhook-notifications-1-domain.md — add WebhookEvent type + serialization (~60 LoC, Code, no deps)
  2. webhook-notifications-2-emit.md   — emit on timer completion behind feature flag (~80 LoC, Component, Depends on 1)
  3. webhook-notifications-3-cli.md    — `--webhook-url` flag + config field (~70 LoC, Component, Depends on 2)
```

### 4. Surface gaps to the user — do not patch silently

If the spec has *Resolved unknowns* failures (Step 2.5) — places where the original author punted on a decision — list them and ask the user, the same way `/tasks:brief` does: numbered questions, one batched message, with your best guess and a one-line rationale per item so the user can answer "1, 3" rather than retyping. Do not invent answers. Do not edit the spec until the user resolves them.

If the spec is stale (Step 2.6) — line ranges shifted, symbols renamed, referenced behavior changed — *those* are mechanical fixes and you can propose them inline without asking, but still wait for confirmation before writing. When proposing the patch, show the new line ranges / symbol names side-by-side with the old ones so the user can sanity-check. Do **not** add prose to the spec explaining why it was updated (no "updated after rename in commit abc123", no changelog notes inside the spec body) — the spec describes work yet to be done, not its own history. Just refresh the stale references and bump `updated_at`.

### 5. Produce the review report

Write the review to the chat (not to a file) in this shape:

```
Review of <slug>.md

Scope size:        <OK | Concern | Blocker> — <one line, include LoC estimate>
Structure:         <OK | Concern | Blocker> — <one line>
Test coverage:     <OK | Concern | Blocker> — <one line>
Verifiability:     <OK | Concern | Blocker> — <one line>
Resolved unknowns: <OK | Concern | Blocker> — <one line>
Staleness:         <OK | Concern | Blocker> — <one line>

Recommendation: <Ready | Tighten in place | Break down>

<If Tighten: list the specific edits as a checklist.>
<If Break down: show the proposed split table above.>
<If unknowns exist: list the numbered questions for the user.>
```

Keep it tight. The user should be able to skim it and answer with a yes/no plus any clarifications.

### 6. Apply changes only after the user confirms

After the report:
- If the user confirms **Tighten in place**, edit the spec directly. Bump `updated_at` to now (`YYYY-MM-DD HH:MM:SS`, via `date '+%Y-%m-%d %H:%M:%S'`).
- If the user confirms **Break down**, this skill does not write the new specs itself — hand off to `/tasks:brief` (or `/tasks:new` per child) so the same gap-clarification flow runs. Suggest the exact follow-up commands. Optionally archive the original spec by moving it to `tasks/superseded/` (create the directory if needed) so the history is preserved without polluting the active list — but only if the user agrees.
- If the user picks **Ready**, do nothing further.

Never delete a spec. Never split a spec into new files inside this skill — splitting is `/tasks:brief`'s job, and routing through it ensures the children get the same gap-clarification, LoC-budget, and verifiability treatment that any new spec gets.

## Rules

- **Do not edit the spec before reporting.** The report comes first; edits follow user confirmation.
- **Do not invent answers to gaps.** If the original author punted, you ask the user — same as `/tasks:brief`.
- **Do not split inside this skill.** When breakdown is the answer, hand off to `/tasks:brief` so the children inherit the right machinery.
- **Estimate LoC concretely.** Per-component sub-estimates with one-line reasoning beat a single hand-wave number — they also make the breakdown decision auditable.
- **Match `tasks/new.md` exactly** as the conformance reference. If `new.md` evolves, this skill follows.
- Be specific. "Test coverage is weak" is useless; "components 2, 4, and 7 have no `Test:` line" is actionable.
- **A spec describes work to do, not its own history.** When refreshing stale references, edit them in place and bump `updated_at` — never add changelog notes, "updated after X" annotations, or commit-SHA breadcrumbs to the spec body.
