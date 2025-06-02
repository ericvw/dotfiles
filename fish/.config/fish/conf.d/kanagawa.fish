set -l autumnGreen 76946a
set -l autumnRed c34043
set -l boatYellow2 c0a36e
set -l carpYellow e6c384
set -l crystalBlue 7e9cd8
set -l fujiGray 727169
set -l fujiWhite dcd7ba
set -l oldWhite c8c093
set -l oniViolet 957fb8
set -l oniViolet2 b8b4d0
set -l roninYellow ff9e3b
set -l saumuraiRed e82424
set -l springBlue 7fb4ca
set -l springGreen 98bb6c
set -l springViolet1 938aa9
set -l springViolet2 9cabca
set -l sumilnk2 2a2a37
set -l sumilnk4 54546d
set -l waveAqua1 6a9589
set -l waveBlue1 223249
set -l waveBlue2 2d4f67

set -l foreground fujiWhite normal

set -g fish_color_normal $foreground
set -g fish_color_command $springBlue
set -g fish_color_keyword $oniViolet --italics
set -g fish_color_quote $springGreen
set -g fish_color_redirection $roninYellow --bold
set -g fish_color_end $springViolet2
set -g fish_color_error $saumuraiRed
set -g fish_color_param $foreground
set -g fish_color_valid_path --underline
set -g fish_color_option $oniViolet2
set -g fish_color_comment $fujiGray --italics
set -g fish_color_selection --bold --background=$waveBlue1
set -g fish_color_operator $boatYellow2
set -g fish_color_escape $boatYellow2 --bold
set -g fish_color_autosuggestion $sumilnk4
set -g fish_color_cwd $crystalBlue
set -g fish_color_cwd_root $autumnRed
set -g fish_color_user $autumnGreen
set -g fish_color_host $autumnGreen
set -g fish_color_host_remote $carpYellow
set -g fish_color_status $saumuraiRed
set -g fish_color_cancel --reverse
set -g fish_color_search_match $foreground --bold --background=$waveBlue2
set -g fish_color_history_current --italics

set -g fish_pager_color_progress $waveAqua1 --background=$sumilnk2
set -g fish_pager_color_completion $foreground
set -g fish_pager_color_prefix $springViolet1 --bold --underline
set -g fish_pager_color_description $oldWhite --italics
set -g fish_pager_color_selected_background --background=$waveBlue2
