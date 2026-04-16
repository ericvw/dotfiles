#!/usr/bin/env bats

formatter="$BATS_TEST_DIRNAME/../git/.config/git/hooks/format-commit-msg.sh"

setup() {
    tmp_msg=$(mktemp)
}

teardown() {
    rm -f "$tmp_msg"
}

# Subject: required {{{

@test "empty subject fails" {
    printf '\n' > "$tmp_msg"
    run "$formatter" "$tmp_msg"
    [ "$status" -eq 1 ]
    [[ "$output" =~ "[commit-msg] subject is required" ]]
}

# }}}

# Subject: length {{{

@test "subject at exactly 72 characters passes" {
    printf '%072d\n' 0 > "$tmp_msg"
    run "$formatter" "$tmp_msg"
    [ "$status" -eq 0 ]
}

@test "subject at 73 characters fails" {
    printf '%073d\n' 0 > "$tmp_msg"
    run "$formatter" "$tmp_msg"
    [ "$status" -eq 1 ]
    [[ "$output" =~ "[commit-msg] subject exceeds 72 characters" ]]
}

@test "subject too long leaves file unmodified" {
    printf '%073d\n' 0 > "$tmp_msg"
    original=$(cat "$tmp_msg")
    run "$formatter" "$tmp_msg"
    [ "$status" -eq 1 ]
    [ "$(cat "$tmp_msg")" = "$original" ]
}

# }}}

# Subject: capitalization {{{

@test "uppercase subject without scope passes" {
    printf 'Fix the bug\n' > "$tmp_msg"
    run "$formatter" "$tmp_msg"
    [ "$status" -eq 0 ]
}

@test "lowercase subject without scope fails" {
    printf 'fix the bug\n' > "$tmp_msg"
    run "$formatter" "$tmp_msg"
    [ "$status" -eq 1 ]
    [[ "$output" =~ "[commit-msg] subject must begin with a capital letter" ]]
}

@test "scoped subject with uppercase text passes" {
    printf 'scope: Fix the bug\n' > "$tmp_msg"
    run "$formatter" "$tmp_msg"
    [ "$status" -eq 0 ]
}

@test "scoped subject with lowercase text fails" {
    printf 'scope: fix the bug\n' > "$tmp_msg"
    run "$formatter" "$tmp_msg"
    [ "$status" -eq 1 ]
    [[ "$output" =~ "[commit-msg] subject must begin with a capital letter" ]]
}

# }}}

# Subject: blank line separator {{{

@test "body without blank line after subject fails" {
    printf 'scope: Fix the bug\nBody without blank line.\n' > "$tmp_msg"
    run "$formatter" "$tmp_msg"
    [ "$status" -eq 1 ]
    [[ "$output" =~ "[commit-msg] missing blank line after subject" ]]
}

# }}}

# Body: formatting {{{

@test "subject only passes and file is unchanged" {
    printf 'scope: Fix the bug\n' > "$tmp_msg"
    original=$(cat "$tmp_msg")
    run "$formatter" "$tmp_msg"
    [ "$status" -eq 0 ]
    [ "$(cat "$tmp_msg")" = "$original" ]
}

@test "subject and blank line passes and file is unchanged" {
    printf 'scope: Fix the bug\n\n' > "$tmp_msg"
    original=$(cat "$tmp_msg")
    run "$formatter" "$tmp_msg"
    [ "$status" -eq 0 ]
    [ "$(cat "$tmp_msg")" = "$original" ]
}

@test "body is wrapped greedily" {
    # "seventy-two" is the last word that fits within 72 chars (65 total);
    # adding "characters" would push it to 76.
    printf 'scope: Fix the bug\n\n%s\n' \
        'This is a very long body line that definitely exceeds seventy-two characters and needs wrapping.' \
        > "$tmp_msg"
    run "$formatter" "$tmp_msg"
    [ "$status" -eq 0 ]
    first_body_line=$(sed -n '3p' "$tmp_msg")
    [ "$first_body_line" = "This is a very long body line that definitely exceeds seventy-two" ]
}

@test "short body lines are reflowed into one" {
    # Two lines that together fit within 72 chars should be joined into one.
    printf 'scope: Fix the bug\n\n%s\n%s\n' \
        'This is the first part of the sentence' \
        'and this is the second part.' \
        > "$tmp_msg"
    run "$formatter" "$tmp_msg"
    [ "$status" -eq 0 ]
    first_body_line=$(sed -n '3p' "$tmp_msg")
    [ "$first_body_line" = "This is the first part of the sentence and this is the second part." ]
    [ -z "$(sed -n '4p' "$tmp_msg")" ]
}

@test "blank line between body paragraphs is preserved" {
    printf 'scope: Fix the bug\n\n%s\n\n%s\n' \
        'First paragraph.' \
        'Second paragraph.' \
        > "$tmp_msg"
    original=$(cat "$tmp_msg")
    run "$formatter" "$tmp_msg"
    [ "$status" -eq 0 ]
    [ "$(cat "$tmp_msg")" = "$original" ]
}

@test "already wrapped body is unchanged" {
    printf 'scope: Fix the bug\n\nShort body.\n' > "$tmp_msg"
    original=$(cat "$tmp_msg")
    run "$formatter" "$tmp_msg"
    [ "$status" -eq 0 ]
    [ "$(cat "$tmp_msg")" = "$original" ]
}

@test "trailing git comment block is preserved verbatim" {
    printf 'scope: Fix the bug\n\nBody text.\n# ------------------------ >8 ------------------------\n# Comment line.\n' \
        > "$tmp_msg"
    run "$formatter" "$tmp_msg"
    [ "$status" -eq 0 ]
    grep -q '^# Comment line\.$' "$tmp_msg"
    grep -q '^# ---' "$tmp_msg"
}

# }}}
