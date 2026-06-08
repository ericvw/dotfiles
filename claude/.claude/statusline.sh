#!/usr/bin/env bash
# vim: foldmethod=marker

# Colors {{{
# Terminal 16-color fallbacks (inherits terminal palette).
C_VIM_N='\e[1;31m'      # bold red      — normal mode
C_VIM_I='\e[1;32m'      # bold green    — insert mode
C_VIM_V='\e[1;35m'      # bold magenta  — visual mode
C_DIM='\e[90m'          # bright black  — labels
C_DIR='\e[34m'          # blue          — directory
C_BRANCH='\e[35m'       # magenta       — git branch
C_GIT_ADDED='\e[32m'    # green         — git staged/added
C_GIT_MODIFIED='\e[33m' # yellow        — git modified
C_GIT_DELETED='\e[31m'  # red           — git deleted
C_UNTRACKED='\e[35m'    # magenta       — untracked files
C_MODEL='\e[33m'        # yellow        — model
C_CTX_LOW='\e[36m'      # cyan          — ctx < 60%
C_CTX_MED='\e[33m'      # yellow        — ctx >= 60%
C_CTX_HIGH='\e[31m'     # red           — ctx >= 80%
C_DEFAULT='\e[37m'      # white         — default foreground
C_RESET='\e[0m'

# Override with 24-bit theme if available.
# shellcheck source=/dev/null
if [[ -f "${BASH_SOURCE[0]%/*}/statusline-theme.sh" ]]; then
    source "${BASH_SOURCE[0]%/*}/statusline-theme.sh"
fi
# }}}

# Emojis {{{
# Set STATUSLINE_EMOJIS=0 to disable.
I_DIR='📁 '
I_WORKTREE='🌲 '
I_BRANCH='🌿 '
I_MODEL='🤖 '
I_CTX='🧠 '
I_COMPACT='♻️'
I_WARN='⚠️'
I_COST='💰'
I_DURATION='⏱️ '
if [[ "${STATUSLINE_EMOJIS:-1}" == "0" ]]; then
    I_DIR=''
    I_WORKTREE='wt: '
    I_BRANCH='br: '
    I_MODEL=''
    I_CTX='ctx '
    I_COMPACT='cmp'
    I_WARN='!'
    I_COST=''
    I_DURATION='dur '
fi
# }}}

# Input {{{
# Extract all values in a single jq call.
mapfile -t _j < <(jq -r '
  .vim.mode                       // "",
  .workspace.current_dir,
  (.workspace.git_worktree // .worktree.name // ""),
  .model.display_name             // "",
  .context_window.used_percentage // "",
  (.exceeds_200k_tokens // false),
  .cost.total_cost_usd            // "",
  .cost.total_lines_added         // "",
  .cost.total_lines_removed       // "",
  (.cost.total_duration_ms        // 0)
')
vim_mode=${_j[0]}
cwd=${_j[1]}
git_worktree=${_j[2]}
model=${_j[3]}
ctx_pct=${_j[4]}
exceeds_200k=${_j[5]}
cost=${_j[6]}
lines_added=${_j[7]}
lines_removed=${_j[8]}
duration_ms=${_j[9]}
# }}}

# Helpers {{{
# Append to a line variable with a two-space separator.
append() {
    local -n _line=$1
    [[ -n "$_line" ]] && _line+="  "
    _line+="$2"
}

# Compact path like fish: abbreviate all components except the last.
# Hidden dirs keep dot + first char (.dotfiles → .d); others get one char.
compact_path() {
    local path="${1/#$HOME/\~}"
    local -a parts
    IFS='/' read -ra parts <<< "$path"
    local result='' i part
    local last_idx=$((${#parts[@]} - 1))
    for ((i = 0; i <= last_idx; i++)); do
        part="${parts[$i]}"
        if [[ $i -eq $last_idx ]]; then
            result+="$part"
        elif [[ -z "$part" ]]; then
            result+='/'
        elif [[ "$part" == '~' ]]; then
            # shellcheck disable=SC2088
            result+='~/'
        elif [[ "${part:0:1}" == '.' ]]; then
            result+=".${part:1:1}/"
        else
            result+="${part:0:1}/"
        fi
    done
    printf '%s' "$result"
}
# }}}

# Line 1: Workspace {{{
line1=""

# Vim mode (only when vim mode is active).
if [[ -n "$vim_mode" ]]; then
    case "$vim_mode" in
        NORMAL) line1+="${C_VIM_N}[N]${C_RESET}  " ;;
        INSERT) line1+="${C_VIM_I}[I]${C_RESET}  " ;;
        VISUAL) line1+="${C_VIM_V}[V]${C_RESET}  " ;;
        *) line1+="${C_DIM}[${vim_mode:0:1}]${C_RESET}  " ;;
    esac
fi

# Current working directory (fish-style compaction).
display_cwd=$(compact_path "$cwd")
line1+="${I_DIR}${C_DIR}${display_cwd}${C_RESET}"

# Git (only inside a git repo).
git_dir=$(git -C "$cwd" rev-parse --git-dir 2> /dev/null)
if [[ -n "$git_dir" ]]; then
    # Worktree name: prefer JSON fields, fall back to git detection.
    if [[ -z "$git_worktree" ]]; then
        common_dir=$(git -C "$cwd" rev-parse --git-common-dir 2> /dev/null)
        if [[ "$git_dir" != "$common_dir" ]]; then
            git_worktree=$(basename "$(git -C "$cwd" rev-parse --show-toplevel)")
        fi
    fi
    [[ -n "$git_worktree" ]] && append line1 "${I_WORKTREE}${C_BRANCH}${git_worktree}${C_RESET}"

    branch=$(git -C "$cwd" symbolic-ref --short HEAD 2> /dev/null)
    if [[ -z "$branch" ]]; then
        sha=$(git -C "$cwd" rev-parse --short HEAD 2> /dev/null)
        [[ -n "$sha" ]] && branch="($sha)"
    fi
    [[ -n "$branch" ]] && append line1 "${I_BRANCH}${C_BRANCH}${branch}${C_RESET}"

    # Ahead/behind upstream.
    read -r behind ahead < <(git -C "$cwd" rev-list --left-right --count '@{u}...HEAD' 2> /dev/null || true)
    [[ "${ahead:-0}" -gt 0 ]] && line1+=" ${C_GIT_ADDED}⇡${ahead}${C_RESET}"
    [[ "${behind:-0}" -gt 0 ]] && line1+=" ${C_GIT_DELETED}⇣${behind}${C_RESET}"

    # File status counts.
    staged=0
    unstaged=0
    deleted=0
    untracked=0
    while IFS= read -r status_line; do
        xy=${status_line:0:2}
        index=${xy:0:1}
        wt=${xy:1:1}
        [[ "$index" =~ [MARC] ]] && ((staged++))
        [[ "$wt" == "M" ]] && ((unstaged++))
        [[ "$index" == "D" || "$wt" == "D" ]] && ((deleted++))
        [[ "$xy" == "??" ]] && ((untracked++))
    done < <(git -C "$cwd" status --porcelain 2> /dev/null)

    status_str=""
    [[ $staged -gt 0 ]] && status_str+="${C_GIT_ADDED}+${staged}${C_RESET}"
    [[ $unstaged -gt 0 ]] && {
        [[ -n "$status_str" ]] && status_str+=" "
        status_str+="${C_GIT_MODIFIED}~${unstaged}${C_RESET}"
    }
    [[ $untracked -gt 0 ]] && {
        [[ -n "$status_str" ]] && status_str+=" "
        status_str+="${C_UNTRACKED}?${untracked}${C_RESET}"
    }
    [[ $deleted -gt 0 ]] && {
        [[ -n "$status_str" ]] && status_str+=" "
        status_str+="${C_GIT_DELETED}-${deleted}${C_RESET}"
    }
    [[ -n "$status_str" ]] && append line1 "$status_str"

    # Line counts from working tree vs HEAD.
    read -r lines_ins lines_del < <(
        git -C "$cwd" diff HEAD --shortstat 2> /dev/null |
            awk '{for(i=1;i<=NF;i++){if($i~/^insertion/)ins=$(i-1);if($i~/^deletion/)del=$(i-1)}}END{print ins+0,del+0}'
    )
    lines_str=""
    [[ "$lines_ins" -gt 0 ]] && lines_str+="${C_GIT_ADDED}↑${lines_ins}${C_RESET}"
    [[ "$lines_del" -gt 0 ]] && {
        [[ -n "$lines_str" ]] && lines_str+=" "
        lines_str+="${C_GIT_DELETED}↓${lines_del}${C_RESET}"
    }
    [[ -n "$lines_str" ]] && append line1 "$lines_str"
fi
# }}}

# Line 2: Session {{{
line2=""

if [[ -n "$model" ]]; then
    line2+="${I_MODEL}${C_MODEL}${model}${C_RESET}"
fi

# Context window (thresholds account for the ~33k autocompact buffer).
if [[ -n "$ctx_pct" ]]; then
    ctx_pct_int=$(printf '%.0f' "$ctx_pct")
    if [[ $ctx_pct_int -ge 80 ]]; then
        ctx_color="$C_CTX_HIGH"
    elif [[ $ctx_pct_int -ge 60 ]]; then
        ctx_color="$C_CTX_MED"
    else
        ctx_color="$C_CTX_LOW"
    fi
    append line2 "${I_CTX}${ctx_color}${ctx_pct_int}%${C_RESET}"
fi

# Context health alerts (trailing flags).
[[ "$exceeds_200k" == "true" ]] && line2+=" ${C_CTX_MED}${I_COMPACT}${C_RESET}"
[[ ${ctx_pct_int:-0} -ge 80 ]] && line2+=" ${C_CTX_HIGH}${I_WARN}${C_RESET}"

# Cost and cumulative lines changed.
if [[ -n "$cost" || -n "$lines_added" || -n "$lines_removed" ]]; then
    cost_str="${I_COST}"
    if [[ -n "$cost" ]]; then
        printf -v _cost_fmt '$%.2f' "$cost"
        cost_str+="${cost_str:+ }${C_DEFAULT}${_cost_fmt}${C_RESET}"
    fi
    [[ -n "$lines_added" && "$lines_added" != "0" ]] && cost_str+=" ${C_GIT_ADDED}+${lines_added}${C_RESET}"
    [[ -n "$lines_removed" && "$lines_removed" != "0" ]] && cost_str+=" ${C_GIT_DELETED}-${lines_removed}${C_RESET}"
    append line2 "$cost_str"
fi

# Duration (wall-clock).
if [[ "$duration_ms" -gt 0 ]]; then
    duration_sec=$((duration_ms / 1000))
    if [[ $duration_sec -ge 3600 ]]; then
        h=$((duration_sec / 3600))
        m=$(((duration_sec % 3600) / 60))
        duration_fmt="${h}h${m}m"
    elif [[ $duration_sec -ge 60 ]]; then
        duration_fmt="$((duration_sec / 60))m"
    else
        duration_fmt="${duration_sec}s"
    fi
    append line2 "${I_DURATION}${C_DEFAULT}${duration_fmt}${C_RESET}"
fi
# }}}

printf '%b\n' "${C_DEFAULT}${line1}${C_RESET}"
printf '%b' "${C_DEFAULT}${line2}${C_RESET}"
