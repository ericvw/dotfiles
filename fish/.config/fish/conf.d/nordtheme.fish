set -l nord0 2e3440
set -l nord1 3b4252
set -l nord2 434c5e
set -l nord3 4c566a
set -l nord4 d8dee9
set -l nord5 e5e9f0
set -l nord6 eceff4
set -l nord7 8fbcbb
set -l nord8 88c0d0
set -l nord9 81a1c1
set -l nord10 5e81ac
set -l nord11 bf616a
set -l nord12 d08770
set -l nord13 ebcb8b
set -l nord14 a3be8c
set -l nord15 b48ead

set -g fish_color_normal normal
set -g fish_color_command $nord8
set -g fish_color_keyword $nord9
set -g fish_color_quote $nord14
set -g fish_color_redirection $nord15 --bold
set -g fish_color_end $nord9
set -g fish_color_error $nord11
set -g fish_color_param $nord4
set -g fish_color_valid_path --underline
set -g fish_color_option $nord7
set -g fish_color_comment $nord3 --italics
set -g fish_color_selection $nord4 --bold --background=$nord2
set -g fish_color_operator $nord9
set -g fish_color_escape $nord13
set -g fish_color_autosuggestion $nord3
set -g fish_color_cwd $nord10
set -g fish_color_cwd_root $nord11
set -g fish_color_user $nord14
set -g fish_color_host $nord14
set -g fish_color_host_remote $nord13
set -g fish_color_status $nord11
set -g fish_color_cancel --reverse
set -g fish_color_search_match --bold --background=$nord2
set -g fish_color_history_current $nord5 --bold

set -g fish_pager_color_progress $nord1 --background=$nord12
set -g fish_pager_color_completion $nord5
set -g fish_pager_color_prefix normal --bold --underline
set -g fish_pager_color_description $nord13 --italics
set -g fish_pager_color_selected_background --background=$nord2
