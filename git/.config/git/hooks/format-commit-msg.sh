#!/usr/bin/env bash
# vim: foldmethod=marker
set -euo pipefail

# Constants {{{
WIDTH=72
# }}}

# Validate {{{
msgfile="$1"
have_line2=false
{
    read -r subject || true
    read -r line2 && have_line2=true || true
} < "$msgfile"

if [ -z "$subject" ]; then
    printf '[commit-msg] subject is required\n' >&2
    exit 1
fi

if [ "${#subject}" -gt "$WIDTH" ]; then
    printf '[commit-msg] subject exceeds %d characters: %d\n' \
        "$WIDTH" "${#subject}" >&2
    exit 1
fi

# Strip optional scope prefix (e.g. "scope: ") to get the subject text.
subject_text="${subject#*: }"
first_char="${subject_text:0:1}"
if [[ "$first_char" =~ [a-z] ]]; then
    printf '[commit-msg] subject must begin with a capital letter\n' >&2
    exit 1
fi

if "$have_line2" && [ -n "$line2" ]; then
    printf '[commit-msg] missing blank line after subject\n' >&2
    exit 1
fi
# }}}

# Format {{{
tmpfile=$(mktemp)

{
    printf '%s\n' "$subject"

    if "$have_line2"; then
        printf '%s\n' "$line2"
    fi

    body=$(tail -n +3 "$msgfile")
    if [ -n "$body" ]; then
        non_comment=$(printf '%s\n' "$body" | awk '/^#/{exit} {print}')
        trailer=$(printf '%s\n' "$body" | awk '/^#/{found=1} found{print}')

        if [ -n "$non_comment" ]; then
            printf '%s\n' "$non_comment" | fmt -w $WIDTH -g $WIDTH
        fi

        if [ -n "$trailer" ]; then
            [ -n "$non_comment" ] && printf '\n'
            printf '%s\n' "$trailer"
        fi
    fi
} > "$tmpfile"

mv "$tmpfile" "$msgfile"
# }}}
