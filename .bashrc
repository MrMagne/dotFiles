# Check for an interactive session
[ -z "$PS1" ] && return

. /etc/profile
[ -f ~/.privaterc ] && . ~/.privaterc

#Screws up bash forward-i-search with Ctrl-S
stty -ixon
#if [ -n "$DESKTOP_SESSION" ]; then
#  eval $(gnome-keyring-daemon --start)
#  export SSH_AUTH_SOCK
#fi

source ~/dev/git-subrepo/.rc

export LANG=en_US.UTF8
export HISTCONTROL=ignoreboth
# append to the history file, don't overwrite it
shopt -s histappend

# colors for less
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'
export LESS_TERMCAP_ue=$'\E[0m'

export LS_COLORS="${LS_COLORS}:ow=34;40:"

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
unset HISTFILESIZE
export HISTSIZE=10000

# enables ** wildcard for recursive globbing
shopt -s globstar

export EDITOR=vim
complete -cf sudo

#alias j=autojump
alias ls='ls --color=auto'
alias diff='colordiff'
#alias make='colormake'
alias grep='grep --color=auto'
alias r='fc -s'
alias h='fc -l'
alias cmn='cmake .. -DCMAKE_EXPORT_COMPILE_COMMANDS=1  -DCMAKE_CXX_FLAGS="$(cat ~/.clang-commandline)" -G Ninja -DCMAKE_CXX_COMPILER=/usr/bin/clang++'
alias of301='source /etc/openfoam-3.0.1.sh'
alias ofoam="unset LESS_TERMCAP_mb LESS_TERMCAP_md LESS_TERMCAP_me LESS_TERMCAP_so LESS_TERMCAP_se LESS_TERMCAP_us LESS_TERMCAP_ue && export PS1=\"\[\e[1;34m\]OpenFoam\[\e[0;37m\]\${PS1}\" && source /opt/OpenFOAM/OpenFOAM-6/etc/bashrc"
alias ofoam4="unset LESS_TERMCAP_mb LESS_TERMCAP_md LESS_TERMCAP_me LESS_TERMCAP_so LESS_TERMCAP_se LESS_TERMCAP_us LESS_TERMCAP_ue && export PS1=\"\[\e[1;34m\]OpenFoam\[\e[0;37m\]\${PS1}\" && source /opt/OpenFOAM/OpenFOAM-4.x/etc/bashrc"
alias ofoamWine="unset LESS_TERMCAP_mb LESS_TERMCAP_md LESS_TERMCAP_me LESS_TERMCAP_so LESS_TERMCAP_se LESS_TERMCAP_us LESS_TERMCAP_ue && export PS1=\"\[\e[1;34m\]OpenFoamWine\[\e[0;37m\]\${PS1}\" && export WM_PROJECT_DIR=$(readlink -f ~/projects/ICE/GUI/thirdParties/OpenFOAM-4.x) PATH=$(readlink -f ~/projects/ICE/GUI/thirdParties/OpenFOAM-4.x):$PATH FOAM_ETC=1"
alias mj='make -j7'

#PS1='[\u@\h \w]($?)\$ '

call_nvm_use_if_needed() {
  NEW_NVMRC="$(nvm_find_nvmrc)"
  if [[ "$NEW_NVMRC" != "$CURRENT_NVMRC" ]]; then
    if [[ -z "$NEW_NVMRC" ]]; then
      nvm use default
    else
      nvm use
    fi
    CURRENT_NVMRC="$NEW_NVMRC"
  fi
}

PROMPT_COMMAND=__prompt_command    # Function to generate PS1 after CMDs

__prompt_command() {
    local Exit="$?"                # This needs to be first
    PS1=""
    call_nvm_use_if_needed

    if [ $Exit != 0 ]; then
      PS1+="\[\e[0;31m\]"
    else
      PS1+="\[\e[0;32m\]"
    fi
    PS1+="[\[\e[0;37m\]\u@\h \w "
    if [ $Exit != 0 ]; then
      PS1+="\[\e[0;31m\]"
    else
      PS1+="\[\e[0;32m\]"
    fi
    PS1+="]\\\$\[\e[0;37m\] "
}
source /usr/share/nvm/init-nvm.sh
source ${NVM_BIN}/../lib/node_modules/npm/lib/utils/completion.sh

# tabtab source for packages
# uninstall by removing these lines
[ -f ~/.config/tabtab/bash/__tabtab.bash ] && . ~/.config/tabtab/bash/__tabtab.bash || true
