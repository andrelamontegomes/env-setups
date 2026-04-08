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

6. **Write the task spec**: Create `tasks/<slug>.md` following this structure. Begin the file with a YAML frontmatter block containing `title`, `description`, `created_at`, and `updated_at` (both dates set to today in `YYYY-MM-DD` format on creation). Use `date +%Y-%m-%d` if you need to confirm today's date. Do not repeat the `# <Title> — <Short Description>` heading inside the body — the frontmatter is the source of truth for both.

   ```markdown
   ---
   title: <Title>
   description: <Short Description>
   created_at: <YYYY-MM-DD>
   updated_at: <YYYY-MM-DD>
   ---

   **Depends on:** [other-task.md](other-task.md) (if applicable, omit section if none)

   ### Container: <one-line C4 container description>

   <1-3 paragraph explanation of what this task does and why. Include context on how it fits into the broader system.>

   ### Components

   - [ ] **`<file path>`** — <description> (<C4 depth: Code | Component | Container>)
     ```go
     // Key types, interfaces, function signatures
     ```
     - <Behavioral notes>
     - Test: <specific test case>
     - Test: <specific test case>

   - [ ] **<Wiring / integration step>** — <description> (<C4 depth>)
     - Test: <integration test>

   - [ ] **Version bump** — bump `VERSION` in `Makefile` (Code)
     - Bump type: <patch | minor | major>
     - `VERSION ?= <old>` → `VERSION ?= <new>`

   - [ ] **Documentation** (if needed)
     - Update `spec.md`: <what to add/change>
     - Update `CHANGELOG.md`: add `[<new version>]` entry

   - [ ] Verify: <end-to-end manual verification steps>
   ```

7. **C4 depth annotations**: Tag every component with its C4 model depth:
   - **Code** — pure domain types, functions, value objects (innermost)
   - **Component** — a package-level unit: CLI commands, store implementations, UI screens
   - **Container** — top-level wiring, lifecycle management, cross-cutting concerns (outermost)

8. **Conventions to follow** (derived from existing task specs):
   - Domain types use Go idioms: `type XxxID string`, enums via `iota` with `String()` method
   - Include Go code blocks showing key type definitions and function signatures
   - Log lines use structured `slog` format: `logger.Info("event", "key", val)`
   - DB changes use numbered migrations in `internal/db/migrations.go`
   - Every `Test:` line describes a single, specific assertion — not vague "test it works"
   - The final `- [ ] Verify:` item is a manual end-to-end smoke test
   - Keep milestone scope self-contained — the task should be independently verifiable

9. **Review**: Read back the created file. Confirm it follows the pattern of existing tasks, has C4 annotations on every component, includes specific test cases, and covers documentation updates.

## Rules

- Match the style and structure of existing task specs in `tasks/` exactly.
- Every component must have at least one `Test:` line with a specific, concrete assertion.
- Do not create placeholder tasks — every item must be actionable and verifiable.
- Include the C4 depth annotation (Code, Component, or Container) on every checkbox item.
- If the task depends on another uncompleted task, state the dependency explicitly at the top.
- Use kebab-case for the filename slug (e.g., `stdin-reaction.md`, `ko-variants.md`).
- Ask the user for clarification if the description is too vague to produce specific component breakdowns.
