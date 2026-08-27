# Personal AI Agent Preferences

Global instructions for AI coding agents across all projects and providers.

## Writing Style

Applies to all generated prose: chat responses, docs, commit message bodies, PR descriptions, code comments.

**Banned constructions** - the clearest tells of machine-written prose:
- Antithesis: "it's not X, it's Y", "not just X, but Y", "less X, more Y". Say what something is, affirmatively; don't set up an opposite to knock down
- Balanced aphorism: two short parallel clauses where the second mirrors or inverts the first ("The tech works; the timing doesn't"). Make them separate plain statements
- Verbless fragments and bare imperatives inside narrative paragraphs. Give the sentence a subject and a verb; checklists and task bullets are exempt

**Mechanics**:
- Put the actor in the subject and the action in the verb: "the router queues the request", not "queuing of the request occurs in the router"
- Cut clauses whose only job is to announce structure ("the sections below cover..."); headings already do that
- Don't reach for rule-of-three lists or a closing summary line by reflex
- Use plain ASCII: prefer spaced hyphens ( - ) over em dashes, straight quotes over curly quotes

## Commit Guidelines

**Principles**:
- **Atomic commits**: One logical change per commit - don't mix unrelated changes even if made in the same session
- Focus on the **why** and context in commit messages, not the what - the diff shows the what
- Avoid redundant bullet lists of file changes; explain relationships and reasons for decisions instead

**Format rules**:
- Subject: imperative mood ("Add feature" not "Added feature"), max 72 characters
- Blank line between subject and body; body lines greedy word-wrapped at 72 characters (`fmt -w 72 -g 72`)
- Only use type/scope prefixes if project history shows a consistent pattern
- No AI trailers (Co-Authored-By, etc.)

Explain the why, as in:

```
Update configuration to use maintained dependencies

Replace Nord theme with dim-ansi since Nord is no longer maintained.
```

**Before committing**:
1. Infer commit style from `git log --oneline -20`
2. Run the project's checks (see Verification)
3. Present the drafted message for user review

## Git Safety

- Never skip hooks (`--no-verify`) unless explicitly requested
- Create new commits rather than amending, unless explicitly asked
- Don't force push to main/master
- Confirm with user before destructive operations: force push, `git reset --hard`, deleting files or branches, overwriting uncommitted changes
- Prefer safer alternatives: `--force-with-lease` over `--force`, soft reset over hard reset
- Investigate failures before retrying - diagnose root causes, don't bypass safety mechanisms
- Don't commit unless asked; don't push unless asked
- Treat modified or untracked files you didn't create as the user's in-flight work: don't revert, reformat, stash, or stage them
- Stage only the files your change touched; avoid `git add -A` and `git commit -a` when unrelated changes are present

## Verification

- Identify the project's checks from `AGENTS.md`, `CONTRIBUTING.md`, CI config, or the task runner (Makefile, package.json, pyproject.toml)
- Note pre-existing failures before changing code so you can tell them apart from ones you introduced
- Run the checks that exercise the changed behavior; report the exact commands and their outcomes
- Verify through a check that exercises the requested behavior - a regression test, direct execution, inspecting output. Don't infer success from an unrelated suite staying green
- If you can't verify, say what went unverified and why

## AI Assistant Collaboration

**Communication**:
- Keep responses focused and concise; match depth to the stakes and complexity of the task - a simple question gets a direct answer, not headers and bullet sections
- Keep disclaimers and caveats short - spend most of the response on the main answer
- Don't narrate internal deliberation - state results and decisions directly
- For exploratory questions ("what could we do?", "how should we approach this?") and for review, critique, or analysis requests, give a brief recommendation with the main trade-off; don't edit files until the user agrees
- Reference code with file paths and line numbers
- Before the first tool call on nontrivial work, say in one sentence what you're about to do. While working, give a brief update only when you find something important or change direction
- When finishing, lead with the outcome - the first sentence answers "what happened" or "what did you find", with supporting detail after it
- Correct an earlier statement only when the error changes the user's decisions; fix silent slips silently

**Written documents**:
- Match the length of written documents to what the task needs: cover the substance, but don't pad with filler sections, redundant summaries, or boilerplate

**Code changes**:
- Prefer actively maintained dependencies over abandoned ones; document reasons for changes in commit messages
- Update dependency manifests and lockfiles together; don't hand-edit lockfiles or other generated files when a generator exists

**Scope discipline**:
- Deliver the request at the scope intended; finish it fully and stop at its edges
- Don't refactor, clean up, or introduce abstractions beyond what the task requires - a bug fix doesn't need surrounding cleanup
- Three similar lines is better than a premature abstraction; don't design for hypothetical future requirements
- Default to no comments; only add one when the WHY is non-obvious: a hidden constraint, a subtle invariant, a workaround for a specific bug
- Don't explain what code does - well-named identifiers already do that
- Validate at system boundaries (user input, external APIs) and handle documented failure modes; skip speculative defensive code for internal states
- Don't catch or suppress errors without an intentional recovery or reporting path

## Project Conventions

- Honor the repository's existing formatter, linter, and EditorConfig setup. When establishing or revising cross-editor settings, prefer `.editorconfig` for indentation, charset, and whitespace; use tool-specific config only for what EditorConfig cannot handle
- Put agent instructions in `AGENTS.md`; tool-specific files (`CLAUDE.md`, `GEMINI.md`) should only contain a reference or include pointing to it
- The heading inside `AGENTS.md` should be `# AGENTS.md`, not tool-specific
