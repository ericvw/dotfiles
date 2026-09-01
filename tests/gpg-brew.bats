#!/usr/bin/env bats

script="$BATS_TEST_DIRNAME/../wsl/.local/bin/gpg-brew"

write_executable() {
    cat > "$1"
    chmod +x "$1"
}

set_all_socket_states() {
    local state="$1" unit
    for unit in gpg-agent.socket gpg-agent-ssh.socket gpg-agent-extra.socket \
        gpg-agent-browser.socket keyboxd.socket dirmngr.socket; do
        printf '%s\n' "$state" > "$socket_state_dir/$unit"
    done
}

setup() {
    tmp=$(mktemp -d)
    stub_dir="$tmp/bin"
    mkdir -p "$stub_dir"

    call_log="$tmp/calls.log"
    : > "$call_log"

    proc_version="$tmp/proc_version"
    printf 'Linux version 6.6.87.2-microsoft-standard-WSL2\n' > "$proc_version"

    gnupg_home="$tmp/gnupg"
    mkdir -p "$gnupg_home"

    socket_state_dir="$tmp/socket_state"
    mkdir -p "$socket_state_dir"
    set_all_socket_states masked

    ps_output="$tmp/ps_output"
    : > "$ps_output"

    systemctl_unavailable_flag="$tmp/systemctl_unavailable"

    brew_prefix="$tmp/brew"
    mkdir -p "$brew_prefix/bin"

    # Homebrew's own gpg/gpgconf, deliberately NOT on PATH - resolved only
    # through HOMEBREW_PREFIX / `brew --prefix`, by absolute path.
    write_executable "$brew_prefix/bin/gpg" << 'EOF'
#!/usr/bin/env bash
if [[ "${1:-}" == "--version" ]]; then
    printf 'gpg (GnuPG) 2.5.21\n'
    printf 'libgcrypt 1.12.2\n'
fi
exit 0
EOF

    write_executable "$brew_prefix/bin/gpgconf" << EOF
#!/usr/bin/env bash
printf 'gpgconf(brew) %s\n' "\$*" >> "$call_log"
exit 0
EOF

    # systemctl stub: logs every invocation verbatim and answers is-enabled
    # from per-socket state files so tests can stage distro-owned,
    # homebrew-owned, or inconsistent states without touching the real
    # systemd user manager.
    write_executable "$stub_dir/systemctl" << EOF
#!/usr/bin/env bash
{
    printf 'systemctl'
    printf ' %s' "\$@"
    printf '\n'
} >> "$call_log"

args=("\$@")
if [[ "\${args[0]:-}" == "--user" ]]; then
    args=("\${args[@]:1}")
fi

case "\${args[0]:-}" in
    show-environment)
        [[ -f "$systemctl_unavailable_flag" ]] && exit 1
        exit 0
        ;;
    is-enabled)
        state_file="$socket_state_dir/\${args[1]}"
        if [[ -f "\$state_file" ]]; then
            if [[ "\$(cat "\$state_file")" == "__fail__" ]]; then
                exit 1
            fi
            cat "\$state_file"
        else
            printf 'masked\n'
        fi
        exit 0
        ;;
    *)
        exit 0
        ;;
esac
EOF

    write_executable "$stub_dir/brew" << EOF
#!/usr/bin/env bash
printf 'brew %s\n' "\$*" >> "$call_log"
if [[ "\${1:-}" == "--prefix" ]]; then
    printf '%s\n' "$brew_prefix"
    exit 0
fi
exit 1
EOF

    write_executable "$stub_dir/ps" << EOF
#!/usr/bin/env bash
cat "$ps_output" 2> /dev/null
exit 0
EOF

    # A decoy on PATH: if gpg-brew ever called "gpgconf" bare instead of by
    # Homebrew's absolute path, this is what would run.
    write_executable "$stub_dir/gpgconf" << EOF
#!/usr/bin/env bash
printf 'gpgconf(decoy) %s\n' "\$*" >> "$call_log"
exit 1
EOF

    # A PATH containing only what gpg-brew itself needs (bash, for its
    # shebang, plus grep/awk), with none of the stubs above and none of the
    # real machine's systemctl/brew/gpg/gpgconf/ps reachable. Used with
    # `PATH="$safe_dir" run ...` to test "not found" cases without any
    # chance of falling through to the real commands.
    safe_dir="$tmp/safe"
    mkdir -p "$safe_dir"
    local tool src
    for tool in bash grep awk; do
        src=$(command -v "$tool") || continue
        ln -s "$src" "$safe_dir/$tool"
    done

    export PATH="$stub_dir:$PATH"
    export GPG_BREW_PROC_VERSION="$proc_version"
    export GNUPGHOME="$gnupg_home"
    export HOMEBREW_PREFIX="$brew_prefix"
}

teardown() {
    rm -rf "$tmp"
}

# WSL detection {{{

@test "setup fails when not running under WSL" {
    printf 'Linux version 6.1.0-generic\n' > "$proc_version"
    run "$script" setup
    [ "$status" -eq 1 ]
    [[ "$output" =~ "only applies to WSL" ]]
}

@test "setup proceeds past the WSL check when a WSL marker is present" {
    : > "$systemctl_unavailable_flag"
    run "$script" setup
    [ "$status" -eq 1 ]
    [[ "$output" =~ "systemd user session" ]]
    [[ ! "$output" =~ "only applies to WSL" ]]
}

# }}}

# systemd user session {{{

@test "setup fails when systemctl is not on PATH" {
    rm "$stub_dir/systemctl"
    PATH="$stub_dir:$safe_dir" run "$script" setup
    [ "$status" -eq 1 ]
    [[ "$output" =~ "systemctl not found" ]]
}

@test "setup fails when the systemd user session is unavailable" {
    : > "$systemctl_unavailable_flag"
    run "$script" setup
    [ "$status" -eq 1 ]
    [[ "$output" =~ "No usable systemd user session" ]]
}

@test "restore fails when the systemd user session is unavailable" {
    : > "$systemctl_unavailable_flag"
    run "$script" restore
    [ "$status" -eq 1 ]
    [[ "$output" =~ "No usable systemd user session" ]]
}

# }}}

# Homebrew resolution {{{

@test "resolves Homebrew via HOMEBREW_PREFIX" {
    rm "$stub_dir/brew"
    run "$script" status
    [ "$status" -eq 0 ]
    [[ "$output" =~ "prefix:        $brew_prefix" ]]
}

@test "resolves Homebrew via brew --prefix when HOMEBREW_PREFIX is unset" {
    unset HOMEBREW_PREFIX
    run "$script" status
    [ "$status" -eq 0 ]
    [[ "$output" =~ "prefix:        $brew_prefix" ]]
}

@test "setup fails with an actionable message when Homebrew cannot be resolved" {
    unset HOMEBREW_PREFIX
    rm "$stub_dir/brew"
    PATH="$stub_dir:$safe_dir" run "$script" setup
    [ "$status" -eq 1 ]
    [[ "$output" =~ "Cannot resolve the Homebrew prefix" ]]
    ! grep -q 'mask' "$call_log"
}

@test "setup fails with a brew install hint when Homebrew GnuPG is missing" {
    rm "$brew_prefix/bin/gpg" "$brew_prefix/bin/gpgconf"
    run "$script" setup
    [ "$status" -eq 1 ]
    [[ "$output" =~ "brew install gnupg" ]]
    ! grep -q 'mask' "$call_log"
}

# }}}

# setup {{{

@test "setup masks the six managed sockets and kills daemons via Homebrew's gpgconf" {
    run "$script" setup
    [ "$status" -eq 0 ]
    grep -qx "systemctl --user mask --now gpg-agent.socket gpg-agent-ssh.socket gpg-agent-extra.socket gpg-agent-browser.socket keyboxd.socket dirmngr.socket" "$call_log"
    grep -q '^gpgconf(brew) --kill all$' "$call_log"
    ! grep -q 'gpgconf(decoy)' "$call_log"
}

@test "setup is idempotent" {
    run "$script" setup
    [ "$status" -eq 0 ]
    run "$script" setup
    [ "$status" -eq 0 ]
    [ "$(grep -c 'mask --now' "$call_log")" -eq 2 ]
}

# }}}

# restore {{{

@test "restore unmasks sockets, kills daemons, then starts the primary sockets" {
    run "$script" restore
    [ "$status" -eq 0 ]
    grep -qx "systemctl --user unmask gpg-agent.socket gpg-agent-ssh.socket gpg-agent-extra.socket gpg-agent-browser.socket keyboxd.socket dirmngr.socket" "$call_log"
    grep -q '^gpgconf(brew) --kill all$' "$call_log"
    grep -qx "systemctl --user start gpg-agent.socket keyboxd.socket dirmngr.socket" "$call_log"

    local unmask_line start_line
    unmask_line=$(grep -n 'systemctl --user unmask' "$call_log" | cut -d: -f1)
    start_line=$(grep -n 'systemctl --user start' "$call_log" | cut -d: -f1)
    [ "$unmask_line" -lt "$start_line" ]
}

@test "restore warns and still unmasks and starts when Homebrew GnuPG is unavailable" {
    unset HOMEBREW_PREFIX
    rm "$stub_dir/brew"
    PATH="$stub_dir:$safe_dir" run "$script" restore
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Homebrew GnuPG not found" ]]
    grep -q 'systemctl --user unmask' "$call_log"
    grep -q 'systemctl --user start' "$call_log"
    ! grep -q 'gpgconf(brew)' "$call_log"
}

@test "restore is idempotent" {
    run "$script" restore
    [ "$status" -eq 0 ]
    run "$script" restore
    [ "$status" -eq 0 ]
    [ "$(grep -c 'unmask' "$call_log")" -eq 2 ]
}

# }}}

# status {{{

@test "status reports homebrew-owned when sockets are masked and only Homebrew daemons run" {
    set_all_socket_states masked
    printf '111 %s/bin/gpg-agent --supervised\n' "$brew_prefix" > "$ps_output"
    printf '222 %s/lib/gnupg/keyboxd --supervised\n' "$brew_prefix" >> "$ps_output"
    run "$script" status
    [ "$status" -eq 0 ]
    [[ "$output" =~ "homebrew-owned" ]]
}

@test "status reports distro-owned when sockets are enabled and distro daemons run" {
    set_all_socket_states enabled
    printf '111 /usr/bin/gpg-agent --supervised\n' > "$ps_output"
    printf '222 /usr/lib/gnupg/keyboxd --supervised\n' >> "$ps_output"
    run "$script" status
    [ "$status" -eq 0 ]
    [[ "$output" =~ "distro-owned" ]]
}

@test "status flags an inconsistent state when sockets are masked but distro daemons remain" {
    set_all_socket_states masked
    printf '111 /usr/bin/gpg-agent --supervised\n' > "$ps_output"
    run "$script" status
    [ "$status" -eq 0 ]
    [[ "$output" =~ "inconsistent" ]]
}

@test "status reports use-keyboxd enabled from common.conf" {
    printf 'use-keyboxd\n' > "$gnupg_home/common.conf"
    run "$script" status
    [ "$status" -eq 0 ]
    [[ "$output" =~ "use-keyboxd:   enabled" ]]
}

@test "status reports use-keyboxd not enabled when common.conf lacks it" {
    printf '\n' > "$gnupg_home/common.conf"
    run "$script" status
    [ "$status" -eq 0 ]
    [[ "$output" =~ "use-keyboxd:   not enabled" ]]
}

@test "status prints the resolved gpg path and version" {
    run "$script" status
    [ "$status" -eq 0 ]
    [[ "$output" =~ "$brew_prefix/bin/gpg" ]]
    [[ "$output" =~ "2.5.21" ]]
}

@test "status still produces a report when Homebrew is unavailable" {
    unset HOMEBREW_PREFIX
    rm "$stub_dir/brew"
    PATH="$stub_dir:$safe_dir" run "$script" status
    [ "$status" -eq 0 ]
    [[ "$output" =~ "unresolved" ]]
}

@test "status reports indeterminate ownership when not running under WSL" {
    printf 'Linux version 6.1.0-generic\n' > "$proc_version"
    printf '111 /usr/bin/gpg-agent --supervised\n' > "$ps_output"
    run "$script" status
    [ "$status" -eq 0 ]
    [[ "$output" =~ "indeterminate" ]]
    [[ ! "$output" =~ "homebrew-owned" ]]
    [[ ! "$output" =~ "distro-owned" ]]
}

@test "status reports indeterminate ownership when the systemd user session is unavailable" {
    : > "$systemctl_unavailable_flag"
    printf '111 /usr/bin/gpg-agent --supervised\n' > "$ps_output"
    run "$script" status
    [ "$status" -eq 0 ]
    [[ "$output" =~ "indeterminate" ]]
    [[ ! "$output" =~ "homebrew-owned" ]]
    [[ ! "$output" =~ "distro-owned" ]]
}

@test "status still reports Homebrew diagnostics when ownership is indeterminate" {
    : > "$systemctl_unavailable_flag"
    run "$script" status
    [ "$status" -eq 0 ]
    [[ "$output" =~ "$brew_prefix/bin/gpg" ]]
    [[ "$output" =~ "2.5.21" ]]
}

@test "status reports indeterminate ownership when a socket probe fails" {
    printf '__fail__\n' > "$socket_state_dir/keyboxd.socket"
    run "$script" status
    [ "$status" -eq 0 ]
    [[ "$output" =~ "keyboxd.socket             unknown" ]]
    [[ "$output" =~ "indeterminate: one or more socket states could not be determined." ]]
    [[ ! "$output" =~ "homebrew-owned" ]]
    [[ ! "$output" =~ "distro-owned" ]]
}

@test "status reports indeterminate ownership when a socket probe returns no usable state" {
    : > "$socket_state_dir/dirmngr.socket"
    run "$script" status
    [ "$status" -eq 0 ]
    [[ "$output" =~ "dirmngr.socket             unknown" ]]
    [[ "$output" =~ "indeterminate: one or more socket states could not be determined." ]]
    [[ ! "$output" =~ "homebrew-owned" ]]
    [[ ! "$output" =~ "distro-owned" ]]
}

@test "status reports indeterminate, not inconsistent, when a socket state is unknown and a distro daemon is running" {
    set_all_socket_states masked
    printf '__fail__\n' > "$socket_state_dir/keyboxd.socket"
    printf '111 /usr/bin/gpg-agent --supervised\n' > "$ps_output"
    run "$script" status
    [ "$status" -eq 0 ]
    [[ "$output" =~ "indeterminate: one or more socket states could not be determined." ]]
    [[ ! "$output" =~ "inconsistent" ]]
    [[ ! "$output" =~ "homebrew-owned" ]]
    [[ ! "$output" =~ "distro-owned" ]]
}

@test "status reports indeterminate, not homebrew-owned, when a running daemon has unknown ownership" {
    set_all_socket_states masked
    printf '111 /opt/custom/bin/gpg-agent --supervised\n' > "$ps_output"
    run "$script" status
    [ "$status" -eq 0 ]
    [[ "$output" =~ "  111      unknown   /opt/custom/bin/gpg-agent --supervised" ]]
    [[ "$output" =~ "indeterminate: one or more running GnuPG daemons have unknown ownership." ]]
    [[ ! "$output" =~ "homebrew-owned" ]]
}

# }}}

# Argument parsing {{{

@test "rejects a trailing argument after a valid command" {
    run "$script" status extra-garbage
    [ "$status" -eq 1 ]
    [[ "$output" =~ "Unknown argument: extra-garbage" ]]
}

# }}}
