#!/usr/bin/env bash
# .bash_profile - bash login shell environment configuration

###########
# exports #
###########

# Set editor to `vim`.
export EDITOR='vim'
export VISUAL="$EDITOR"

# Source local override file if one exists.
[ -r ~/.bash_profile.local ] && . ~/.bash_profile.local

########
# misc #
########

# Setup coloring scheme for `ls`.
if command dircolors &> /dev/null; then
    # Use colors as specified in ~/.dir_colors.
    eval "$(dircolors -b ~/.dir_colors)"
fi

# For login shell, source .bashrc for good measure.
. ~/.bashrc
