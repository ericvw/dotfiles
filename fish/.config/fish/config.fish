if not status is-interactive
    exit
end

# Disable the startup message.
set -g fish_greeting

# Only run `pip` in a virtual environment.
set -gx PIP_REQUIRE_VIRTUALENV true

# Save the network I/O and responsiveness of using `pip`.
set -gx PIP_DISABLE_PIP_VERSION_CHECK true

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
    set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
end

# Initialize pyenv and related plugins, if available.
if command -q pyenv
    set -gx PYENV_ROOT $HOME/.pyenv
    pyenv init - | source
end

if command -q pyenv-virtualenv-init
    pyenv virtualenv-init - | source
end
