# ~/.bashrc
# The individual per-interactive-shell startup file.

# Source global definitions.
if [ -r /etc/bashrc ]; then
	. /etc/bashrc
fi

# Define user specific aliases and functions.
export XDG_DATA_DIRS=/var/lib/flatpak/exports/share:/home/mleontyev/.local/share/flatpak/exports/share:$XDG_DATA_DIRS
export PATH=/usr/local/texlive/2025/bin/x86_64-linux:/usr/share/dotnet:$PATH:$HOME/.local/bin
export MANPATH=/usr/local/texlive/2025/texmf-dist/doc/man:$MANPATH
export INFOPATH=/usr/local/texlive/2025/texmf-dist/doc/info:$INFOPATH

# Enable git prompt
. ~/.git-prompt.sh

update_prompt() {
    if [ "$VIRTUAL_ENV_PROMPT" == "" ]; then
        PS1="\[\033[01;32m\]\u\[\033[00m\]:\[\033[01;34m\]\w\[\033[01;33m\]$(__git_ps1 " (%s)")\[\033[00m\] $ "
    else
        PS1="($VIRTUAL_ENV_PROMPT) \[\033[01;32m\]\u\[\033[00m\]:\[\033[01;34m\]\w\[\033[01;33m\]$(__git_ps1 " (%s)")\[\033[00m\] $ "
    fi
}

PROMPT_COMMAND=update_prompt

. "$HOME/.cargo/env"

alias zed=zed-editor
alias ls=lsd
