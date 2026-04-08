#!/usr/bin/env bash
# .bash_profile - bash login shell environment configuration
# vim: foldmethod=marker

#: Homebrew {{{

# Set up Homebrew environment.
for p in /opt/homebrew/bin /home/linuxbrew/.linuxbrew/bin; do
    if [[ -d "$p" ]]; then
        eval "$("$p/brew" shellenv)"
        export HOMEBREW_NO_AUTO_UPDATE=1
        break
    fi
done

# Add Homebrew tool paths.
if command -v brew &>/dev/null; then
    _brew_prefix="$(brew --prefix)"
    PATH="$_brew_prefix/opt/make/libexec/gnubin:$PATH"
    PATH="$_brew_prefix/opt/python/libexec/bin:$PATH"
    PATH="$_brew_prefix/opt/ccache/libexec:$PATH"
    PATH="$_brew_prefix/opt/curl/bin:$PATH"
    PATH="$_brew_prefix/opt/findutils/libexec/gnubin:$PATH"
    PATH="$_brew_prefix/opt/coreutils/libexec/gnubin:$PATH"
    export PATH
    unset _brew_prefix
fi

#: }}}

#: Exports {{{

# Set editor to `vim`.
export EDITOR='vim'
export VISUAL="$EDITOR"

#: }}}

# Source local override file if one exists.
[ -r ~/.bash_profile.local ] && . ~/.bash_profile.local

#: Misc {{{

# Setup coloring scheme for `ls`.
if command dircolors &> /dev/null; then
    # Use colors as specified in ~/.dir_colors.
    eval "$(dircolors -b ~/.dir_colors)"
fi

#: }}}

# For login shell, source .bashrc for good measure.
. ~/.bashrc
