@~/.agents/AGENTS.md

## Model Selection

Default to `sonnet[1m]` if 1M context is freely available, otherwise
`sonnet`. Escalate based on task scope:

- `sonnet[1m]` / `sonnet` — focused fixes, single-file changes, following known patterns
- `opusplan` — multi-file features, unclear root cause, planning-first work
- `opus[1m]` — large/unfamiliar codebases, architecture decisions

Use `/clear` between unrelated tasks. Start a fresh session rather
than repeatedly correcting a bad path.
