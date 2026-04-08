Complete a task spec file from the `tasks/` directory.

## Instructions

1. **Read the spec**: Read `tasks/$ARGUMENTS` (the task spec file provided as the argument). If the file is not found, list available files in `tasks/` and ask the user which one to work on.

2. **Read project context**: Read `spec.md`, `CLAUDE.md`, and `CHANGELOG.md` to understand project conventions, architecture, tech stack, and recent changes before writing any code. Also run `git log --oneline -5` to review the last 5 commits for additional context on recent work.

3. **Work through each unchecked item**: For every `- [ ]` checkbox in the spec file:
   - Read any existing files that will be modified.
   - Implement the component, wiring, or verification described in the checkbox.
   - Write tests as specified inline with each task item.
   - Run `make test` to confirm tests pass.
   - Run `make lint` to confirm code is clean.
   - Mark the checkbox `- [x]` in the task spec file immediately after that item passes.

4. **Final verification**: After all items are checked:
   - Run `make test` and `make lint` one final time to confirm everything passes together.
   - Run the end-to-end verification step (the last checkbox in the spec) if present.

5. **Move to done**: Move the completed task spec file to `tasks/done/`:
   ```
   git mv tasks/$ARGUMENTS tasks/done/$ARGUMENTS
   ```

6. **Commit**: Create a git commit with the message format:
   ```
   feat: <short description matching the task title>
   ```
   Stage both the new/modified source files and the moved task spec.

## Rules

- Follow the architecture and conventions in `spec.md` exactly.
- Do not modify code outside the scope of the current task spec.
- Do not skip test specifications -- every "Test:" line in the spec must have a corresponding test.
- If a step fails, diagnose and fix before moving on. Do not mark a checkbox until its tests pass.
- Use `make test` and `make lint` inside the Podman container (the Makefile handles this).
