#!/usr/bin/env bash

set -euo pipefail

# Configuration
# -------------
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${TARGET_DIR:-$HOME}"

# Flags
# -----
ASSUME_YES=false
DRY_RUN=false
VERBOSE=false
RESTOW=true   # restow = re-link (recommended). Set false to only stow new.

usage() {
    cat <<EOF
Usage: ./install.sh [options]

Options:
  --yes            Non-interactive; assume yes for prompts
  --dry-run        Show stow actions without applying
  --verbose        Verbose stow output
  --no-restow      Use stow (not --restow)
  -h, --help       Show help

Env overrides:
  TARGET_DIR=/path/to/target   (default: \$HOME)
EOF
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --yes) ASSUME_YES=true; shift ;;
        --dry-run) DRY_RUN=true; shift ;;
        --verbose) VERBOSE=true; shift ;;
        --no-restow) RESTOW=false; shift ;;
        -h|--help) usage; exit 0 ;;
        *) echo "Unknown arg: $1"; usage; exit 1 ;;
    esac
done

# Helpers
# -------
log()  { printf "\033[1;34m==>\033[0m %s\n" "$*"; }
warn() { printf "\033[1;33m!!\033[0m %s\n" "$*"; }
err()  { printf "\033[1;31mxx\033[0m %s\n" "$*"; }

confirm() {
    local prompt="${1:-Continue?}"
    $ASSUME_YES && return 0
    read -r -p "$prompt [y/N] " ans
    [[ "${ans:-}" =~ ^[Yy]$ ]]
}

have() { command -v "$1" >/dev/null 2>&1; }

is_macos() { [[ "$(uname -s)" == "Darwin" ]]; }

is_wsl() {
    # Works for WSL1/WSL2
    grep -qiE "(microsoft|wsl)" /proc/version 2>/dev/null
}

# Platform detection
PLATFORM="unknown"
if is_macos; then
    PLATFORM="macos"
elif is_wsl; then
    PLATFORM="wsl"
else
    warn "Unknown platform. This script targets macOS and WSL (Ubuntu/Debian)."
    PLATFORM="linux"
fi

if ! have stow; then
    err "GNU stow is required but not found on PATH."
    warn "Install it first (e.g. brew install stow or apt-get install stow) then re-run."
    exit 1
fi

COMMON_PACKAGES=(
    bash
    bat
    dircolors
    fish
    git
    neovim
    tmux
    vim
)

MACOS_PACKAGES=(
    kitty
    linearmouse
    macos
)

WSL_PACKAGES=(
    wsl
    # linux
)

packages_for_platform() {
    local -a pkgs=()
    pkgs+=("${COMMON_PACKAGES[@]}")

    case "$PLATFORM" in
        macos) pkgs+=("${MACOS_PACKAGES[@]}") ;;
        wsl)   pkgs+=("${WSL_PACKAGES[@]}") ;;
        *) warn "Unknown PLATFORM '$PLATFORM' - using COMMON only." ;;
    esac

    # Filter to only directories that exist to avoid stow errors.
    local -a existing=()
    local p
    for p in "${pkgs[@]}"; do
        if [[ -d "$DOTFILES_DIR/$p" ]]; then
            existing+=("$p")
        else
            warn "Package '$p' not found (no directory at $DOTFILES_DIR/$p); skipping."
        fi
    done

    printf "%s\n" "${existing[@]}"
}

# ----------------------------
# Run stow
# ----------------------------
build_stow_args() {
    local -a args=()
    args+=(--dir "$DOTFILES_DIR" --target "$TARGET_DIR")

    # Prefer deterministic behavior
    args+=(--no-folding)

    if $VERBOSE; then
        args+=(-v)
    fi

    if $DRY_RUN; then
        args+=(--simulate)
    fi

    if $RESTOW; then
        # Restow re-applies links cleanly if you rename/move things.
        args+=(--restow)
    fi

    echo "${args[@]}"
}

main() {
    log "Platform: $PLATFORM"
    log "Dotfiles: $DOTFILES_DIR"
    log "Target:   $TARGET_DIR"

    mapfile -t PKGS < <(packages_for_platform)

    if [[ "${#PKGS[@]}" -eq 0 ]]; then
        err "No stow packages selected (or none exist)."
        exit 1
    fi

    log "Will stow packages:"
    for p in "${PKGS[@]}"; do
        echo "  - $p"
    done

    local stow_args
    stow_args="$(build_stow_args)"

    log "Running: stow $stow_args ${PKGS[*]}"
    # shellcheck disable=SC2086
    stow $stow_args "${PKGS[@]}"

    log "Dotfiles installed via stow."
}

main
