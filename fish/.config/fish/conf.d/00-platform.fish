# Detect the current platform and set PLATFORM variable for use by other
# configurations (personal and work-specific dotfiles).

set -l os (uname -s)

if test "$os" = Darwin
    # macOS
    set -g PLATFORM macos
else if test -f /proc/version; and grep -qiE "(microsoft|wsl)" /proc/version
    # Windows Subsystem for Linux
    set -g PLATFORM wsl
else
    # Generic Linux
    set -g PLATFORM linux
end
