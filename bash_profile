#!/usr/bin/env bash
# .bash_profile - bash login shell environment configuration

# Set paths to dotfiles and local override directories.
DOTFILES=$HOME/.dotfiles
DOTFILES_LOCAL=$DOTFILES/local

# Load dotfiles for login shell.
for file in "$DOTFILES"/{path,exports}; do
    . "$file"
done
unset file

# Setup coloring scheme for `ls`.
if command dircolors &> /dev/null; then
    # Use colors as specified in ~/.dir_colors.
    eval "$(dircolors -b "$HOME"/.dir_colors)"
fi

# Source local override file if one exists.
[ -r "$DOTFILES_LOCAL"/bash_profile ] && . "$DOTFILES_LOCAL"/bash_profile

# For login shell, source .bashrc for good measure.
. "$HOME"/.bashrc
