#!/usr/bin/env bash
# Rofi power menu for i3 (Arc theme)

LOCK="${HOME}/.config/i3/bin/lock.sh"
LOCK_FONT="${LOCK_FONT:-Iosevka Nerd Font Mono}"
LOGOUT="${HOME}/.config/i3/bin/logout.sh"
THEME="${HOME}/.config/i3/rofi/themes/powermenu.rasi"

options="  Lock
󰒲  Suspend
󰋊  Hibernate
󰍃  Logout
󰜉  Reboot
  Poweroff"

chosen=$(printf '%s\n' "$options" | rofi -dmenu -i -p "Power" -theme "$THEME")

case "$chosen" in
	*Lock*)      exec "$LOCK" -p -f "$LOCK_FONT" ;;
	*Suspend*)   systemctl suspend ;;
	*Hibernate*) systemctl hibernate ;;
	*Logout*)    exec "$LOGOUT" ;;
	*Reboot*)    systemctl reboot ;;
	*Poweroff*)  systemctl poweroff ;;
esac
