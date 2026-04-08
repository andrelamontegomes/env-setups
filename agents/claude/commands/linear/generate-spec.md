---
allowed-tools: Bash(git diff:*), Bash(git branch:*), Bash(git push:*), Bash(git commit:*))
description: Generate Spec from Linear
---

## Context

- Search Linear with identifier JET-$ARGUMENTS
- Branches based on linear task are JET-$ARGUMENTS

### Your Task

You are helping create a detailed specification file for an AI agent development task. Please use the Linear MCP tools to gather comprehensive information about the issue and create a detailed spec.md file.

### Steps:

1. **Fetch Issue Details** using Linear MCP tools:

   - Get the issue title, description, and full requirements
   - Check for acceptance criteria or success metrics
   - Look for any linked issues, dependencies, or subtasks
   - Check assignee, labels, project, and team information
   - Identify the priority and due date if set

2. **Analyze Technical Requirements**:

   - Identify what type of work this is (frontend, backend, full-stack, etc.)
   - Determine which parts of the Laravel/React codebase will be affected
   - Note any specific technologies, libraries, or patterns mentioned
   - Check for any architectural considerations

3. **Generate Specification** in this exact format:

```markdown
# {{ISSUE_ID}} Agent Specification

## Issue Overview

- **Linear Issue**: {{ISSUE_ID}}
- **Title**: [Full issue title]
- **Priority**: [Priority level]
- **Assignee**: [Assignee name or "Unassigned"]
- **Labels**: [List of labels]
- **Due Date**: [Due date or "Not set"]

## Requirements

[Detailed description of what needs to be built/fixed]

## Acceptance Criteria

- [ ] [Criterion 1]
- [ ] [Criterion 2]
- [ ] [Add all criteria from Linear issue]

## Technical Scope

### Files Likely to Change

- [ ] [List specific files or file patterns]
- [ ] [Based on the requirements analysis]

### Technologies/Patterns Involved

- [ ] [Laravel features needed]
- [ ] [React components/patterns]
- [ ] [Database changes if any]
- [ ] [Testing requirements]

## Development Plan

### Phase 1: Analysis & Setup

- [ ] Create git branch: jet-[task_number]-[descriptive-name]
- [ ] Set up development environment
- [ ] Review existing related code

### Phase 2: Implementation

- [ ] [Specific implementation steps based on requirements]
- [ ] [Break down into logical chunks]

### Phase 3: Testing & Documentation

- [ ] Write/update tests
- [ ] Test functionality manually
- [ ] Update documentation if needed

## Agent Environment

- **Agent Name**: {{AGENT_NAME}}
- **Laravel URL**: http://localhost:{{PORT}}
- **Vite URL**: http://localhost:{{VITE_PORT}}

## Dependencies & Context

[Any linked issues, related work, or context from Linear]

## Progress Notes

_Agent will update this section during development_

Make the specification as detailed and actionable as possible for the AI agent that will work on this task.
```
