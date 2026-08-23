---
name: handoff
description: Write durable session state to HANDOFF.md so work can continue after /clear. Use when the user asks for a handoff, or before /clear or /compact on a long session.
argument-hint: What the next session will focus on
---

Write `HANDOFF.md` at the repository root, capturing what a fresh session
needs to continue this work after `/clear`.

## Steps

1. Resolve the root with `git rev-parse --show-toplevel`. If that fails,
   this is not a repository: use the current directory and skip to step 4.
2. If `git ls-files --error-unmatch :/HANDOFF.md` succeeds the file is
   tracked - say so and do not write; overwriting committed content is not
   the intent.
3. If `git check-ignore -q <root>/HANDOFF.md` exits 1, the file is not
   ignored and `git add -A` would stage it. Say so, and offer to append
   `/HANDOFF.md` to `<dir>/info/exclude`, where `<dir>` is `git rev-parse
   --path-format=absolute --git-common-dir` - the common dir because a
   linked worktree's own gitdir has none, absolute because the default is
   relative to your shell, not to the root. Append only if the user
   confirms; never `.gitignore`, which is tracked and shared.
4. Write `<root>/HANDOFF.md` using the sections below. Replace any
   existing one, carrying forward whatever is still true.
5. Print the resume line: `@HANDOFF.md continue this work`.

## Content rules

- Write from what is already in context. Do not re-read project files,
  re-run commands, or launch searches to produce the handoff - one that
  costs 50k to write defeats its own purpose.
- Reference artifacts by path, symbol, or SHA - not line numbers, which
  rot on the next edit. Never paste file contents, diffs, or command
  output.
- Under `Verify`, list only commands this session actually ran and their
  last result - not the project's test command, which the next session can
  find itself.
- Redact secrets, tokens, and personally identifying information.
- Keep it to roughly one screen. Drop any heading with nothing to say.
- If the user named a focus, bias the document toward it.

## Sections

```markdown
# Handoff: <task>

## Goal
One paragraph. Why this work exists.

## State
- Branch: <name>, tree <clean|dirty>
- Done: ...
- In progress: ...
- Next: ...

## Decisions
- <choice> - because <why>

## Tried and rejected
- <approach> - failed because <reason>

## Pointers
- src/parser.py - quoting is unhandled here
- ~/.claude/plans/x.md - approved plan

## Verify
- `<command>` - <last known result>
```
