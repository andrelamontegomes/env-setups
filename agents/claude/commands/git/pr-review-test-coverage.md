---
allowed-tools: Bash(git diff:*), Bash(git branch:*), Bash(git commit:*)
description: Review PR and propose test coverage if needed
---

## Context

- View PR by number `gh pr view $ARGUMENTS`

## Your task

- Tests can we create that are focus on the change
- Non verbose, prevents future regressions
- Review existing unit/feature test, may also have frontend and backend
- Unit test are tests for individual classes, methods or function in isolation.
- Unit test do not interact with the database, filesystem or external services
- Unit test use mocking to isolate dependencies
- Unit test are fast to execute
- Feature test full request/response cycle
- Feture test may interact with database, routes, middleware, controllers
- Follow existing testing patterns in the app
- Follow existing file naming, paths, and variable naming in the app

Remember to use the GitHub CLI ('gh') for all Github-related tasks.
