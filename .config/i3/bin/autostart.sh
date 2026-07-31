#!/usr/bin/env bash
# i3 session autostart — daemons, tray apps, input, monitors

export PATH="$HOME/.local/bin:/usr/local/bin:/usr/bin:$PATH"
I3BIN="$HOME/.config/i3/bin"

# Cursor
xsetroot -cursor_name left_ptr

# Xresources
[[ -f "$HOME/.Xresources" ]] && xrdb -load "$HOME/.Xresources"

# Keyboard: US international (dead keys in variant); Ctrl+Alt+Bksp kills X
setxkbmap -layout us -variant intl -option terminate:ctrl_alt_bksp

# Touchpad: libinput via /etc/X11/xorg.conf.d/30-touchpad.conf (natural scroll, tap)

# Notifications + compositor + power
"$I3BIN/i3dunst.sh"
"$I3BIN/i3picom.sh"
xfce4-power-manager &

# Low-battery warn / critical / suspend guard
"$I3BIN/battery-guard.sh" &

# PolicyKit (pamac and elevated apps)
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

# Session bus env for keyring / portals
dbus-update-activation-environment --all
/usr/bin/gnome-keyring-daemon --start --components=secrets,pkcs11,ssh,gpg

# Wallpaper
feh --bg-fill "$(find /usr/share/backgrounds/ -type f 2>/dev/null | sort -R | tail -1)" &

# Tray / applets
nm-applet --sm-disable &
blueman-applet &
rfkill block bluetooth
redshift-gtk &
megasync &

# i3blocks signal helpers
"$I3BIN/bluetooth-dbus-monitor.sh" &
"$I3BIN/window-title-monitor.sh" &
(sleep 5 && pkill -RTMIN+12 i3blocks) &
(sleep 3 && pkill -RTMIN+11 i3blocks) &

# Idle lock (before sleep / on screensaver)
if command -v xss-lock >/dev/null 2>&1; then
	xss-lock --transfer-sleep-lock -- "$I3BIN/lock.sh" -p -f "Iosevka Nerd Font Mono" &
fi

# Touchpad gestures (user must be in `input` group — re-login after usermod)
if command -v systemctl >/dev/null 2>&1 \
	&& systemctl --user cat libinput-gestures.service >/dev/null 2>&1; then
	systemctl --user start libinput-gestures.service 2>/dev/null || true
elif command -v libinput-gestures >/dev/null 2>&1; then
	libinput-gestures &
fi
