#!/usr/bin/env bash
# shellcheck disable=SC2034  # variables are used by the sourcing script

# Kanagawa Wave color theme for statusline.sh
# 24-bit ANSI escape sequences override the terminal-color fallbacks.

C_DIR='\e[38;2;126;156;216m'         # #7e9cd8 crystalBlue       — directory
C_BRANCH='\e[38;2;149;127;184m'      # #957fb8 oniViolet         — git branch
C_GIT_ADDED='\e[38;2;118;148;106m'   # #76946a autumnGreen       — git staged/added
C_GIT_MODIFIED='\e[38;2;220;165;97m' # #dca561 autumnYellow      — git modified
C_GIT_DELETED='\e[38;2;195;64;67m'   # #c34043 autumnRed         — git deleted
C_SESSION='\e[38;2;127;180;202m'     # #7fb4ca springBlue        — session name
C_MODEL='\e[38;2;230;195;132m'       # #e6c384 carpYellow        — model
C_DEFAULT='\e[38;2;220;215;186m'     # #dcd7ba fujiWhite         — default foreground
C_DIM='\e[38;2;114;113;105m'         # #727169 fujiGray          — labels
C_UNTRACKED='\e[38;2;147;138;169m'   # #938aa9 springViolet1     — untracked files
C_VIM_N='\e[1;38;2;232;36;36m'       # #e82424 bold samuraiRed   — normal mode
C_VIM_I='\e[1;38;2;152;187;108m'     # #98bb6c bold springGreen  — insert mode
C_VIM_V='\e[1;38;2;149;127;184m'     # #957fb8 bold oniViolet    — visual mode
C_CTX_LOW='\e[38;2;106;149;137m'     # #6a9589 waveAqua1         — ctx low
C_CTX_MED='\e[38;2;255;158;59m'      # #ff9e3b roninYellow       — ctx medium
C_CTX_HIGH='\e[38;2;232;36;36m'      # #e82424 samuraiRed        — ctx high
