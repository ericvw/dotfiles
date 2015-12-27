#!/usr/bin/env bash

readonly DOTFILES=$HOME/.dotfiles
readonly DOTFILES_LOCAL=$DOTFILES/local
readonly FILES=(
bash_profile
bashrc
dir_colors
gitconfig
inputrc
tmux.conf
)

echo -n "Changing to $DOTFILES"
cd "$DOTFILES" || exit
echo "...done"

for file in "${FILES[@]}"; do
    echo ".$file:"
    echo -n "  exists in ~/? "
    if [[ -f "$HOME/.$file" ]]; then
        echo "...yes"

        echo -n "  is symlink? "
        if [[ -L "$HOME/.$file" ]]; then
            echo "  ...yes"
            echo "  => all set"
            continue
        else
            echo "  ...no"
            echo -n "  => moving to $ORIGINAL "
            mv "$HOME/.$file" "$ORIGINAL"
        fi
    else
        echo "...no"
    fi

    echo -en "  => creating symlink in home directory "
    ln -s  -f "$DOTFILES/$file" "$HOME/.$file"
    echo "...done"
done
