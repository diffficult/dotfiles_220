#!/bin/sh
#

if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for f in /etc/X11/xinit/xinitrc.d/*; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

setxkbmap -layout us -variant intl -option deadkeys

export GTK2_RC_FILES="$HOME/.gtkrc-2.0"

exec dbus-launch --exit-with-session openbox-session

systemctl --user start xfce4-notifyd.service
