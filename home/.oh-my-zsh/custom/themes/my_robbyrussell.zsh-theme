truncate_path() {
  local percent=${1:-40}
  local width=${COLUMNS:-80}
  local max_len=$(( width * percent / 100 ))
  local full_path="${PWD/#$HOME/~}"

  if (( ${#full_path} <= max_len )); then
    print -n "$full_path"
    return
  fi

  local -a parts
  parts=(${(s:/:)full_path})

  local result=""
  local i
  for (( i = ${#parts}; i >= 1; i-- )); do
    local candidate="${parts[i]}/${result}"
    if (( ${#candidate} + 3 > max_len )); then
      break
    fi
    result="$candidate"
  done

  result="${result%/}"

  if [[ -z "$result" ]]; then
    print -n "…/${parts[-1]}"
  else
    print -n "…/${result}"
  fi
}

PROMPT="%(?:%{$fg_bold[green]%}>:%{$fg_bold[red]%}>) %{$fg[cyan]%}\$(truncate_path)%{$reset_color%} \$(git_prompt_info)$ "

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[yellow]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY=")"
ZSH_THEME_GIT_PROMPT_CLEAN=")"
