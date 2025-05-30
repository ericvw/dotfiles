set -l autumnRed C34043
set -l boatYellow2 C0A36E
set -l fujiGray 727169
set -l fujiWhite DCD7BA
set -l oldWhite C8C093
set -l oniViolet 957FB8
set -l saumuraiRed E82424
set -l springBlue 7FB4CA
set -l springGreen 98BB6C
set -l springViolet1 938AA9
set -l springViolet2 9CABCA
set -l sumilnk2 2A2A37
set -l waveAqua1 6A9589
set -l waveBlue1 223249
set -l waveBlue2 2D4F67

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
set -g fish_color_command $springBlue
set -g fish_color_keyword $oniViolet --bold
set -g fish_color_quote $springGreen
set -g fish_color_redirection $nord15 --bold
set -g fish_color_end $springViolet2
set -g fish_color_error $saumuraiRed
set -g fish_color_param $nord4
set -g fish_color_valid_path --underline
set -g fish_color_option $nord7
set -g fish_color_comment $fujiGray --italics
set -g fish_color_selection --background=$waveBlue1
set -g fish_color_operator $boatYellow2
set -g fish_color_escape $boatYellow2
set -g fish_color_autosuggestion $nord3
set -g fish_color_cwd $nord10
set -g fish_color_cwd_root $autumnRed
set -g fish_color_user $nord14
set -g fish_color_host $nord14
set -g fish_color_host_remote $nord13
set -g fish_color_status $nord11
set -g fish_color_cancel --reverse
set -g fish_color_search_match --bold --background=brblue
set -g fish_color_history_current --italics

set -g fish_pager_color_progress $waveAqua1 --background=$sumilnk2
set -g fish_pager_color_completion normal
set -g fish_pager_color_prefix $springViolet1 --bold --underline
set -g fish_pager_color_description $oldWhite --italics
set -g fish_pager_color_selected_background --background=$waveBlue2
