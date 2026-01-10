---
allowed-tools: Bash(git diff:*), Bash(git branch:*), Bash(git push:*)
description: Create a Draft PR on Github
---

## Context

- Current git diff (staged and unstaged changes): !`git diff main`
- Current branch: !`git branch --show-current`

# Git Instructions

## Commit Messages

- Use present tense in the imperative mood ("Add feature" not "Added feature")
- Check if there are any artifacts in debugging like js `console.log()` or php's `dd()`
- Keep subject line under 50 characters
- Follow project style: feat, fix, refactor, chore, test, style, perf, docs, etc.
- If we are on a branch with jet-_ convention, all commits should start with [JET-_]
- Run git add . before to make sure unstaged files are included in commit

## Pull Request Guidelines

- Apply the jet-\* rule to Pull request with title [JET-***] if exist
- Have first section titled # What Has Changed
- Add [SCREENSHOT] placeholders if believe they should be added with your description under it
- Have the second section titled # How To Test
- Keep brief, only core functional changes unless there are some gotchas
- If can, keep to no more than three bullet points in each section
- DO NOT add emojis
- Do not add new sections unless asked to
- Do no use verbose words, keep simple
- unless the changes are focused opn refactoring, simplifying code, you do not need to reference general refactoring, cleaning up code.
- Keeps sections concise, not verbose, simple language. if possible try to keep under three bullet points.

## Your task

Create a DRAFT PR

Remember to use the GitHub CLI ('gh') for all Github-related tasks.
<!--
Use this template for every PR. Keep it concise but complete.
Delete guidance comments (like this) before submitting.
-->

## What / Why

<!-- Brief problem statement and user impact.
Example:
- What: Add support for X
- Why: Users want to be able to do X because Y
- Context: Any additional context or information that would help reviewers understand the change.
-->

## How (Changes Made)

<!-- Summarize the approach and main changes.
Example:
- Describe the approach taken to implement the changes.
- Highlight any significant changes or additions.
-->

## Test Plan

<!--
Motivation: Write this as if someone else had to verify it in 10 minutes.
Be explicit and reproducible. Include commands, data, expected outputs, and where to look.

Examples:
- Update X Workspace config with the x.json config file in this pull request.
- Insert this workspace_import `INSERT INTO workspace_imports (workspace_id, ...) VALUES (99, ...);`
- Run `php artisan data:import 99 --force`
- Then check both on UI and DB that the import ran successfully.
- Check for missing or broken data
- Unit: `php artisan test --filter=ClassNameTest` should pass.

If a certain environment is needed to fully test, specify it here. If we should grab from prod or dev any data.
-->

## Screenshots / Evidence

<!--
Add **1–2** images even if not UI:
- Terminal output snippet (success/failure)
- Pages/components modified (if applicable)
- Full screenshots preferred so we can see the context
- Logs/metrics
- Small diff of config/feature flag
Drag & drop images here.
-->

### Owner Checklist

- [ ] I have added tests
- [ ] I have added documentation
- [ ] I have tested this code to the best of my ability
- [ ] I have tested backwards compatibility
- [ ] I have checked for security issues
- [ ] I have checked for performance issues

