---
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git push:*), Bash(git commit:*), Bash(git diff:*), AskUserQuestion
description: Create a git commit and push
---

## Context

- Current git status: !`git status`
- Current git diff (staged and unstaged changes): !`git diff HEAD`
- Current branch: !`git branch --show-current`
- Recent commits: !`git log --oneline -10`

## Your task

Based on the above changes, create a single git commit and push.

## Concurrent edits check

Before staging anything, walk the diff of each file you intend to commit and
compare it against the edits you actually made this session. If a file
contains changes you did not make — another agent or the user edited it — do
not resolve the situation yourself: never commit those foreign changes,
never `git stash`, never `git checkout`/`git restore` them away. Stop and
ask with AskUserQuestion, one question per affected file (or one multiSelect
question if several files are affected), offering:

- Commit the file as-is, including the other agent's changes
- Stage only your hunks (`git add -p`) and leave theirs unstaged
- Leave the file out of this commit entirely
- Abort the commit

Files in the working tree that you never touched are not part of this check
— simply never stage them, per the rules below. Nothing is pushed until the
question is answered and the commit is built from the user's choice.

## Commit Messages

- Use present tense in the imperative mood ("Add feature" not "Added feature")
- Check if there are any artifacts in debugging like js `console.log()` or php's `dd()`
- Keep subject line under 50 characters
- Follow project style: feat, fix, refactor, chore, test, style, perf, docs, etc.
- Only commit files you have worked on in this session — other agents may be working in the same project
- NEVER run `git add .` or `git add -A`; stage explicitly with `git add [files]`, listing only your files

## Pull Request Guidelines

- Have first section titled # What Has Changed
- Add [SCREENSHOT] placeholders if believe they should be added with your description under it
- Have the second section titled # How To Test
- Keep brief, only core functional changes unless there are some gotchas
- If can, keep to no more than three bullet points in each section
- Do not add emojis
- Do not add new sections unless asked to
- Do no use verbose words, keep simple
