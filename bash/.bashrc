#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

#---pkg not found suggestion
source /usr/share/doc/pkgfile/command-not-found.bash

#---Auto CD 
shopt -s autocd


BROWSER=/usr/bin/google-chrome
EDITOR=/usr/bin/nano

#climate completion
source /etc/bash_completion.d/climate_completion

source /home/poole/.config/broot/launcher/bash/br

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"
