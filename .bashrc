
# Check for an interactive session
[ -z "$PS1" ] && return

export EDITOR=vim
complete -cf sudo
#alias sudo='sudo -E'

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '
