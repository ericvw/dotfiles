# Personal AI Agent Preferences

Global instructions for AI coding agents across all projects and providers.

## Commit Guidelines

**Principles**:
- **Atomic commits**: One logical change per commit
- **Separate features**: Don't bundle unrelated changes
- **Follow project norms**: Infer commit message style from `git log` history
- **User review**: Always propose commit messages for review before committing

**Commit message format**:
```
[optional type/scope prefix: ]<subject line (max 72 characters)>

[optional body, each line max 72 characters]
```

**Format rules**:
- **Subject**: Clear, concise (maximum 72 characters including any prefix)
- **Body lines**: Greedy word-wrap to maximize each line up to 72 characters
  - Use `fmt -w 72` for greedy wrapping
  - Pack as many complete words as possible per line before breaking
  - Break at word boundaries, not mid-word
- **Imperative mood**: "Add feature" not "Added feature"
- **Blank line**: Separate subject from body
- **Prefixes**: Only use if the project history shows a consistent pattern (infer from `git log`)
  - Don't add generic conventional commit prefixes unless the project already uses them
- **No AI trailers**: Do not add Co-Authored-By or similar trailers crediting AI agents

**Before committing**:
1. Run `git log --oneline -20` to understand the project's commit message conventions
2. Check for type/scope prefix patterns in recent commits (e.g., some projects use `neovim:`, `docs:`, etc.)
3. Draft a commit message matching the project's style
4. Present the message to the user for review before committing

**Example** (no prefix - use when project history doesn't show prefix pattern):
```
Add user authentication endpoint

Implement JWT-based authentication with refresh tokens.
Includes middleware for protected routes.
```

**Example** (with prefix - use when project consistently uses prefixes):
```
auth: Add user authentication endpoint

Implement JWT-based authentication with refresh tokens.
Includes middleware for protected routes.
```

## Git Workflow

**Safe practices**:
- Never skip git hooks (`--no-verify`) unless explicitly requested
- Create new commits rather than amending existing ones
- Check `git status` and `git diff` before committing
- Don't force push to main/master branches
- Investigate failures before retrying commands

## AI Assistant Collaboration

**Communication**:
- Be concise and direct
- Provide context for decisions when needed
- Ask clarifying questions when requirements are unclear
- Reference code with file paths and line numbers

**Code Changes**:
- Read files before modifying them
- Follow existing patterns and conventions in the project
- Check for linting/formatting tools:
  - Look in `Makefile`, `package.json`, `pyproject.toml`, or other task runners
  - Run discovered formatters/linters before commits (e.g., `make format`, `make lint`)
- Verify changes don't break existing functionality

**Decision Making**:
- Prefer existing patterns over new abstractions
- Don't add features beyond the requested scope
- Ask for guidance when multiple valid approaches exist
- Respect existing project conventions and architecture

**Error Handling**:
- Diagnose root causes before retrying failed operations
- Don't use destructive operations as shortcuts
- Investigate issues rather than bypassing safety mechanisms
