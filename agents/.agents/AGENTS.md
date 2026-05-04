# Personal AI Agent Preferences

Global instructions for AI coding agents across all projects and providers.

## Commit Guidelines

**Principles**:
- **Atomic commits**: One logical change per commit. Don't mix unrelated changes even if made in the same session (e.g., don't combine Vim and Neovim updates, or backend and frontend changes)
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
  - Use `fmt -w 72 -g 72` for greedy wrapping
  - Pack as many complete words as possible per line before breaking
  - Break at word boundaries, not mid-word
- **Imperative mood**: "Add feature" not "Added feature"
- **Blank line**: Separate subject from body
- **Prefixes**: Only use if the project history shows a consistent pattern (infer from `git log`)
  - Don't add generic conventional commit prefixes unless the project already uses them
- **No AI trailers**: Do not add Co-Authored-By or similar trailers crediting AI agents

**What to include in commit messages**:
- Focus on the **why** and **context**, not the what - the diff shows the what
- Avoid redundant bullet lists of file changes - git shows this
- When changes touch multiple areas, explain the relationship, not just list them
- Include reasons for decisions (e.g., "Nord is no longer maintained")

**Anti-pattern** (redundant bullets):
```
Update configuration

Changes:
- Modified file A
- Updated file B
- Removed file C
```

**Better** (explains why):
```
Update configuration to use maintained dependencies

Replace Nord theme with dim-ansi since Nord is no longer maintained.
Remove deprecated YCM configurations in favor of built-in LSP.
```

**Before committing**:
1. Run `git log --oneline -20` to understand the project's commit message conventions
2. Check for type/scope prefix patterns in recent commits (e.g., some projects use `neovim:`, `docs:`, etc.)
3. Draft a commit message matching the project's style
4. Verify body wrapping: run `fmt -w 72 -g 72` on the body and confirm the
   output matches the draft exactly
5. Present the message to the user for review before committing

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
- Create new commits rather than amending existing ones, unless explicitly asked
- Check `git status` and `git diff` before committing
- Don't force push to main/master branches
- Investigate failures before retrying commands

**Destructive and irreversible operations**:
- Consider reversibility and blast radius before acting; the cost of pausing
  to confirm is low, the cost of an unwanted action can be high
- Confirm with the user before: force pushing, `git reset --hard`, dropping
  database tables, deleting files or branches, overwriting uncommitted changes
- Prefer safer alternatives where they exist: `--force-with-lease` over
  `--force`, soft reset over hard reset
- Unauthorized destructive actions — even ones that seem implied — are not
  acceptable; match the scope of actions to what was actually requested

## AI Assistant Collaboration

**Communication**:
- Match response length to task complexity: a simple question gets a direct
  answer, not headers and bullet sections
- Don't narrate internal deliberation — state results and decisions directly
- For exploratory questions ("what could we do?", "how should we approach
  this?"), give a brief recommendation with the main trade-off; don't
  implement until the user agrees
- Ask clarifying questions when requirements are unclear
- Reference code with file paths and line numbers
- While working, give short updates at key moments: when you find something
  relevant, change direction, or hit a blocker — one sentence is enough

**Code Changes**:
- Read files before modifying them
- Follow existing patterns and conventions in the project
- Check for linting/formatting tools:
  - Look in `Makefile`, `package.json`, `pyproject.toml`, or other task runners
  - Run discovered formatters/linters before commits (e.g., `make format`, `make lint`)
- Verify changes don't break existing functionality by running existing tests

**Scope discipline**:
- Don't refactor, clean up, or introduce abstractions beyond what the task
  requires — a bug fix doesn't need surrounding cleanup; a one-shot script
  doesn't need a helper
- Three similar lines is better than a premature abstraction; don't design
  for hypothetical future requirements
- Default to no comments; only add one when the WHY is non-obvious: a hidden
  constraint, a subtle invariant, a workaround for a specific bug. If removing
  the comment wouldn't confuse a future reader, don't write it
- Don't explain what code does — well-named identifiers already do that
- Don't add error handling for scenarios that can't happen; only validate at
  system boundaries (user input, external APIs); trust internal code and
  framework guarantees

**Verification**:
- Run existing tests after changes to confirm nothing is broken
- Don't report success based on the code compiling or tests passing alone —
  verify the actual behavior changed as expected
- If you can't verify (e.g., no access to a running environment), say so
  explicitly rather than assuming it works

**Configuration Files**:
- Prefer EditorConfig (`.editorconfig`) for cross-editor/cross-tool settings like indentation, charset, and whitespace
- Use tool-specific config files only for settings EditorConfig cannot handle
- Check for existing EditorConfig before adding language-specific editor configurations

**AI Agent Config Files**:
- When creating project-level AI agent configuration, always put the actual content in `AGENTS.md`
- Any tool-specific files (e.g., `CLAUDE.md`, `GEMINI.md`) should only contain a reference/include pointing to `@AGENTS.md` (or the equivalent syntax for that tool)
- The heading inside `AGENTS.md` should be `# AGENTS.md`, not tool-specific like `# CLAUDE.md` or `# GEMINI.md`

**Decision Making**:
- When multiple valid approaches exist, present options with trade-offs and recommend the best approach
- Prefer existing patterns over new abstractions, but discuss when existing patterns should evolve
- Don't add features beyond the requested scope
- Explain architectural decisions and their implications
- Respect existing project conventions while suggesting improvements when valuable

**Dependencies and Tools**:
- Prefer actively maintained projects over abandoned ones
- Document reasons for dependency changes in commit messages (e.g., "X is no longer maintained")
- Consider fallback options for critical tools (e.g., simpler alternatives when primary tools are unavailable)

**Error Handling**:
- Diagnose root causes before retrying failed operations
- Don't use destructive operations as shortcuts
- Investigate issues rather than bypassing safety mechanisms
