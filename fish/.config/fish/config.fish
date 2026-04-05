# vim: foldmethod=marker

if not status is-interactive
    exit
end

# Fish shell {{{
# Disable the startup message.
set -g fish_greeting

# Set hybrid mode keybindings that use Vi-style with inherited emacs-style bindings.
set --g fish_key_bindings fish_hybrid_key_bindings
# }}}

# Homebrew {{{
# Set up Homebrew environment.
for p in /opt/homebrew/bin /home/linuxbrew/.linuxbrew/bin
    if test -d $p
        # Configure $PATH, $MANPATH, and $INFOPATH.
        $p/brew shellenv | source

        # Don't automatically run `brew update` before running other commands.
        set -gx HOMEBREW_NO_AUTO_UPDATE 1

        break
    end
end

# Add Homebrew tool paths.
if command -q brew
    set -l brew_prefix (brew --prefix)
    fish_add_path -P -m $brew_prefix/opt/make/libexec/gnubin
    fish_add_path -P -m $brew_prefix/opt/python/libexec/bin
    fish_add_path -P -m $brew_prefix/opt/ccache/libexec
    fish_add_path -P -m $brew_prefix/opt/curl/bin
    fish_add_path -P -m $brew_prefix/opt/findutils/libexec/gnubin
    fish_add_path -P -m $brew_prefix/opt/coreutils/libexec/gnubin
end
# }}}

# Editor {{{
if command -q nvim
    set -gx EDITOR nvim
else
    set -gx EDITOR vim
end
set -gx VISUAL $EDITOR
# }}}

# dircolors {{{
# Set up file type and extension colors for `ls` and `dir` output.
if command -q dircolors; and test -f ~/.dir_colors
    dircolors -c ~/.dir_colors | source
end
# }}}

# manpager {{{
# Use `bat` as the man pager for colorized man pages, if available.
if command -q bat
    set -gx MANPAGER "sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat -p -lman'"
end
# }}}

# PATHs {{{
fish_add_path -P -m ~/.local/bin
fish_add_path -P -m ~/.nimble/bin
fish_add_path -P -m ~/.cargo/bin
# }}}

# keychain {{{
if command -q keychain
    keychain --eval --quiet -Q | source
end
# }}}

# pip {{{
# Only run `pip` in a virtual environment.
set -gx PIP_REQUIRE_VIRTUALENV true

# Save the network I/O and responsiveness of using `pip`.
set -gx PIP_DISABLE_PIP_VERSION_CHECK true
# }}}

# pyenv {{{
if test -d $HOME/.pyenv
    set -gx PYENV_ROOT $HOME/.pyenv
end

if test -d $PYENV_ROOT
    fish_add_path -P -m $PYENV_ROOT/bin
end

if command -q pyenv
    pyenv init - | source
end

if command -q pyenv-virtualenv-init
    pyenv virtualenv-init - | source
end
# }}}

# fnm {{{
if test -d $HOME/.local/share/fnm
    fish_add_path -P -m $HOME/.local/share/fnm
end

if command -q fnm
    fnm env | source
end
# }}}
