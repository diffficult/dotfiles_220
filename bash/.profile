# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

#
# Variables
#

export XDG_CONFIG_HOME="/home/poole/.config"

#export EDITOR=/usr/bin/nano
export QT_QPA_PLATFORMTHEME="qt5ct"
export QT_AUTO_SCREEN_SCALE_FACTOR=0
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"

export GTK_THEME=Arc-Dark

#if [[ -n "$BASH_VERSION" && -f "$HOME/.bashrc" ]]; then
#  source "$HOME/.bashrc"
#fi

#dirs=(
#  '/bin'
#  '/sbin'
#  '/usr/bin'
#  '/usr/sbin'
#  '/usr/local/bin'
#  '/usr/local/sbin'
#  '/usr/games'
#  '/usr/local/games'
#  "$HOME/.local/bin"
#)

#for d in "${dirs[@]}"; do
#  if [[ -d "$d" ]]; then
#    PATH="$d:$PATH"
#  fi
#done

# Set keyboard to US-INTL with accents and deadkey

setxkbmap -layout us -variant intl -option deadkeys

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"
