#!/usr/bin/env bash
# vim: foldmethod=marker
set -euo pipefail

# Constants {{{
WIDTH=72
# }}}

# Format Body Helper {{{
format_body() {
    local chunk_type=
    local -a chunk_lines=()

    flush_chunk() {
        [ ${#chunk_lines[@]} -eq 0 ] && return
        case "$chunk_type" in
            blank)
                printf '\n'
                ;;
            list)
                printf '%s\n' "${chunk_lines[@]}" |
                    fmt -t -w "$WIDTH" -g "$WIDTH"
                ;;
            para)
                printf '%s\n' "${chunk_lines[@]}" | fmt -w "$WIDTH" -g "$WIDTH"
                ;;
        esac
        chunk_type=
        chunk_lines=()
    }

    local line
    while IFS= read -r line || [ -n "$line" ]; do
        if [ -z "$line" ]; then
            flush_chunk
            chunk_type=blank
            chunk_lines=("")
            flush_chunk
        elif [[ "$line" =~ ^([[:space:]]*[-*+][[:space:]]) ]] ||
            [[ "$line" =~ ^([[:space:]]*[0-9]+\.[[:space:]]) ]]; then
            flush_chunk
            chunk_type=list
            chunk_lines=("$line")
        elif [[ "$line" =~ ^[[:space:]]{2} ]] && [ "$chunk_type" = list ]; then
            chunk_lines+=("$line")
        else
            [ "$chunk_type" != para ] && flush_chunk && chunk_type=para
            chunk_lines+=("$line")
        fi
    done
    flush_chunk
    unset -f flush_chunk
}
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

if "$have_line2" && [ -n "$line2" ] && [[ "$line2" != '#'* ]]; then
    printf '[commit-msg] missing blank line after subject\n' >&2
    exit 1
fi
# }}}

# Format {{{
tmpfile=$(mktemp)
trap 'rm -f "$tmpfile"' EXIT

{
    printf '%s\n' "$subject"

    if "$have_line2"; then
        [[ "$line2" == '#'* ]] && printf '\n'
        printf '%s\n' "$line2"
    fi

    body=$(tail -n +3 "$msgfile")
    if [ -n "$body" ]; then
        non_comment=$(printf '%s\n' "$body" | awk '/^#/{exit} {print}')
        trailer=$(printf '%s\n' "$body" | awk '/^#/{found=1} found{print}')

        if [ -n "$non_comment" ]; then
            printf '%s\n' "$non_comment" | format_body
        fi

        if [ -n "$trailer" ]; then
            [ -n "$non_comment" ] && printf '\n'
            printf '%s\n' "$trailer"
        fi
    fi
} > "$tmpfile"

mv "$tmpfile" "$msgfile"
# }}}
