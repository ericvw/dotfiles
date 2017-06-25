#!/usr/bin/env bash

readonly DOTFILES=~/.dotfiles
readonly PACKAGES=(
bash
git
quilt
tmux
)

cd "$DOTFILES" || exit
for pkg in "${PACKAGES[@]}"; do
    stow "$pkg"
done
