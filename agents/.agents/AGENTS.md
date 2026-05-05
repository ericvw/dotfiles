# Personal AI Agent Preferences

Global instructions for AI coding agents across all projects and providers.

## Commit Guidelines

**Principles**:
- **Atomic commits**: One logical change per commit — don't mix unrelated changes even if made in the same session
- Focus on the **why** and context in commit messages, not the what — the diff shows the what
- Avoid redundant bullet lists of file changes; explain relationships and reasons for decisions instead

**Commit message format**:
```
[optional type/scope prefix: ]<subject line (max 72 characters)>

[optional body, each line max 72 characters]
```

**Format rules**:
- Imperative mood: "Add feature" not "Added feature"
- Blank line between subject and body
- Body lines: greedy word-wrap at 72 characters (`fmt -w 72 -g 72`)
- Only use type/scope prefixes if project history shows a consistent pattern (infer from `git log`)
- No AI trailers (Co-Authored-By, etc.)

**Anti-pattern** — listing what changed:
```
Update configuration

Changes:
- Modified file A
- Updated file B
```

**Better** — explaining why:
```
Update configuration to use maintained dependencies

Replace Nord theme with dim-ansi since Nord is no longer maintained.
```

**Before committing**:
1. Infer commit style from `git log --oneline -20`
2. Draft a message matching the project's conventions
3. Present for user review before committing

## Git Safety

- Never skip hooks (`--no-verify`) unless explicitly requested
- Create new commits rather than amending, unless explicitly asked
- Don't force push to main/master
- Confirm with user before destructive operations: force push, `git reset --hard`, deleting files or branches, overwriting uncommitted changes
- Prefer safer alternatives: `--force-with-lease` over `--force`, soft reset over hard reset
- Investigate failures before retrying — diagnose root causes, don't bypass safety mechanisms
- Match action scope to what was actually requested

## AI Assistant Collaboration

**Communication**:
- Match response length to task complexity: a simple question gets a direct answer, not headers and bullet sections
- Don't narrate internal deliberation — state results and decisions directly
- For exploratory questions ("what could we do?", "how should we approach this?"), give a brief recommendation with the main trade-off; don't implement until the user agrees
- Reference code with file paths and line numbers
- While working, give short updates at key moments — one sentence is enough

**Code changes**:
- Check for linting/formatting tools (Makefile, package.json, pyproject.toml) and run them before commits
- Verify changes don't break existing functionality by running existing tests
- Don't report success based on compilation or tests passing alone — verify the actual behavior changed as expected; if you can't verify (e.g., no access to a running environment), say so explicitly
- Prefer actively maintained dependencies over abandoned ones; document reasons for changes in commit messages

**Scope discipline**:
- Don't refactor, clean up, or introduce abstractions beyond what the task requires — a bug fix doesn't need surrounding cleanup
- Three similar lines is better than a premature abstraction; don't design for hypothetical future requirements
- Default to no comments; only add one when the WHY is non-obvious: a hidden constraint, a subtle invariant, a workaround for a specific bug
- Don't explain what code does — well-named identifiers already do that
- Don't add error handling for scenarios that can't happen; only validate at system boundaries (user input, external APIs)

**Configuration files**:
- Prefer EditorConfig (`.editorconfig`) for cross-editor settings like indentation, charset, and whitespace
- Use tool-specific config only for settings EditorConfig cannot handle

## AI Agent Config Files

When setting up AI agent configuration for a project:
- Put the actual content in `AGENTS.md`
- Tool-specific files (e.g., `CLAUDE.md`, `GEMINI.md`) should only contain a reference pointing to `AGENTS.md` (or the equivalent include syntax for that tool)
- The heading inside `AGENTS.md` should be `# AGENTS.md`, not tool-specific
