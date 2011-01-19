
# Check for an interactive session
[ -z "$PS1" ] && return

export PATH=~/bin:$PATH
export HISTCONTROL=ignoreboth
# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
export HISTSIZE=10000

export EDITOR=vim
complete -cf sudo

alias ls='ls --color=auto'
alias diff='colordiff'
#alias make='colormake'
alias grep='grep --color=auto'

PS1='[\u@\h \W]\$ '
