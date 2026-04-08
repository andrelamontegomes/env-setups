---
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git commit:*)
description: Create a git commit
---

## Context

- Current git status: !`git status`
- Current git diff (staged and unstaged changes): !`git diff HEAD`
- Current branch: !`git branch --show-current`
- Recent commits: !`git log --oneline -10`

## Your task

Based on the above changes, create a single git commit.

# Git Instructions

## Commit Messages

- Use present tense in the imperative mood ("Add feature" not "Added feature")
- Check if there are any artifacts in debugging like js `console.log()` or php's `dd()`
- Keep subject line under 50 characters
- Follow project style: feat, fix, refactor, chore, test, style, perf, docs, etc.
- Run git add . before to make sure unstaged files are included in commit

## Pull Request Guidelines

- Have first section titled # What Has Changed
- Add [SCREENSHOT] placeholders if believe they should be added with your description under it
- Have the second section titled # How To Test
- Keep brief, only core functional changes unless there are some gotchas
- If can, keep to no more than three bullet points in each section
- Do not add emojis
- Do not add new sections unless asked to
- Do no use verbose words, keep simple
