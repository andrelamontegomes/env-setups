Create a new task spec file in the `tasks/` directory.

The argument is a short description of the feature, refactor, or fix. Example: `/new-task-react add webhook notifications for timer completion`

## Instructions

1. **Gather context**: Read `CLAUDE.md` and the existing task files in `tasks/` to understand the project architecture, conventions, tech stack, and the pattern used in existing specs. If a `spec.md` (or equivalent design doc like `ARCHITECTURE.md`, `DESIGN.md`, `README.md`) exists at the repo root, read it too. Inspect `package.json` to confirm the React major version, the framework (Next.js / Vite / React Router / Remix), the package manager (`pnpm` / `bun` / `npm` / `yarn`), and the test runner. Also run `git log --oneline -10` to understand recent work.

2. **Research scope**: Before writing the spec, investigate what the task touches:
   - Search the codebase for components, hooks, server actions, route segments, and types relevant to the described feature.
   - Identify which packages (in a monorepo) and which directories (`app/`, `src/components/`, `src/hooks/`, `src/lib/`, `src/server/`) will be created or modified.
   - Determine the **render boundary** for each new file: Server Component (default in App Router), Client Component (`"use client"`), or Server Action (`"use server"`). Misplaced boundaries are the most common React 19 bug — call them out explicitly.
   - Determine what existing behavior needs to change vs what is net-new.
   - Check for dependencies on other tasks in `tasks/` — note them if they exist.

3. **Determine testing needs**: Research what tests are required:
   - **Unit tests**: Identify pure functions, reducers, custom hooks, and presentational components that need co-located `*.test.ts`/`*.test.tsx` files. Hooks are tested via `renderHook` from `@testing-library/react`; pure logic uses Vitest's `test.each` for parameterized cases.
   - **Component tests**: Identify interactive components that need `@testing-library/react` + `@testing-library/user-event` tests with `render` and accessible-role queries (`getByRole`, `findByRole`). Avoid `getByTestId` unless no semantic query exists.
   - **Integration tests**: Identify cross-boundary flows (Client Component → Server Action → DB, route loader → page render) that need integration coverage. For Server Components and Server Actions, prefer testing the underlying functions directly plus a Playwright smoke test, since RSC is awkward to render in jsdom.
   - **E2E tests**: Identify user journeys that need Playwright tests under `e2e/` or `tests/e2e/` — anything spanning navigation, auth, or hydration boundaries.
   - **Existing test impact**: Check if existing tests need updating due to changed props, hook signatures, action shapes, or modified behavior.
   - Inline every test requirement with its corresponding component in the spec (the `Test:` convention used in other task files).

4. **Determine version bump type**: Decide the appropriate semver bump *type* for this task. Do **not** read the current `version` in `package.json` and do **not** compute or write the exact new version — the actual bump happens when the task is completed, by which time the current version may have moved. Record only the type:
   - **patch** — bug fixes, minor internal changes, no new user-facing behavior
   - **minor** — new features, new routes, new user-facing behavior (backwards compatible)
   - **major** — breaking changes to public component APIs, route structure, exported hook signatures, action contracts, or config that require user/consumer action

5. **Check documentation impact**: Determine if documentation needs updating:
   - If a design doc (`spec.md`, `ARCHITECTURE.md`, `DESIGN.md`) exists, does it need new sections or updates to reflect new architecture, components, routes, or actions?
   - Does `CHANGELOG.md` need a new entry? (Use Keep a Changelog format — the version header will be filled in at completion time, so the spec should just say "add entry under the new version")
   - Does `README.md` or `CLAUDE.md` need updates to reflect new directories, key files, env vars, or conventions?
   - Do exported public components/hooks need TSDoc (`/** ... */`) updates so editor hover docs stay accurate?
   - Does any Storybook story (`*.stories.tsx`) need adding or updating for new component variants?
   - Does `.env.example` need new keys for any new server-side config?
   - Add a documentation checklist item to the spec if any docs need changes.

6. **Identify whole-milestone context to pre-read**: Before drafting components, decide which files a future implementer must read once to hold the whole task in their head. These go into a top-level **Read before starting (whole-milestone context)** bullet list, *not* repeated per component. Aim for 4–8 entries covering:
   - Source files containing components/hooks/actions the task will extend, replace, or call
   - Adjacent files that establish the *pattern* to mirror (component layout, hook conventions, error boundary placement, server action structure, test layout)
   - Design-doc sections that govern the relevant rules (formulas, accessibility constraints, design tokens, domain idioms) — only if such a doc exists in the repo
   - The relevant route segment's `layout.tsx` / `loader` / `error.tsx` / `loading.tsx` if the task touches routing
   - `tsconfig.json` paths or `next.config.ts` / `vite.config.ts` if the task involves new aliases, env vars, or build config
   - `CLAUDE.md` if build/lint/test workflow is non-obvious
   - Sibling task files this milestone coordinates with (use a separate **Coordinate with:** line at the very top for hard dependencies)
   Each entry must include the file path *and* a one-line reason it matters. Do not list a file without saying why.

7. **Identify per-component tools, references, and actions**: For each component in the spec, list the concrete actions and resources the implementing agent will need. Inline these directly under the component bullet (not at the bottom of the file). Use these sub-bullet conventions:
   - **Read:** `<path>` (lines X-Y) — `<why this exact region matters>`. Always cite line ranges when pointing at a small region; this is more useful than "see the file".
   - **Update callers:** `<path>` line N, `<path>` line N — list every call site that breaks when a prop, hook return shape, or action signature changes, so the agent does not have to grep for them.
   - **Update tests:** `<test file>` — name the test files whose fixtures, render helpers, or mocks must change.
   - **Docs to fetch:** `<library/API name>` — `<URL>`. Use this for React 19 APIs the agent might not have memorised (`use`, `useActionState`, `useOptimistic`, `useFormStatus`, the React Compiler, `<form action={fn}>`, ref-as-prop, document metadata, `preload` / `preinit`) and for third-party libraries (Next.js App Router, React Router 7, TanStack Query/Router, Zustand, Jotai, shadcn/ui, Tailwind 4, Drizzle, Prisma, Zod, react-hook-form, Vitest, Playwright, MSW). Prefer canonical sources (`react.dev`, `nextjs.org/docs`, the project's GitHub README) and include the specific symbol/hook the agent should look up.
   - **Built-in:** `<React API or web platform API>` — note when a built-in answer is the right tool (e.g. `useId` for stable SSR-safe IDs, `useDeferredValue` for low-priority updates, `useTransition` for non-blocking updates, `useSyncExternalStore` for external stores, `<Suspense>` for async boundaries, the platform `AbortController` / `URLSearchParams` / `FormData`) so the agent does not reach for a dependency.
   - **New dependency:** `<package>` — flag any `pnpm add` / `bun add` / `npm install` the agent will need to run, including whether it is a `devDependencies`-only addition (`-D`) and any peer-dep constraints. Match the project's existing package manager — do not mix lockfiles.
   - **Migration:** if the component requires a DB migration, name the next number/file (`drizzle/0007_<name>.sql` for Drizzle, `prisma/migrations/<timestamp>_<name>/` for Prisma) and call out whether the migration must be generated (`pnpm drizzle-kit generate` / `pnpm prisma migrate dev`).
   - **Render boundary:** `Server Component` | `Client Component ("use client")` | `Server Action ("use server")` | `Route Handler` — state this on every component touching the App Router or any RSC-aware framework. If the file mixes boundaries, split it.
   - **Tools the agent should use:** call out non-default tools when relevant — e.g. `WebFetch` to pull a doc URL listed above, `Grep` for a specific symbol before editing, `LSP` for cross-file refactors, or running `pnpm test` / `pnpm typecheck` / `pnpm lint` / `pnpm build` / `pnpm exec playwright test` after changes. Use the project's actual scripts (read `package.json`).
   Do not invent references. If you do not know the correct URL or line number, leave the bullet off rather than guess — the implementing agent can search.

8. **Write the task spec**: Create `tasks/<slug>.md` following this structure. Begin the file with a YAML frontmatter block containing `title`, `description`, `created_at`, and `updated_at` (both timestamps set to now in `YYYY-MM-DD HH:MM:SS` format on creation). Use `date '+%Y-%m-%d %H:%M:%S'` if you need to confirm the current timestamp. Do not repeat the `# <Title> — <Short Description>` heading inside the body — the frontmatter is the source of truth for both.

   ````markdown
   ---
   title: <Title>
   description: <Short Description>
   created_at: <YYYY-MM-DD HH:MM:SS>
   updated_at: <YYYY-MM-DD HH:MM:SS>
   ---

   **Depends on:** [other-task.md](other-task.md) (if applicable, omit section if none)
   **Coordinate with:** [sibling-task.md](sibling-task.md) — <one line on the overlap> (if applicable, omit if none)

   ### Container: <one-line C4 container description>

   <1-3 paragraph explanation of what this task does and why. Include context on how it fits into the broader system, and which render boundaries are involved (RSC vs Client vs Server Action).>

   **Read before starting (whole-milestone context):**
   - `<path>` — <why this file matters for the whole task>
   - `<path>` — <pattern to mirror / component to extend / caller to update>
   - `<route segment>/layout.tsx` — <only if the task touches routing>
   - `<design doc path>` — <specific section: design token, accessibility rule, domain idiom> (only if a design doc exists)
   - `CLAUDE.md` — <only if build/lint/test workflow is non-obvious>

   ### Components

   - [ ] **`<file path>`** — <description> (<C4 depth: Code | Component | Container>) — <Render boundary: Server Component | Client Component | Server Action | Route Handler | Hook | Pure module>
     ```tsx
     // Key types, props, hook signatures, action signatures
     export type FooId = string & { readonly __brand: "FooId" };

     export interface FooCardProps {
       foo: Foo;
       onSelect?: (id: FooId) => void;
     }

     export function FooCard({ foo, onSelect }: FooCardProps): React.ReactElement {
       // ...
     }
     ```
     - <Behavioral notes — props contract, error states, loading states, a11y roles>
     - **Read:** `<path>` (lines X-Y) — <why this exact region>
     - **Update callers:** `<path>` line N, `<path>` line N
     - **Docs to fetch:** <library/API> — <URL>
     - **Built-in:** `<React API>` (if a React/platform answer exists, prefer it)
     - **New dependency:** `<package>` (only if a `pnpm add` is required; mark `-D` for dev-only)
     - **Tools the agent should use:** <e.g. `WebFetch` for the doc URL above; `Grep` for `<symbol>` to find call sites; `pnpm test`, `pnpm typecheck`, and `pnpm lint` after the change>
     - Test: <specific test case — e.g. "renders error state when `foo.status === 'failed'`">
     - Test: <specific test case — e.g. "calls `onSelect` with the foo id on click">

   - [ ] **<Wiring / integration step>** — <description> (<C4 depth>) — <Render boundary>
     - **Read:** `<path>` (lines X-Y) — <why>
     - Test: <integration or E2E test, e.g. Playwright spec under `e2e/`>

   - [ ] **Version bump** — bump `version` in `package.json` (Code)
     - Bump type: <patch | minor | major>
     - At completion time, read the current `"version": "..."` line in `package.json` and apply the bump above. Run the project's install command (`pnpm install` / `bun install` / `npm install`) afterwards so the lockfile is regenerated. Do not pre-compute the new version here — it may be stale by the time this task runs.

   - [ ] **Documentation** (if needed)
     - Update `<design doc>`: <what to add/change> (only if a design doc exists in the repo)
     - Update `CHANGELOG.md`: add a new entry under the version produced by the bump above
     - Update TSDoc on `<exported item>`: <what to clarify>
     - Update/add Storybook story `<path>.stories.tsx`: <variants to cover> (only if Storybook is in use)
     - Update `.env.example`: <new keys> (only if new server-side env vars were added)

   - [ ] Verify: <end-to-end manual verification steps — e.g. "run `pnpm dev`, navigate to `/foo`, submit the form, confirm the optimistic update appears immediately and the persisted row is visible after refresh">
   ````

9. **C4 depth annotations**: Tag every component with its C4 model depth:
   - **Code** — pure domain types, branded IDs, reducers, schema definitions (Zod), formatters, presentational leaf components with no side effects (innermost)
   - **Component** — feature-scoped units: a Client Component with state, a custom hook, a Server Action, a route page, a route handler, a context provider
   - **Container** — top-level wiring: root `layout.tsx`, providers tree, middleware, route group composition, build config, runtime/lifecycle (outermost)

10. **Conventions to follow** (React 19 / 2026 idioms — derived from existing task specs):
    - **TypeScript everywhere.** All files are `.ts` / `.tsx` with `"strict": true`. Public exports get explicit return types; component props are exported `type` or `interface` so consumers can extend them. Avoid `any`; prefer `unknown` and narrow.
    - **Branded IDs** for domain identifiers: `type FooId = string & { readonly __brand: "FooId" }`. Use a constructor (`asFooId(s: string): FooId`) at the boundary so plain strings cannot be passed by accident.
    - **Server Components are the default** in App Router projects. Add `"use client"` only when the component uses state, effects, refs, browser APIs, or event handlers. Add `"use server"` only at the top of a file (or inline in a component) for Server Actions. Never put `"use client"` "just to be safe" — it cascades and bloats the client bundle.
    - **Forms use Server Actions + React 19 hooks.** Pass an action directly to `<form action={createFoo}>`; use `useActionState` for server-returned state, `useFormStatus` inside submit buttons for pending state, and `useOptimistic` for instant UI updates. Do not hand-roll `onSubmit` + `fetch` for form submissions in App Router projects.
    - **Async data in components** uses `use(promise)` inside a `<Suspense fallback={...}>` boundary, or framework-native loaders (Next.js `async` Server Components, React Router 7 `loader`). Do not fetch in `useEffect` for initial render data — that pattern is for client-only side-effects.
    - **Refs are props.** As of React 19, `forwardRef` is no longer needed for new components. Type a ref prop as `ref?: React.Ref<HTMLDivElement>` directly. Do not introduce `forwardRef` in new code.
    - **Context provider syntax**: prefer `<MyContext value={...}>` (React 19) over `<MyContext.Provider value={...}>` for new code. Both still work; the unprefixed form is the new idiom.
    - **State**: prefer `useState` and `useReducer` for local state, `useSyncExternalStore` for external stores, and a small library (Zustand or Jotai) for cross-tree global state. Avoid Redux for new projects unless the codebase already uses it.
    - **Server-state caching** uses TanStack Query (Client Components only) or framework loaders (RSC/Next.js/React Router). Do not cache server data in a global Zustand/Jotai store — let the framework handle revalidation.
    - **The React Compiler is on.** Do not hand-write `useMemo` / `useCallback` / `React.memo` unless profiling shows a measurable problem the compiler did not solve. If the project's config disables the compiler, follow the existing pattern.
    - **Validation** uses `zod` (or `valibot`) at every external boundary: form input, route params, server-action arguments, and external API responses. Infer types with `z.infer<typeof schema>` rather than declaring them twice.
    - **Errors**: throw inside Server Components / actions and let the nearest `error.tsx` boundary render. In Client Components, wrap risky subtrees in an `<ErrorBoundary>` (from `react-error-boundary` or a hand-rolled class). Never `try`/`catch` around a render to "swallow" an error — it just hides bugs.
    - **Logging**: server-side, use the project's logger (`pino` / `winston` / `next-logger`) with structured fields, e.g. `logger.info({ userId, action }, "event")`. Client-side, use `console.warn`/`console.error` sparingly and prefer surfacing errors via a toast or error boundary so users see them.
    - **Async** uses `async`/`await` exclusively in new code. Always cancel long-running effects with `AbortController` and check `signal.aborted` before setting state.
    - **Accessibility**: every interactive element has an accessible name. Use semantic HTML (`<button>`, `<a>`, `<label htmlFor>`); reach for `role="..."` only when no semantic element fits. Test with `getByRole(...)` — if RTL cannot find it by role, neither can a screen reader.
    - **Styling**: match the project's existing system (Tailwind v4, CSS Modules, vanilla-extract, or styled-components). Do not introduce a second styling system. For Tailwind, follow the project's design tokens (`tailwind.config.ts` or `@theme` block); do not hard-code arbitrary values like `text-[#3a7]` when a token exists.
    - **File layout**: components live next to their tests and stories — `Foo.tsx`, `Foo.test.tsx`, `Foo.stories.tsx` in the same directory. Hooks live in `src/hooks/use-foo.ts`. Server-only code lives under `src/server/` or in `*.server.ts` files. Module aliases (`@/components/...`) are defined in `tsconfig.json` `paths`.
    - **DB changes** use the project's migration tool (Drizzle Kit, Prisma Migrate, or raw SQL files). Migrations are append-only — never edit a shipped migration; create a new one to fix a prior mistake.
    - **Public-API hooks and components** in shared packages get TSDoc comments (`/** ... */`) so editor hover and generated docs stay accurate.
    - Every `Test:` line describes a single, specific assertion — not vague "test it works".
    - The final `- [ ] Verify:` item is a manual end-to-end smoke test in a real browser (or Playwright UI mode), not just `pnpm test`.
    - Keep milestone scope self-contained — the task should be independently verifiable.

11. **Review**: Read back the created file. Confirm it follows the pattern of existing tasks, has C4 annotations *and* render-boundary annotations on every component, includes specific test cases, and covers documentation updates. Verify the **Read before starting** list has 4–8 entries each with a *why*, and that every component bullet includes at least one **Read:** pointer plus, where relevant, **Docs to fetch:** / **Built-in:** / **Tools the agent should use:** sub-bullets.

## Rules

- Match the style and structure of existing task specs in `tasks/` exactly.
- Every component must have at least one `Test:` line with a specific, concrete assertion.
- Do not create placeholder tasks — every item must be actionable and verifiable.
- Include the C4 depth annotation (Code, Component, or Container) **and** the render boundary (Server Component, Client Component, Server Action, Route Handler, Hook, Pure module) on every checkbox item that maps to a file.
- If the task depends on another uncompleted task, state the dependency explicitly at the top.
- Use kebab-case for the filename slug (e.g., `optimistic-comments.md`, `route-error-boundary.md`).
- Prefer React 19 built-ins and the web platform over a new dependency when both work. Flag any new package install explicitly with the project's package manager and `-D` if dev-only.
- Match the project's existing tooling — do not introduce a second framework, styling system, state library, test runner, or package manager.
- All new code must pass `tsc --noEmit`, the project's ESLint config, and the project's formatter (Prettier or Biome) before the task is considered complete.
- Do not assume `spec.md` exists — check the repo first and reference whichever design doc the project actually uses (if any).
- Ask the user for clarification if the description is too vague to produce specific component breakdowns, or if the render boundary (Server vs Client) is ambiguous.
