PROMPT="%(?:%{$fg_bold[green]%}> :%{$fg_bold[red]%}> )%{$fg[cyan]%}%~%{$reset_color%}"
PROMPT+=' $(git_prompt_info)'
PROMPT+="$ "

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[yellow]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY=")"
ZSH_THEME_GIT_PROMPT_CLEAN=")"
