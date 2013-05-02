# Check for an interactive session
[ -z "$PS1" ] && return

. /etc/profile

#Screws up bash forward-i-search with Ctrl-S
stty -ixon

export PATH=~/bin:/usr/lib/colorgcc/bin:$PATH
export HISTCONTROL=ignoreboth
# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
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

#PS1='[\u@\h \w]($?)\$ '

PROMPT_COMMAND="export RET='$?'; ${PROMPT_COMMAND}"
RET_VALUE='$(if [[ $RET = 0 ]]; then echo "\[\e[1;32m\]"; else echo "\[\e[1;31m\]"; fi)'
PS1="${RET_VALUE}[\[\e[0;37m\]\u@\h \w ${RET_VALUE}]\\\$\[\e[0;37m\] "
