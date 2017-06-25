#!/usr/bin/env bash
# .bash_profile - bash login shell environment configuration

###########
# exports #
###########

# Set editor to `vim`.
export EDITOR='vim'
export VISUAL="$EDITOR"

########
# path #
#######

# Remove the specified 'directory' from the optionally specified 'path'
# variable.  If 'path' is not specified, PATH will be used.
# usage: pathremove <directory> <path>
pathremove() {
    local IFS=':'
    local NEWPATH
    local DIR
    local PATHVARIABLE=${2:-PATH}
    for DIR in ${!PATHVARIABLE}; do
        [[ "$DIR" != "$1" ]] &&
            NEWPATH=${NEWPATH:+$NEWPATH:}$DIR
    done
    export $PATHVARIABLE="$NEWPATH"
}

# Prepend the specified 'directory' to the optionally specified 'path'
# variable.  If 'path' is not specified, PATH will be used.  Note that any
# existing reference to the 'directory' will be removed from 'path'.
# usage: pathprepend <directory> <path>
pathprepend() {
    pathremove "$1" "$2"
    local PATHVARIABLE=${2:-PATH}
    export $PATHVARIABLE="$1${!PATHVARIABLE:+:${!PATHVARIABLE}}"
}

# Append the specified 'directory' to the optionally specified 'path' variable.
# If 'path' is not specified, PATH will be used.  Note that any existing
# reference to the 'directory' will be removed from 'path'.
## usage: pathappend <directory> <path>
pathappend() {
    pathremove "$1" "$2"
    local PATHVARIABLE=${2:-PATH}
    export $PATHVARIABLE="${!PATHVARIABLE:+${!PATHVARIABLE}:}$1"
}

# Build a path using the optionally specified 'command'  and the optionally
# specified 'path' variable.  If 'command' is not specified, pathappend will be
# used.  If 'path' is not specified, PATH will be used. The paths should be
# separated on their own line in a "here document".  An example of an
## "here document" can be seen below setting the PATH for personal directories.
build_path() {
    local PATHVAR=${1:-PATH}
    local PATHCMD=${2:-pathappend}
    local DIR
    while read -r DIR; do
        [ -d "$DIR" ] &&
            "$PATHCMD" "$DIR" "$PATHVAR"
    done
}

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

# Personal directories are always first in PATH.
build_path PATH pathprepend << EOF
$HOME/.local/bin
$HOME/bin
EOF

# Clean up temporary path helper functions.
unset pathremove pathprepend pathappend build_path

# For login shell, source .bashrc for good measure.
. ~/.bashrc
