#!/usr/bin/env bash
# .bashrc - bash instance configuration

# Don't source rest of this file if session is not interactive.
[ -z "$PS1" ] && return

##########
# prompt #
##########

# Gentoo/cygwin style, two-line prompt.
PS1='\[\e[0;32m\]\u\[\e[0;36m\]@\[\e[0;32m\]\h\[\e[0;34m\] \w\[\e[0;32m\]\n\[\e[00m\]\$ '

###########
# aliases #
###########

# Navigation
alias -- -='cd -'

# `ls` color flag detection.
if command ls --color &> /dev/null; then
    # GNU `ls`
    COLORFLAG='--color=auto'
else
    # OS X `ls`
    COLORFLAG='-G'
fi
alias ls="command ls ${COLORFLAG}"

#############
# functions #
#############

# Navigate with `.. [#]`.
function .. {
    local n="$1"
    if [[ -n "$n" && ! "$n" =~ ^[1-9][0-9]*$ ]]; then
        echo "positive integer expected" >&2; return 1
    fi
    [[ "$n" -gt 0 ]] && ((n--))
    local s
    printf -v s "..%${n}s"
    cd "${s// //..}"
}

##############################
# bash environment variables #
##############################

# Keep up to 32^3 lines of history.
HISTFILESIZE=32768

# Save every command from the history list.
HISTSIZE=-1

# Ignore commands that:
#   * begin with a space character
#   * that is the same as the previous
# and remove duplicate commands.
HISTCONTROL=ignoreboth:erasedups

# Always append history to history file after each command.
PROMPT_COMMAND='history -a'

#######################
# POSIX shell options #
#######################

# Prevent existing files from being overwritten by redirection.
set -o noclobber

######################
# bash shell options #
######################

# Auto-correct minor typos on `cd`.
shopt -s cdspell

# If hash lookup fails, default to $PATH.
shopt -s checkhash

# List status of any jobs before shell exit.
shopt -s checkjobs

# Update winsize after each command for better line-wrapping.
shopt -s checkwinsize

# Save muti-line command as one history entry.
shopt -s cmdhist

# Expand directory names (e.g., $HOME => /home/$(whoami)).
shopt -s direxpand

# Auto-correct minor typos on directory word completion.
shopt -s dirspell

# Recursive globbing (e.g., ls **/*.txt).
shopt -s globstar

# Append history rather than overwrite it.
shopt -s histappend

# Allow re-edit of failed history substitution.
shopt -s histreedit

# Load history substitution into editing buffer.
shopt -s histverify

# Don't start auto-completion if there is nothing on the command line.
shopt -s no_empty_cmd_completion

################
# stty options #
################

# Disable STARt/STOP output control (i.e., allow for Ctrl-s).
stty -ixon

# Source local override file if one exists.
[ -r ~/.bashrc.local ] && . ~/.bashrc.local
