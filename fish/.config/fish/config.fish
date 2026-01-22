if not status is-interactive
    exit
end

# Disable the startup message.
set -g fish_greeting

# Set hybrid mode keybindings that use Vi-style with inherited emacs-style bindings.
set --g fish_key_bindings fish_hybrid_key_bindings

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

# Only run `pip` in a virtual environment.
set -gx PIP_REQUIRE_VIRTUALENV true

# Save the network I/O and responsiveness of using `pip`.
set -gx PIP_DISABLE_PIP_VERSION_CHECK true

fish_add_path -P -m ~/.local/bin
fish_add_path -P -m ~/.nimble/bin
fish_add_path -P -m ~/.cargo/bin

# Setup editor to prefer neovim, if available.
if command -q nvim
    set -gx EDITOR nvim
else
    set -gx EDITOR vim
end
set -gx VISUAL $EDITOR

# Set up file type and extension colors for `ls` and `dir` output.
if command -q dircolors; and test -f ~/.dir_colors
    dircolors -c ~/.dir_colors | source
end

# Use `bat` as the man pager for colorized man pages, if available.
if command -q bat
    set -gx MANPAGER "sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat -p -lman'"
end

# Initialize pyenv and related plugins, if available.
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
