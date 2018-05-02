#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

#BROWSER=/usr/bin/chromium
#EDITOR=/usr/bin/nano

#---pkg not found suggestion
source /usr/share/doc/pkgfile/command-not-found.bash

#---Auto CD
shopt -s autocd


