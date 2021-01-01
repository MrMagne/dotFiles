# Check for an interactive session
[ -z "$PS1" ] && return

. /etc/profile

#Screws up bash forward-i-search with Ctrl-S
stty -ixon
#if [ -n "$DESKTOP_SESSION" ]; then
#  eval $(gnome-keyring-daemon --start)
#  export SSH_AUTH_SOCK
#fi

export LANG=en_US.UTF8
export PATH=~/bin:~/.cargo/bin:$PATH
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
alias ofoam="export PS1=\"\[\e[1;34m\]OpenFoam\[\e[0;37m\]\${PS1}\" && source /opt/OpenFOAM/OpenFOAM-4.x/etc/bashrc"
alias mj='make -j7'

#PS1='[\u@\h \w]($?)\$ '

PROMPT_COMMAND="export RET='$?'; ${PROMPT_COMMAND}"
RET_VALUE='$(if [[ $RET = 0 ]]; then echo "\[\e[1;32m\]"; else echo "\[\e[1;31m\]"; fi)'
PS1="${RET_VALUE}[\[\e[0;37m\]\u@\h \w ${RET_VALUE}]\\\$\[\e[0;37m\] "
