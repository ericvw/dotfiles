---
name: handoff
description: Write durable session state to HANDOFF.md so work can continue after /clear. Use when the user asks for a handoff, or before /clear or /compact on a long session.
argument-hint: What the next session will focus on
---

Write `HANDOFF.md` in the current directory, capturing what a fresh
session needs to continue this work after `/clear`.

## Steps

1. If the working tree holds work this session finished, commit it
   before writing the handoff, following the project's commit
   guidelines. Leave genuinely in-progress edits uncommitted and
   describe them under `State`.
2. Write `HANDOFF.md` using the sections below. Replace any existing
   one, carrying forward whatever is still true.
3. Print the resume line: `@HANDOFF.md continue this work`.

## Content rules

- Write from what is already in context. Do not re-read project files,
  re-run commands, or launch searches to produce the handoff - one that
  costs 50k to write defeats its own purpose.
- Reference artifacts by path, symbol, or SHA - not line numbers, which
  rot on the next edit. Never paste file contents, diffs, or command
  output.
- Record commits by short SHA and subject so the next session can read
  the range with `git log`.
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
- Committed this session: <sha> <subject>, ...
- Uncommitted: <what is in the tree and why it is not committed>
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
