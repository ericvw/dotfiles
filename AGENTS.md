# AGENTS.md

This file provides guidance to AI coding agents when working with code
in this repository. Read [ARCHITECTURE.md](ARCHITECTURE.md) first if a
change affects repository structure, package ownership, platform
behavior, installation behavior, or any other architectural boundary.

## Installation

```bash
# Install dotfiles to $HOME (default)
bash ./install.sh

# Options:
# --dry-run           Show stow actions without applying
# --verbose           Verbose stow output
# --no-restow         Use stow (not --restow)
# --package <name>    Also stow <name> (repeatable)
# TARGET_DIR=/custom/path ./install.sh  # Custom target directory
```

Use `--dry-run` to preview the effect of a change to `install.sh` or
to a package's file layout before applying it. See `install.sh
--help` for the full option/package list, and
[ARCHITECTURE.md](ARCHITECTURE.md) for how package selection works.

## Development Commands

```bash
# Format files (Lua, shell scripts, brew-formulae.txt)
make format        # or make format-lua, make format-shell, make format-brew-formulae

# Lint shell scripts
make lint          # or make lint-shell

# Run tests
make test          # or make test-bats
```

**Code conventions**:
- The root `.editorconfig` governs this repository's own files: UTF-8
  charset, final newlines, trimmed trailing whitespace, 4-space
  indentation (tabs for Makefiles and Go). The separate
  `editorconfig/.editorconfig` package is unrelated config stowed into
  `$HOME` for other projects; see
  [ARCHITECTURE.md](ARCHITECTURE.md#configuration-ownership-and-composition).
- Shell scripts and Lua files use vim foldmarkers (`# vim:
  foldmethod=marker` with `{{{`/`}}}` sections).

## Change Guidance

See [ARCHITECTURE.md's "Where changes belong"](ARCHITECTURE.md#where-changes-belong)
table to decide where a change goes. One operational detail that table
doesn't cover: to add or remove a package from the default platform
package set, edit the `COMMON_PACKAGES`, `MACOS_PACKAGES`, or
`WSL_PACKAGES` arrays in `install.sh`; its `--help` output and
package-skip warning are derived from those arrays, so there's nothing
else to keep in sync.

Wrap prose in shell scripts, commit messages, and similar hand-wrapped
text with `fmt -w 72 -g 72` (or match the existing width in the file).

## Component Notes

- **Git `commit-msg` hook** (`git/.config/git/hooks/`): rules are
  covered by `tests/format-commit-msg.bats`. Run `make test` after
  editing `format-commit-msg.sh`.
- **`wsl/.local/bin/gpg-brew`**: WSL-only. Exists because Homebrew's
  `gpg`/`gpg-agent`/`keyboxd` on WSL is typically newer than Ubuntu's
  systemd-socket-activated versions, which otherwise produces "server
  is older than us" warnings on every fresh spawn; `gpgconf --kill
  all` alone doesn't fix this since the next connection re-activates
  the distro daemons. `gpg-brew setup`/`restore`/`status` mask/unmask
  Ubuntu's GnuPG systemd user sockets so Homebrew's daemons can own
  them instead; see `gpg-brew --help` for details. It does not
  configure SSH authentication — this repository's SSH agent is
  `keychain` (see `fish/.config/fish/config.fish`).
- **Claude subagents** (`claude/.claude/agents/`): exist for context
  isolation, not unique capability. Don't add a custom subagent or
  skill that duplicates the built-in `Explore`/`Plan` agents or the
  `/security-review`/`/simplify` skills.

### Commit Conventions

This project requires a scope prefix on every commit - the global
guidelines make prefixes optional, but here they are mandatory.

**Format**:
```
<scope>: <subject>

[optional body, each line max 72 characters]
```

**Scope**: Stow package name for changes within a package (neovim,
fish, git, vim, etc.) or filename for root-level files
(AGENTS.md, Makefile, install.sh, etc.).

**Examples**:
```
AGENTS.md: Document Vim as lean fallback and EditorConfig preference

neovim: Remove Go ftplugin

git: Add platform-specific credential helper configuration

Configures osxkeychain for macOS and manager-core for WSL to enable
secure credential storage appropriate to each platform.
```

Body wrapping and subject validation are enforced automatically by the
`commit-msg` hook.

## Dependencies

Homebrew formulae are declared in `brew-formulae.txt` (see
[ARCHITECTURE.md](ARCHITECTURE.md#configuration-ownership-and-composition)
for its role). Notably, `shfmt` is required by `make format-shell` but
is not yet listed there.

## Testing Changes

After modifying configs:

1. **Shell scripts**: `make lint` (runs shellcheck) and `make format-shell`
   (runs shfmt) - both cover `*.sh` files and executables stowed under a
   package's `.local/bin/`
2. **Lua files, brew-formulae.txt**: `make format` (runs stylua, sort)
3. **commit-msg formatter**: `make test` (runs bats tests in `tests/`)
