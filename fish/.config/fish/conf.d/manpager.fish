# Use `bat` as the man pager for colorized man pages.
if command -qs bat
    set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
end
