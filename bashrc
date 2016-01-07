#!/usr/bin/env bash
# .bashrc - bash instance configuration

# Set paths to dotfiles and local override directories.
DOTFILES=$HOME/.dotfiles
DOTFILES_LOCAL=$DOTFILES/local

# Don't source rest of this file  if session is not interactive.
[ -z "$PS1" ] && return

# Load dotfiles specific for each bash instance.
for file in "$DOTFILES"/{prompt,aliases,functions}; do
    . "$file"
done
unset file

################################
## bash environment variables ##
################################

# Keep up to 32^3 lines of history.
HISTFILESIZE=32768
HISTSIZE=$HISTFILESIZE

# Ignore commands that:
#   * begin with a space character
#   * that is the same as the previous
# and remove duplicate commands.
HISTCONTROL=ignoreboth:erasedups

# Ignore these commands in history.
HISTIGNORE="[bf]g:cd*:clear:exit:history*:jobs:..*"

# Always append history to history file after each command.
PROMPT_COMMAND='history -a'

###############################
## bash >= 3.x shell options ##
###############################

# Auto-correct minor typos on `cd`.
shopt -s cdspell

# If hash lookup fails, default to $PATH.
shopt -s checkhash

# Update winsize after each command for better line-wrapping.
shopt -s checkwinsize

# Save muti-line command as one history entry.
shopt -s cmdhist

# Append history rather than overwrite it.
shopt -s histappend

# Allow re-edit of failed history substitution.
shopt -s histreedit

# Load history subsitution into editing buffer.
shopt -s histverify

# Don't start auto-completion if there is nothing on the command line.
shopt -s no_empty_cmd_completion

###############################
## bash >= 4.x shell options ##
###############################

if [ 4 -eq "${BASH_VERSINFO[0]}" ]; then
    # List status of any jobs before shell exit.
    shopt -s checkjobs

    # Auto-correct minor typos on directory word completion.
    shopt -s dirspell

    # Recursive globbing (e.g., ls **/*.txt).
    shopt -s globstar

    if [[ 2 -eq "${BASH_VERSINFO[1]}" && 29 -le "${BASH_VERSINFO[2]}" ]]; then
        # Expand directory names (e.g., $HOME => /home/$(whoami)).
        shopt -s direxpand
    fi
fi

# Source local override file if one exists.
[ -r "$DOTFILES_LOCAL"/bashrc ] && . "$DOTFILES_LOCAL"/bashrc
