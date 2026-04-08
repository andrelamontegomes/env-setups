Create a new task spec file in the `tasks/` directory.

The argument is a short description of the feature, refactor, or fix. Example: `/new-task add webhook notifications for timer completion`

## Instructions

1. **Gather context**: Read `spec.md`, `CLAUDE.md`, and the existing task files in `tasks/` to understand the project architecture, conventions, tech stack, and the pattern used in existing specs. Also run `git log --oneline -10` to understand recent work.

2. **Research scope**: Before writing the spec, investigate what the task touches:
   - Search the codebase for files, types, and functions relevant to the described feature.
   - Identify which packages and files will be created or modified.
   - Determine what existing behavior needs to change vs what is net-new.
   - Check for dependencies on other tasks in `tasks/` — note them if they exist.

3. **Determine testing needs**: Research what tests are required:
   - **Unit tests**: Identify pure functions and domain types that need table-driven tests.
   - **Integration tests**: Identify cross-package interactions (e.g., CLI -> store -> DB, TUI -> player) that need integration tests.
   - **Existing test impact**: Check if existing tests need updating due to changed signatures, new fields, or modified behavior.
   - Inline every test requirement with its corresponding component in the spec (the `Test:` convention used in other task files).

4. **Determine version bump**: Read the current `VERSION` in `Makefile` (line 1) and determine the appropriate semver bump:
   - **patch** (0.1.0 → 0.1.1) — bug fixes, minor internal changes, no new user-facing behavior
   - **minor** (0.1.0 → 0.2.0) — new features, new commands, new user-facing behavior (backwards compatible)
   - **major** (0.1.0 → 1.0.0) — breaking changes to CLI interface, config format, or database schema that require user action
   - Update the `VERSION ?=` line in `Makefile` with the bumped version.
   - Include the new version in the `CHANGELOG.md` entry (step 5).

5. **Check documentation impact**: Determine if documentation needs updating:
   - Does `spec.md` need new sections or updates to reflect new architecture, types, or commands?
   - Does `CHANGELOG.md` need a new entry? (Use Keep a Changelog format, under the new version from step 4)
   - Does `CLAUDE.md` need updates to reflect new packages, key files, or conventions?
   - Does `--help` text on any CLI command need updating?
   - Add a documentation checklist item to the spec if any docs need changes.

6. **Identify whole-milestone context to pre-read**: Before drafting components, decide which files a future implementer must read once to hold the whole task in their head. These go into a top-level **Read before starting (whole-milestone context)** bullet list, *not* repeated per component. Aim for 4–8 entries covering:
   - Source files containing types/functions the task will extend, replace, or call
   - Adjacent files that establish the *pattern* to mirror (style, test layout, registry conventions, error handling)
   - `spec.md` sections that govern the relevant rules (formulas, accessibility constraints, domain idioms)
   - `CLAUDE.md` if build/lint/test workflow is non-obvious
   - Sibling task files this milestone coordinates with (use a separate **Coordinate with:** line at the very top for hard dependencies)
   Each entry must include the file path *and* a one-line reason it matters. Do not list a file without saying why.

7. **Identify per-component tools, references, and actions**: For each component in the spec, list the concrete actions and resources the implementing agent will need. Inline these directly under the component bullet (not at the bottom of the file). Use these sub-bullet conventions:
   - **Read:** `<path>` (lines X-Y) — `<why this exact region matters>`. Always cite line ranges when pointing at a small region; this is more useful than "see the file".
   - **Update callers:** `<path>` line N, `<path>` line N — list every call site that breaks when a signature changes, so the agent does not have to grep for them.
   - **Update tests:** `<test file>` — name the test files whose fixtures or signatures must change.
   - **Docs to fetch:** `<library/API name>` — `<URL>`. Use this for third-party libraries (Bubble Tea, Harmonica, Bubbles, Huh, Lipgloss, beep, modernc.org/sqlite, Cobra) when the component touches an unfamiliar API. Prefer canonical sources (`pkg.go.dev`, the project's GitHub README) and include the specific symbol/function the agent should look up.
   - **Stdlib:** `<package.Symbol>` — note when a stdlib package is the right tool (e.g. `math.Pow`, `time.Tick`, `context.WithCancel`) so the agent does not reach for a dependency.
   - **New dependency:** `<module path>` — flag any `go get` the agent will need to run, including whether it is already an indirect dep that just needs promoting in `go.mod`.
   - **Migration:** if the component requires a DB migration, name the next number (e.g. `004`) and the file (`internal/db/migrations.go`).
   - **Tools the agent should use:** call out non-default tools when relevant — e.g. `WebFetch` to pull a doc URL listed above, `Grep` for a specific symbol before editing, `LSP` for cross-package refactors, or running `make test` / `make lint` after changes.
   Do not invent references. If you do not know the correct URL or line number, leave the bullet off rather than guess — the implementing agent can search.

8. **Write the task spec**: Create `tasks/<slug>.md` following this structure. Begin the file with a YAML frontmatter block containing `title`, `description`, `created_at`, and `updated_at` (both dates set to today in `YYYY-MM-DD` format on creation). Use `date +%Y-%m-%d` if you need to confirm today's date. Do not repeat the `# <Title> — <Short Description>` heading inside the body — the frontmatter is the source of truth for both.

   ```markdown
   ---
   title: <Title>
   description: <Short Description>
   created_at: <YYYY-MM-DD>
   updated_at: <YYYY-MM-DD>
   ---

   **Depends on:** [other-task.md](other-task.md) (if applicable, omit section if none)
   **Coordinate with:** [sibling-task.md](sibling-task.md) — <one line on the overlap> (if applicable, omit if none)

   ### Container: <one-line C4 container description>

   <1-3 paragraph explanation of what this task does and why. Include context on how it fits into the broader system.>

   **Read before starting (whole-milestone context):**
   - `<path>` — <why this file matters for the whole task>
   - `<path>` — <pattern to mirror / type to extend / caller to update>
   - `spec.md` — <specific section: formula, accessibility rule, domain idiom>
   - `CLAUDE.md` — <only if build/lint/test workflow is non-obvious>

   ### Components

   - [ ] **`<file path>`** — <description> (<C4 depth: Code | Component | Container>)
     ```go
     // Key types, interfaces, function signatures
     ```
     - <Behavioral notes>
     - **Read:** `<path>` (lines X-Y) — <why this exact region>
     - **Update callers:** `<path>` line N, `<path>` line N
     - **Docs to fetch:** <library> — <URL>
     - **Stdlib:** `<package.Symbol>` (if a stdlib answer exists, prefer it)
     - **New dependency:** `<module path>` (only if a `go get` is required)
     - **Tools the agent should use:** <e.g. `WebFetch` for the doc URL above; `Grep` for `<symbol>` to find call sites; `make test` after the change>
     - Test: <specific test case>
     - Test: <specific test case>

   - [ ] **<Wiring / integration step>** — <description> (<C4 depth>)
     - **Read:** `<path>` (lines X-Y) — <why>
     - Test: <integration test>

   - [ ] **Version bump** — bump `VERSION` in `Makefile` (Code)
     - Bump type: <patch | minor | major>
     - `VERSION ?= <old>` → `VERSION ?= <new>`

   - [ ] **Documentation** (if needed)
     - Update `spec.md`: <what to add/change>
     - Update `CHANGELOG.md`: add `[<new version>]` entry

   - [ ] Verify: <end-to-end manual verification steps>
   ```

9. **C4 depth annotations**: Tag every component with its C4 model depth:
   - **Code** — pure domain types, functions, value objects (innermost)
   - **Component** — a package-level unit: CLI commands, store implementations, UI screens
   - **Container** — top-level wiring, lifecycle management, cross-cutting concerns (outermost)

10. **Conventions to follow** (derived from existing task specs):
   - Domain types use Go idioms: `type XxxID string`, enums via `iota` with `String()` method
   - Include Go code blocks showing key type definitions and function signatures
   - Log lines use structured `slog` format: `logger.Info("event", "key", val)`
   - DB changes use numbered migrations in `internal/db/migrations.go`
   - Every `Test:` line describes a single, specific assertion — not vague "test it works"
   - The final `- [ ] Verify:` item is a manual end-to-end smoke test
   - Keep milestone scope self-contained — the task should be independently verifiable

11. **Review**: Read back the created file. Confirm it follows the pattern of existing tasks, has C4 annotations on every component, includes specific test cases, and covers documentation updates. Verify the **Read before starting** list has 4–8 entries each with a *why*, and that every component bullet includes at least one **Read:** pointer plus, where relevant, **Docs to fetch:** / **Stdlib:** / **Tools the agent should use:** sub-bullets.

## Rules

- Match the style and structure of existing task specs in `tasks/` exactly.
- Every component must have at least one `Test:` line with a specific, concrete assertion.
- Do not create placeholder tasks — every item must be actionable and verifiable.
- Include the C4 depth annotation (Code, Component, or Container) on every checkbox item.
- If the task depends on another uncompleted task, state the dependency explicitly at the top.
- Use kebab-case for the filename slug (e.g., `stdin-reaction.md`, `ko-variants.md`).
- Ask the user for clarification if the description is too vague to produce specific component breakdowns.
