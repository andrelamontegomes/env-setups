Turn a small feature brief into one or more task spec files in the `tasks/` directory.

The argument is a feature brief — anywhere from one line to a paragraph. It may be vague, incomplete, or ambiguous. Examples:
- `/tasks:brief add webhook notifications when a timer completes`
- `/tasks:brief make the player remember the last position across restarts so users don't lose their place — should also work when they switch devices later if we ever add sync`
- `/tasks:brief fix the flicker on the home screen`

This skill is the front door for turning loose product ideas into the same task spec format that `/tasks:new` produces. It differs from `/tasks:new` in three ways:

1. **It clarifies before it writes.** If the brief leaves something genuinely undecidable from the codebase (which API to call, where a value lives, what the desired UX is), it stops and asks you. It does **not** make executive decisions on your behalf and bury them in a spec.
2. **It enforces a ~150-LoC net-change budget per task.** If the work doesn't fit, it splits into multiple smaller specs — sequential when there are hard dependencies, parallel when there aren't — each one independently verifiable and testable.
3. **It accepts vague input.** A one-line brief is fine. The skill will research, identify gaps, and come back with questions or a draft plan.

## Instructions

### 1. Gather context

Read `spec.md`, `CLAUDE.md`, and the existing files in `tasks/` (including `tasks/done/` if it exists) to understand the project architecture, conventions, tech stack, and the pattern used in existing specs. Run `git log --oneline -10` to understand recent work. This is the same context-gathering as `/tasks:new`.

### 2. Research scope from the brief

Investigate what the brief touches before deciding anything:
- Search the codebase for files, types, and functions relevant to the described feature.
- Identify which packages and files will be created or modified.
- Determine what existing behavior needs to change vs what is net-new.
- Check for dependencies on other tasks in `tasks/` — note them if they exist.
- Note any external surfaces involved (CLI flags, config, HTTP endpoints, DB schema, public types) — these usually drive scope and the version-bump type.

Use Explore / Grep aggressively here. The point of this step is to *replace as many unknowns as possible with facts from the code* before going to the user with questions.

### 3. Identify gaps and ask the user — do not decide unilaterally

After research, list every remaining ambiguity that you cannot resolve from the code or from this conversation. Examples of legitimate gaps:
- **Ambiguous behavior**: "Should the timer pause on app blur or keep running?" — code does not encode an answer.
- **Unspecified surface**: "Should this be a new CLI flag, a config field, or both?" — the brief says "make it configurable" without saying where.
- **External dependency choice**: "Webhooks could go via the existing `notify` package or a new HTTP client — which?" — both are plausible and the project has no precedent.
- **Scope boundary**: "Brief mentions cross-device sync 'if we ever add sync' — is that in scope now or not?"
- **Acceptance criteria**: "What counts as 'fixed' for the flicker — no flicker on a cold launch, or also on resume?"

Do **not** ask about things you can determine from the code (file paths, existing type names, conventions, where migrations live). Do **not** ask about preferences you have a clear default for under the project's existing conventions — just follow the convention.

If there are gaps, **stop here and ask the user** — preferably as a single batched message with each question numbered, plus your best guess and a one-line rationale for each so the user can answer with "1, 3" rather than retyping. Resume only after the user has answered. Do not write any spec until you have answers (or the user explicitly says "you decide").

If there are no gaps, proceed.

### 4. Estimate net LoC change and decide on splitting

For the resolved scope, sketch the components mentally and estimate the **net** lines of code change (added + modified + deleted, excluding generated code, lockfiles, and test fixtures). The target is **≤150 net LoC per task spec**. This budget exists because small tasks are easier to review, verify, revert, and parallelize.

If the estimate is over budget, split the work into multiple specs. There are two splitting axes:

- **Sequential (Depends on)** — when later work needs earlier work to compile or function. Examples: introduce a new domain type → wire it through the store → expose it in the CLI. Each later task lists `Depends on:` the earlier one in its frontmatter.
- **Parallel (Coordinate with)** — when two pieces touch related areas but neither blocks the other. Examples: a new CLI flag and a new config field that both feed the same setting; a frontend change and an unrelated backend change for the same feature. Each task lists `Coordinate with:` the sibling so the implementing agent reads the other for context but does not wait.

**Every split task must remain independently verifiable.** If a task can only be tested once a follow-up lands, the split is wrong — collapse it back or push the test to whichever task makes it observable. A task that ends "no test possible until X is done" is not a valid task.

Common splitting patterns that preserve verifiability:
- **Type/domain layer first**, then UI/CLI integration. The first task tests the type's invariants directly; the second tests the user-facing behavior.
- **Behind a flag/feature gate**: ship the new code-path off by default in task A (tested by flipping the flag in tests), enable it in task B once integration lands.
- **Stub the consumer**: task A introduces the producer with a minimal in-memory consumer in tests; task B replaces the stub with the real consumer.
- **Refactor/rename in place** as a separate prep task before the feature task, so the feature diff stays small.

If a task is intrinsically a single atomic change that exceeds 150 LoC (e.g., a generated migration, a single large state machine), call that out explicitly in the spec body — note the budget overrun and why splitting would harm correctness. This should be rare (the "99.99%" the user cares about); justify it instead of silently exceeding the budget.

### 5. For each task, follow the `/tasks:new` spec convention

Each task spec file produced must follow the **exact** structure documented in `tasks/new.md` (sections 4–10 of that file). Do not re-derive the format here — read `tasks/new.md` and mirror it. In particular:

- YAML frontmatter with `title`, `description`, `created_at`, `updated_at`.
- `**Depends on:**` and/or `**Coordinate with:**` lines at the top when applicable. When this skill produces multiple tasks from one brief, wire them up here using the actual filenames you are creating.
- A `### Container:` one-liner and a 1–3 paragraph context section.
- A `**Read before starting (whole-milestone context):**` list with 4–8 entries, each with a *why*.
- A `### Components` checklist where every item has a C4 depth annotation (Code | Component | Container), at least one `**Read:**` pointer with line ranges, the relevant per-component sub-bullets (`Update callers:`, `Update tests:`, `Docs to fetch:`, `Stdlib / built-ins:`, `New dependency:`, `Migration:`, `Tools the agent should use:`), and concrete `Test:` lines.
- A **Version bump** item that records only the bump *type* (patch / minor / major) — never pre-compute the new version.
- A **Documentation** item if `spec.md`, `CHANGELOG.md`, `CLAUDE.md`, or `--help` text needs updates.
- A final `- [ ] Verify:` manual end-to-end smoke test.

### 6. Naming and slugs

- Use kebab-case filenames (e.g., `webhook-notifications.md`, `resume-position.md`).
- When splitting, suffix the filenames so the order is obvious: `<root>-1-<slug>.md`, `<root>-2-<slug>.md`, etc. Example: `webhook-notifications-1-domain.md`, `webhook-notifications-2-emit.md`, `webhook-notifications-3-cli.md`. The number reflects the dependency order, not a naming requirement — parallel siblings can share a number or use letters (`-2a-`, `-2b-`) if that is clearer.
- Pick the version-bump type per spec independently. Often the first task is `patch` (internal type only) and the user-facing task is `minor`.

### 7. Plan-then-write protocol

Before writing any files, present a short plan to the user:

```
Brief: <one-line restatement>
Resolved unknowns: <summary of what you confirmed from the code or the user's answers>
Plan: 1 task / N tasks
  1. <slug.md> — <one-line scope> (~LoC, depth, depends on …)
  2. <slug.md> — <one-line scope> (~LoC, depth, depends on …)
```

If the plan is a single task under budget, you can skip the explicit plan step and write directly. For anything multi-task or non-obvious, show the plan first and wait for the user to confirm — they may want to merge, drop, or reorder.

Once confirmed, write the spec files.

### 8. Review

After writing, list the files you created and read each one back. Confirm for each:
- Frontmatter is present and timestamps are now (`YYYY-MM-DD HH:MM:SS`).
- Every component has a C4 depth and at least one `Read:` pointer.
- Every component has at least one specific `Test:` line.
- Cross-task `Depends on:` / `Coordinate with:` links use the actual filenames you wrote.
- The `Verify:` checkbox is concrete and end-to-end (a human could follow it without rereading the spec).

## Rules

- **Never invent answers to gaps.** If you cannot derive it from the code, ask. Better to send one clarifying message than write a spec the user has to rewrite.
- **Never exceed ~150 net LoC per spec without an explicit, written justification** in the spec body. The default move when work is too large is to split, not to grow.
- **Every produced task must be independently verifiable.** A `Test:` that only runs after a sibling task lands is a sign the split is wrong.
- **Match `tasks/new.md` exactly** for spec structure — this skill's job is to produce more, smaller specs in that same shape, not to invent a new shape.
- Do not modify or delete existing tasks in `tasks/` unless the user explicitly asks. If a brief overlaps an existing task, surface the overlap in the plan step and let the user decide.
- Do not start implementing the work — that is `/tasks:do`'s job. This skill produces specs only.
