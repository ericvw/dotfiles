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

# Subject: auto-squash bypass {{{

@test "fixup commit exits 0 and message is unchanged" {
    printf 'fixup! Original subject\n' > "$tmp_msg"
    original=$(cat "$tmp_msg")
    run "$formatter" "$tmp_msg"
    [ "$status" -eq 0 ]
    [ "$(cat "$tmp_msg")" = "$original" ]
}

@test "squash commit exits 0 and message is unchanged" {
    printf 'squash! Original subject\n' > "$tmp_msg"
    original=$(cat "$tmp_msg")
    run "$formatter" "$tmp_msg"
    [ "$status" -eq 0 ]
    [ "$(cat "$tmp_msg")" = "$original" ]
}

@test "amend commit exits 0 and message is unchanged" {
    printf 'amend! Original subject\n' > "$tmp_msg"
    original=$(cat "$tmp_msg")
    run "$formatter" "$tmp_msg"
    [ "$status" -eq 0 ]
    [ "$(cat "$tmp_msg")" = "$original" ]
}

@test "fixup commit with body exits 0 and message is unchanged" {
    printf 'fixup! Original subject\n\nBody text.\n' > "$tmp_msg"
    original=$(cat "$tmp_msg")
    run "$formatter" "$tmp_msg"
    [ "$status" -eq 0 ]
    [ "$(cat "$tmp_msg")" = "$original" ]
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

@test "git comments directly after subject pass and blank separator is inserted" {
    printf 'scope: Fix the bug\n# Git comment.\n# Another comment.\n' > "$tmp_msg"
    run "$formatter" "$tmp_msg"
    [ "$status" -eq 0 ]
    [ "$(sed -n '1p' "$tmp_msg")" = "scope: Fix the bug" ]
    [ -z "$(sed -n '2p' "$tmp_msg")" ]
    [ "$(sed -n '3p' "$tmp_msg")" = "# Git comment." ]
}

# }}}

# Body: pass-through {{{

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

@test "already wrapped body is unchanged" {
    printf 'scope: Fix the bug\n\nShort body.\n' > "$tmp_msg"
    original=$(cat "$tmp_msg")
    run "$formatter" "$tmp_msg"
    [ "$status" -eq 0 ]
    [ "$(cat "$tmp_msg")" = "$original" ]
}

# }}}

# Body: paragraph wrapping {{{

@test "body is wrapped" {
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

@test "body paragraph uses greedy wrapping" {
    # fmt optimal-fit breaks after "invariants," leaving "and" on the next
    # line (67+67 chars). Greedy wrapping fits "and" on line 1 (71+71 chars).
    printf 'scope: Fix the bug\n\n%s\n' \
        'Introduce AGENTS.md to define project-specific context, invariants, and directory structure. This assists AI coding agents by directing them to the primary network specification document for VLAN/IPAM and STP configurations.' \
        > "$tmp_msg"
    run "$formatter" "$tmp_msg"
    [ "$status" -eq 0 ]
    [ "$(sed -n '3p' "$tmp_msg")" = "Introduce AGENTS.md to define project-specific context, invariants, and" ]
    [ "$(sed -n '4p' "$tmp_msg")" = "directory structure. This assists AI coding agents by directing them to" ]
    [ "$(sed -n '5p' "$tmp_msg")" = "the primary network specification document for VLAN/IPAM and STP" ]
    [ "$(sed -n '6p' "$tmp_msg")" = "configurations." ]
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

# }}}

# Body: list items {{{

@test "list items are not joined into a single paragraph" {
    printf 'scope: Fix the bug\n\n%s\n%s\n' \
        '- First item' \
        '- Second item' \
        > "$tmp_msg"
    run "$formatter" "$tmp_msg"
    [ "$status" -eq 0 ]
    [ "$(sed -n '3p' "$tmp_msg")" = "- First item" ]
    [ "$(sed -n '4p' "$tmp_msg")" = "- Second item" ]
}

@test "asterisk list marker is recognized and items are not joined" {
    printf 'scope: Fix the bug\n\n%s\n%s\n' \
        '* First item' \
        '* Second item' \
        > "$tmp_msg"
    run "$formatter" "$tmp_msg"
    [ "$status" -eq 0 ]
    [ "$(sed -n '3p' "$tmp_msg")" = "* First item" ]
    [ "$(sed -n '4p' "$tmp_msg")" = "* Second item" ]
}

@test "plus list marker is recognized and items are not joined" {
    printf 'scope: Fix the bug\n\n%s\n%s\n' \
        '+ First item' \
        '+ Second item' \
        > "$tmp_msg"
    run "$formatter" "$tmp_msg"
    [ "$status" -eq 0 ]
    [ "$(sed -n '3p' "$tmp_msg")" = "+ First item" ]
    [ "$(sed -n '4p' "$tmp_msg")" = "+ Second item" ]
}

@test "short list items are unchanged" {
    printf 'scope: Fix the bug\n\n%s\n' \
        '- Short item' \
        > "$tmp_msg"
    original=$(cat "$tmp_msg")
    run "$formatter" "$tmp_msg"
    [ "$status" -eq 0 ]
    [ "$(cat "$tmp_msg")" = "$original" ]
}

@test "long list item wraps with hanging indent" {
    # "seventy-two" is the last word fitting in 70 chars (text width for "- ")
    printf 'scope: Fix the bug\n\n%s\n' \
        '- This is a very long list item that definitely exceeds seventy-two characters and needs wrapping.' \
        > "$tmp_msg"
    run "$formatter" "$tmp_msg"
    [ "$status" -eq 0 ]
    [ "$(sed -n '3p' "$tmp_msg")" = "- This is a very long list item that definitely exceeds seventy-two" ]
    [ "$(sed -n '4p' "$tmp_msg")" = "  characters and needs wrapping." ]
}

@test "long asterisk list item wraps with hanging indent" {
    printf 'scope: Fix the bug\n\n%s\n' \
        '* This is a very long list item that definitely exceeds seventy-two characters and needs wrapping.' \
        > "$tmp_msg"
    run "$formatter" "$tmp_msg"
    [ "$status" -eq 0 ]
    [ "$(sed -n '3p' "$tmp_msg")" = "* This is a very long list item that definitely exceeds seventy-two" ]
    [ "$(sed -n '4p' "$tmp_msg")" = "  characters and needs wrapping." ]
}

@test "long plus list item wraps with hanging indent" {
    printf 'scope: Fix the bug\n\n%s\n' \
        '+ This is a very long list item that definitely exceeds seventy-two characters and needs wrapping.' \
        > "$tmp_msg"
    run "$formatter" "$tmp_msg"
    [ "$status" -eq 0 ]
    [ "$(sed -n '3p' "$tmp_msg")" = "+ This is a very long list item that definitely exceeds seventy-two" ]
    [ "$(sed -n '4p' "$tmp_msg")" = "  characters and needs wrapping." ]
}

@test "numbered list item wraps with correct indent" {
    # "seventy-two" is the last word fitting in 69 chars (text width for "1. ")
    printf 'scope: Fix the bug\n\n%s\n' \
        '1. This is a very long list item that definitely exceeds seventy-two characters and needs wrapping.' \
        > "$tmp_msg"
    run "$formatter" "$tmp_msg"
    [ "$status" -eq 0 ]
    [ "$(sed -n '3p' "$tmp_msg")" = "1. This is a very long list item that definitely exceeds seventy-two" ]
    [ "$(sed -n '4p' "$tmp_msg")" = "   characters and needs wrapping." ]
}

@test "multi-digit numbered list item wraps with correct indent" {
    printf 'scope: Fix the bug\n\n%s\n' \
        '10. This is a very long list item that definitely exceeds seventy-two characters and needs wrapping.' \
        > "$tmp_msg"
    run "$formatter" "$tmp_msg"
    [ "$status" -eq 0 ]
    [ "$(sed -n '3p' "$tmp_msg")" = "10. This is a very long list item that definitely exceeds seventy-two" ]
    [ "$(sed -n '4p' "$tmp_msg")" = "    characters and needs wrapping." ]
}

@test "list item with continuation lines is re-wrapped" {
    printf 'scope: Fix the bug\n\n%s\n%s\n' \
        '- This is a very long list item that definitely exceeds seventy-two' \
        '  characters and needs wrapping.' \
        > "$tmp_msg"
    run "$formatter" "$tmp_msg"
    [ "$status" -eq 0 ]
    [ "$(sed -n '3p' "$tmp_msg")" = "- This is a very long list item that definitely exceeds seventy-two" ]
    [ "$(sed -n '4p' "$tmp_msg")" = "  characters and needs wrapping." ]
}

@test "list item continuation that fits is reflowed onto one line" {
    printf 'scope: Fix the bug\n\n%s\n%s\n' \
        '- Short item' \
        '  continuation' \
        > "$tmp_msg"
    run "$formatter" "$tmp_msg"
    [ "$status" -eq 0 ]
    [ "$(sed -n '3p' "$tmp_msg")" = "- Short item continuation" ]
    [ "$(wc -l < "$tmp_msg")" -eq 3 ]
}

@test "blank line between list items is preserved" {
    printf 'scope: Fix the bug\n\n%s\n\n%s\n' \
        '- First item' \
        '- Second item' \
        > "$tmp_msg"
    run "$formatter" "$tmp_msg"
    [ "$status" -eq 0 ]
    [ "$(sed -n '3p' "$tmp_msg")" = "- First item" ]
    [ -z "$(sed -n '4p' "$tmp_msg")" ]
    [ "$(sed -n '5p' "$tmp_msg")" = "- Second item" ]
}

@test "list item followed by paragraph without blank line" {
    printf 'scope: Fix the bug\n\n%s\n%s\n' \
        '- List item' \
        'Paragraph text.' \
        > "$tmp_msg"
    run "$formatter" "$tmp_msg"
    [ "$status" -eq 0 ]
    [ "$(sed -n '3p' "$tmp_msg")" = "- List item" ]
    [ "$(sed -n '4p' "$tmp_msg")" = "Paragraph text." ]
}

# }}}

# Body: mixed content {{{

@test "mixed paragraph and list are formatted independently" {
    printf 'scope: Fix the bug\n\n%s\n\n%s\n%s\n' \
        'This paragraph introduces the changes made below.' \
        '- First item' \
        '- Second item' \
        > "$tmp_msg"
    run "$formatter" "$tmp_msg"
    [ "$status" -eq 0 ]
    [ "$(sed -n '3p' "$tmp_msg")" = "This paragraph introduces the changes made below." ]
    [ -z "$(sed -n '4p' "$tmp_msg")" ]
    [ "$(sed -n '5p' "$tmp_msg")" = "- First item" ]
    [ "$(sed -n '6p' "$tmp_msg")" = "- Second item" ]
}

# }}}

# Body: git comments {{{

@test "trailing git comment block is preserved verbatim" {
    printf 'scope: Fix the bug\n\nBody text.\n# ------------------------ >8 ------------------------\n# Comment line.\n' \
        > "$tmp_msg"
    run "$formatter" "$tmp_msg"
    [ "$status" -eq 0 ]
    grep -q '^# Comment line\.$' "$tmp_msg"
    grep -q '^# ---' "$tmp_msg"
}

# }}}
