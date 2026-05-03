# AGENTS.md

This file provides guidance to AI coding agents when working with code in this repository.

## Repository Overview

Personal dotfiles repository using GNU Stow for symlink management. Supports macOS and WSL (Windows Subsystem for Linux) with platform-aware configuration.

## Installation

```bash
# Install dotfiles to $HOME (default)
bash ./install.sh

# Options:
# --dry-run       Show stow actions without applying
# --verbose       Verbose stow output
# --no-restow     Use stow (not --restow)
# TARGET_DIR=/custom/path ./install.sh  # Custom target directory
```

The install script auto-detects platform (macOS/WSL) and stows appropriate packages.

## Development Commands

```bash
# Format files (Lua, brew-formulae.txt)
make format        # or make format-lua, make format-brew-formulae

# Lint shell scripts
make lint          # or make lint-shell

# Run tests
make test          # or make test-bats
```

**Code conventions**:
- `.editorconfig` enforces:
  - UTF-8 charset, final newlines, trim trailing whitespace (all files)
  - 4-space indentation (default, explicitly set for Lua)
  - Tab indentation (Makefiles only)
- Shell scripts and Lua files use vim foldmarkers (`# vim: foldmethod=marker` with `{{{`/`}}}` sections)

## Package Organization

### Stow Package Structure

Each tool lives in its own directory (e.g., `fish/`, `neovim/`, `git/`). When stowed, files are symlinked to `$HOME` preserving their relative paths.

Example:
- `fish/.config/fish/config.fish` → `~/.config/fish/config.fish`
- `git/.config/git/config` → `~/.config/git/config`

### Common vs Platform-Specific Packages

**Common packages** (always installed):
- agents - Universal AI agent instructions (AGENTS.md)
- bash - Bash shell configuration (.bashrc, .bash_profile, .inputrc)
- bat - Cat clone with syntax highlighting
- claude - Claude Code settings and custom status line script
- dircolors - Color scheme for ls/directory listings
- fish - Interactive shell (primary shell)
- git - Version control configuration with aliases and platform-specific includes
- neovim - Primary editor with LSP, tree-sitter, and native plugin management
- opencode - OpenCode AI agent TUI configuration
- quilt - Debian patch management tool configuration
- tmux - Terminal multiplexer
- vim - Lean fallback editor when Neovim is unavailable

**Optional packages**:
- gemini - Gemini CLI settings and instructions

**Platform-specific packages**:
- macOS: kitty (terminal emulator with theme support), linearmouse (mouse configuration), macos (macOS-specific settings)
- WSL: wsl (WSL-specific configuration)

**Important architectural principle**: Base packages handle cross-platform logic internally via runtime detection. Platform-specific packages (`macos/`, `wsl/`) should ONLY contain configuration that cannot be handled cross-platform.

Examples:
- ✅ Homebrew path detection in `fish/.config/fish/config.fish` (detects `/opt/homebrew` vs `/home/linuxbrew`)
- ✅ Git credential helpers in `macos/.config/git/platform` and `wsl/.config/git/platform` (different paths per OS)
- ❌ Duplicating Homebrew initialization across base and platform-specific fish configs

## Key Configuration Patterns

**General principle**: Prefer EditorConfig (`.editorconfig`) for cross-editor settings like indentation, charset, and whitespace. Use editor-specific ftplugin files only for settings that EditorConfig cannot handle.

### Claude Code Configuration

- `claude/.claude/settings.json` - Claude Code settings (attribution, theme, editor mode, status line command)
- `claude/.claude/statusline.sh` - Custom two-line status line script

The status line displays two lines of context:
- **Line 1** (workspace): vim mode indicator, current directory, git worktree,
  branch, ahead/behind upstream, staged/unstaged/untracked/deleted file counts,
  line insertions/deletions vs HEAD
- **Line 2** (session): model name, session name, cost with lines added/removed,
  context window percentage (color-coded: waveAqua1 < 60%, roninYellow ≥ 60%,
  samuraiRed ≥ 80% — thresholds account for the ~33k autocompact buffer),
  cumulative session token count (compact k/M format)

Colors use the Kanagawa Wave palette (24-bit ANSI). Git status colors mirror
the palette's designated diff colors: autumnGreen (staged/added), autumnYellow
(modified), autumnRed (deleted), springViolet1 (untracked).

### Gemini CLI Configuration

- `GEMINI.md` - Root-level instructions that import `AGENTS.md` to guide the Gemini agent
- `gemini/.gemini/settings.json` - Gemini CLI settings (theme, editor mode)
- `gemini/.gemini/GEMINI.md` - Package-level instructions importing `AGENTS.md`

### Git Configuration

- Base config: `git/.config/git/config`
- Platform-specific config included via `[include] path = platform`
- Platform files: `macos/.config/git/platform`, `wsl/.config/git/platform`
- Work-specific config: `[includeIf "gitdir:~/work/"] path = work`
- `core.hooksPath = ~/.config/git/hooks` applies hooks globally to all repos
- `git/.config/git/hooks/commit-msg` - Thin wrapper invoking `format-commit-msg.sh`
- `git/.config/git/hooks/format-commit-msg.sh` - Validates and formats commit messages:
  rejects empty subjects, subjects over 72 characters, uncapitalized subjects, and
  missing blank lines between subject and non-comment body; git template comments
  directly after the subject are treated as an empty body (blank separator
  auto-inserted); wraps body lines greedily at 72 characters using `fmt -w 72 -g 72`

### Neovim Configuration

Uses Neovim's built-in package manager (`vim.pack.add()`).

Modular Lua structure in `neovim/.config/nvim/`:
- `init.lua` - Entry point that requires modules
- `lua/config/` - Core configuration (options, keymaps, autocmds, plugins, LSP, diagnostics, platform)
- `lua/config/plugins.lua` - Plugin specifications loaded via `vim.pack.add()` (UI, editor, filetype support, tree-sitter, LSP, linting)
- `ftplugin/` - Filetype-specific settings
- `colors/` - Color scheme files

Key plugins auto-update tree-sitter parsers via PackChanged hook when nvim-treesitter is installed/updated.

Platform-specific logic in `lua/config/platform.lua`.

### Vim Configuration

Philosophy: Vim serves as a **lean, reliable fallback** when Neovim is unavailable.

Configuration principles:
- **Backport essential features** from Neovim (fuzzy completion, enhanced cursor restoration, auto-create directories)
- **Use simple defaults** - avoid complex plugin configurations (e.g., no custom theme settings for lightline)
- **Prefer EditorConfig** for language-specific settings over ftplugin files
- **Remove unused language configs** - don't maintain ftplugin files for languages not actively developed
- **Auto-create directories** - backup/undo directories created at runtime instead of tracking empty directories via Stow
- **Custom colorscheme** - Uses `dim-ansi` (Nord theme is no longer maintained)

Structure:
- `.vimrc` - Single file configuration with vim-plug for plugin management
- `ftplugin/` - Minimal filetype settings (gitcommit, gitconfig, mail only)
- `colors/` - Custom color schemes

### Fish Shell Configuration

- Main config: `fish/.config/fish/config.fish`
- Organized with vim foldmarkers for sections
- Platform detection for Homebrew paths (`/opt/homebrew` vs `/home/linuxbrew/.linuxbrew`)
- Tool initialization: pyenv, fnm (Fast Node Manager), dircolors, keychain

### Commit Guidelines

**Principles**:
- **Atomic commits**: One logical change per commit
- **Separate features**: Don't bundle unrelated changes
- **Follow project norms**: Infer commit message style from `git log` history
- **User review**: Always propose commit messages for review before committing

**Commit message format**:
```
<scope>: <subject>

[optional body, each line max 72 characters]
```

**Examples**:
```
opencode: Encourage thoughtful recommendations from AI agents

AGENTS.md: Document Vim as lean fallback and EditorConfig preference

neovim: Remove Go ftplugin

vim: Backport Neovim features for simple fallback

git: Add platform-specific credential helper configuration

Configures osxkeychain for macOS and manager-core for WSL to enable
secure credential storage appropriate to each platform.
```

**Format rules**:
- **Scope**: Package name (neovim, fish, git, vim, opencode, etc.) or AGENTS.md for changes to this file - REQUIRED
- **Subject**: Clear, concise imperative description (max 72 chars including scope prefix)
- **Body lines**: Greedy word-wrap to maximize each line up to 72 characters
  - Use `fmt -w 72 -g 72` for greedy wrapping
  - Pack as many complete words as possible per line before breaking
  - Break at word boundaries, not mid-word
- **Imperative mood**: "Add feature" not "Added feature"
- **Blank line**: Separate subject from body
- **No AI trailers**: Do not add Co-Authored-By or similar trailers crediting AI agents

**Before committing**:
1. Draft a commit message following the format above
2. Present the message to the user for review before committing

Body wrapping and subject validation are enforced automatically by the
`commit-msg` hook, which runs on every commit regardless of how it is
invoked.

**Git workflow best practices**:
- Never skip git hooks (`--no-verify`) unless explicitly requested
- Create new commits rather than amending existing ones
- Check `git status` and `git diff` before committing
- Don't force push to main/master branches
- Investigate failures before retrying commands

## Dependencies

Homebrew formulae listed in `brew-formulae.txt`. Key dependencies:
- `stow` - Required for installation
- `stylua` - Lua formatting
- `shellcheck` - Shell script linting
- `neovim` - Primary editor
- `fish` - Interactive shell
- `pyenv`, `pyenv-virtualenv` - Python version management
- Development tools: bat, gh, tree-sitter-cli

## Testing Changes

After modifying configs:

1. **Shell scripts**: `make lint` (runs shellcheck on `*.sh`)
2. **Lua files, brew-formulae.txt**: `make format` (runs stylua, sort)
3. **commit-msg formatter**: `make test` (runs bats tests in `tests/`)
