Create a new task spec file in the `tasks/` directory.

The argument is a short description of the feature, refactor, or fix. Example: `/new-task-rust add webhook notifications for timer completion`

## Instructions

1. **Gather context**: Read `CLAUDE.md` and the existing task files in `tasks/` to understand the project architecture, conventions, tech stack, and the pattern used in existing specs. If a `spec.md` (or equivalent design doc like `ARCHITECTURE.md`, `DESIGN.md`, `README.md`) exists at the repo root, read it too. Also run `git log --oneline -10` to understand recent work.

2. **Research scope**: Before writing the spec, investigate what the task touches:
   - Search the codebase for files, types, and functions relevant to the described feature.
   - Identify which crates and modules will be created or modified.
   - Determine what existing behavior needs to change vs what is net-new.
   - Check for dependencies on other tasks in `tasks/` — note them if they exist.

3. **Determine testing needs**: Research what tests are required:
   - **Unit tests**: Identify pure functions and domain types that need `#[cfg(test)]` modules with parameterized cases (e.g. `rstest`, table-style `for` loops, or `proptest` for property tests).
   - **Integration tests**: Identify cross-crate or cross-module interactions (e.g., CLI -> store -> DB, TUI -> player) that need integration tests under `tests/`.
   - **Existing test impact**: Check if existing tests need updating due to changed signatures, new fields, or modified behavior.
   - Inline every test requirement with its corresponding component in the spec (the `Test:` convention used in other task files).

4. **Determine version bump type**: Decide the appropriate semver bump *type* for this task. Do **not** read the current `version` in `Cargo.toml` and do **not** compute or write the exact new version — the actual bump happens when the task is completed, by which time the current version may have moved. Record only the type:
   - **patch** — bug fixes, minor internal changes, no new user-facing behavior
   - **minor** — new features, new commands, new user-facing behavior (backwards compatible)
   - **major** — breaking changes to CLI interface, config format, public API, or database schema that require user action

5. **Check documentation impact**: Determine if documentation needs updating:
   - If a design doc (`spec.md`, `ARCHITECTURE.md`, `DESIGN.md`) exists, does it need new sections or updates to reflect new architecture, types, or commands?
   - Does `CHANGELOG.md` need a new entry? (Use Keep a Changelog format — the version header will be filled in at completion time, so the spec should just say "add entry under the new version")
   - Does `README.md` or `CLAUDE.md` need updates to reflect new crates, key files, or conventions?
   - Do public-item rustdoc comments (`///`) need updating on changed APIs?
   - Does `--help` text on any CLI command need updating (e.g. `clap` `#[arg(help = ...)]` or doc comments)?
   - Add a documentation checklist item to the spec if any docs need changes.

6. **Identify whole-milestone context to pre-read**: Before drafting components, decide which files a future implementer must read once to hold the whole task in their head. These go into a top-level **Read before starting (whole-milestone context)** bullet list, *not* repeated per component. Aim for 4–8 entries covering:
   - Source files containing types/functions the task will extend, replace, or call
   - Adjacent files that establish the *pattern* to mirror (module layout, error type conventions, trait organization, test layout)
   - Design-doc sections that govern the relevant rules (formulas, accessibility constraints, domain idioms) — only if such a doc exists in the repo
   - `CLAUDE.md` if build/lint/test workflow is non-obvious
   - Sibling task files this milestone coordinates with (use a separate **Coordinate with:** line at the very top for hard dependencies)
   Each entry must include the file path *and* a one-line reason it matters. Do not list a file without saying why.

7. **Identify per-component tools, references, and actions**: For each component in the spec, list the concrete actions and resources the implementing agent will need. Inline these directly under the component bullet (not at the bottom of the file). Use these sub-bullet conventions:
   - **Read:** `<path>` (lines X-Y) — `<why this exact region matters>`. Always cite line ranges when pointing at a small region; this is more useful than "see the file".
   - **Update callers:** `<path>` line N, `<path>` line N — list every call site that breaks when a signature changes, so the agent does not have to grep for them.
   - **Update tests:** `<test file>` — name the test files whose fixtures or signatures must change.
   - **Docs to fetch:** `<crate/API name>` — `<URL>`. Use this for third-party crates (ratatui, crossterm, clap, rodio, rusqlite/sqlx, serde, tokio, tracing, anyhow/thiserror) when the component touches an unfamiliar API. Prefer canonical sources (`docs.rs`, the project's GitHub README) and include the specific symbol/function the agent should look up.
   - **Stdlib:** `<module::Symbol>` — note when a stdlib answer is the right tool (e.g. `std::time::Duration`, `std::sync::mpsc`, `std::sync::atomic::AtomicBool`, `f64::powi`) so the agent does not reach for a dependency.
   - **New dependency:** `<crate>` — flag any `cargo add` the agent will need to run, including the feature flags required (e.g. `cargo add tokio --features rt-multi-thread,macros`) and whether it is already a transitive dep that just needs promoting in `Cargo.toml`.
   - **Migration:** if the component requires a DB migration, name the next number (e.g. `004`) and the file (`migrations/004_<name>.sql` for sqlx, or the next entry in `src/db/migrations.rs` for rusqlite).
   - **Tools the agent should use:** call out non-default tools when relevant — e.g. `WebFetch` to pull a doc URL listed above, `Grep` for a specific symbol before editing, `LSP` for cross-crate refactors, or running `cargo test` / `cargo clippy -- -D warnings` / `cargo fmt --check` after changes.
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
   - `<design doc path>` — <specific section: formula, accessibility rule, domain idiom> (only if a design doc exists)
   - `CLAUDE.md` — <only if build/lint/test workflow is non-obvious>

   ### Components

   - [ ] **`<file path>`** — <description> (<C4 depth: Code | Component | Container>)
     ```rust
     // Key types, traits, function signatures
     pub struct FooId(String);

     pub trait Store {
         fn get(&self, id: &FooId) -> Result<Foo, StoreError>;
     }
     ```
     - <Behavioral notes>
     - **Read:** `<path>` (lines X-Y) — <why this exact region>
     - **Update callers:** `<path>` line N, `<path>` line N
     - **Docs to fetch:** <crate> — <URL>
     - **Stdlib:** `<module::Symbol>` (if a stdlib answer exists, prefer it)
     - **New dependency:** `<crate>` with features `<feature1,feature2>` (only if a `cargo add` is required)
     - **Tools the agent should use:** <e.g. `WebFetch` for the doc URL above; `Grep` for `<symbol>` to find call sites; `cargo test` and `cargo clippy -- -D warnings` after the change>
     - Test: <specific test case>
     - Test: <specific test case>

   - [ ] **<Wiring / integration step>** — <description> (<C4 depth>)
     - **Read:** `<path>` (lines X-Y) — <why>
     - Test: <integration test under `tests/`>

   - [ ] **Version bump** — bump `version` in `Cargo.toml` (Code)
     - Bump type: <patch | minor | major>
     - At completion time, read the current `version = "..."` line in `[package]` and apply the bump above. Run `cargo update -p <crate-name>` afterwards so `Cargo.lock` is regenerated. Do not pre-compute the new version here — it may be stale by the time this task runs.

   - [ ] **Documentation** (if needed)
     - Update `<design doc>`: <what to add/change> (only if a design doc exists in the repo)
     - Update `CHANGELOG.md`: add a new entry under the version produced by the bump above
     - Update rustdoc on `<pub item>`: <what to clarify>

   - [ ] Verify: <end-to-end manual verification steps>
   ```

9. **C4 depth annotations**: Tag every component with its C4 model depth:
   - **Code** — pure domain types, functions, value objects, newtype wrappers (innermost)
   - **Component** — a module-level unit: CLI subcommands, store implementations, UI screens, trait impls
   - **Container** — top-level wiring (`main.rs`, `lib.rs`), runtime/lifecycle management, cross-cutting concerns (outermost)

10. **Conventions to follow** (Rust idioms — derived from existing task specs):
   - Domain identifiers use the **newtype pattern**: `pub struct XxxId(String);` with `#[derive(Debug, Clone, PartialEq, Eq, Hash)]`. Add `From<String>` / `AsRef<str>` impls where ergonomic.
   - Enums use plain Rust `enum` with `#[derive(Debug, Clone, Copy, PartialEq, Eq)]` and an `impl Display` block (or `strum::Display`) instead of stringly-typed constants.
   - Errors use `thiserror::Error` for library-style enums and `anyhow::Result` for application-level glue. Never use `unwrap()` or `expect()` outside of tests and `main` startup; prefer `?` propagation.
   - Logging uses the `tracing` crate with structured fields: `tracing::info!(key = %val, "event")`. Avoid `println!` for diagnostics.
   - Async code uses `tokio` with `#[tokio::main]` or `#[tokio::test]`. Prefer `tokio::sync::{mpsc, oneshot, RwLock}` over `std::sync` when crossing `.await` points.
   - Public items in library crates have `///` rustdoc comments. Mark intentionally-unused items with `#[allow(dead_code)]` plus a comment explaining why, not with `_` prefix tricks.
   - DB changes use numbered SQL migrations under `migrations/` (sqlx) or numbered entries in `src/db/migrations.rs` (rusqlite). Migrations are append-only — never edit a shipped migration.
   - Module layout follows `src/<area>/mod.rs` + submodules; re-export the public surface from `lib.rs`. Keep `pub(crate)` as the default visibility and only widen to `pub` when the item crosses a crate boundary.
   - CLI commands use `clap` with `#[derive(Parser)]` / `#[derive(Subcommand)]`. Help text lives in `///` doc comments on the struct fields.
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
- Prefer stdlib over a new crate when both work. Flag any new `cargo add` explicitly with required features.
- All new code must compile clean under `cargo clippy -- -D warnings` and be formatted with `cargo fmt`.
- Do not assume `spec.md` exists — check the repo first and reference whichever design doc the project actually uses (if any).
- Ask the user for clarification if the description is too vague to produce specific component breakdowns.
