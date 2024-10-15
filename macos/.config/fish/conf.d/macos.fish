if not status is-interactive
    exit
end

# Don't automatically run `brew update` before running other commands.
set -gx HOMEBREW_NO_AUTO_UPDATE 1

# Set environment variables for Homebrew.
/opt/homebrew/bin/brew shellenv | source

## XXX: Ensure -p|--path is used to ensure `pyenv` paths are prepended to final PATH.
set -l brew_prefix (brew --prefix)
fish_add_path -P -m $brew_prefix/opt/make/libexec/gnubin
fish_add_path -P -m $brew_prefix/opt/python/libexec/bin
fish_add_path -P -m $brew_prefix/opt/ccache/libexec
fish_add_path -P -m $brew_prefix/opt/curl/bin
fish_add_path -P -m $brew_prefix/opt/findutils/libexec/gnubin
fish_add_path -P -m $brew_prefix/opt/coreutils/libexec/gnubin
