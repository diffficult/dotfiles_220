#!/usr/bin/env bash
# Brightness via brightnessctl (logind fallback)

notify_cmd='dunstify -u low -h string:x-dunst-stack-tag:i3brightness'
DEVICE="${BACKLIGHT_NAME:-acpi_video0}"
STEP="${STEP:-1}"

if command -v brightnessctl >/dev/null 2>&1; then
	get_pct() {
		brightnessctl -d "$DEVICE" -m 2>/dev/null | cut -d, -f4 | tr -d '%'
	}
	case "${1:-}" in
		--inc)
			brightnessctl -d "$DEVICE" set "+${STEP}" >/dev/null
			pct=$(get_pct)
			$notify_cmd -h int:value:"$pct" "Brightness" "${pct}%"
			;;
		--dec)
			brightnessctl -d "$DEVICE" set "${STEP}-" >/dev/null
			pct=$(get_pct)
			$notify_cmd -h int:value:"$pct" "Brightness" "${pct}%"
			;;
		--get)
			get_pct
			;;
		*)
			echo "$(get_pct)%"
			;;
	esac
	exit 0
fi

# Fallback: logind SetBrightness
BACKLIGHT="/sys/class/backlight/${DEVICE}"
if [[ ! -d "$BACKLIGHT" ]]; then
	BACKLIGHT=$(echo /sys/class/backlight/* 2>/dev/null | awk '{print $1}')
	DEVICE=$(basename "$BACKLIGHT")
fi
[[ -r "$BACKLIGHT/brightness" ]] || { $notify_cmd "Brightness" "No backlight"; exit 1; }

max=$(cat "$BACKLIGHT/max_brightness")
cur=$(cat "$BACKLIGHT/brightness")

set_bri() {
	local val=$1
	((val < 0)) && val=0
	((val > max)) && val=max
	busctl call org.freedesktop.login1 /org/freedesktop/login1/session/auto \
		org.freedesktop.login1.Session SetBrightness ssu backlight "$DEVICE" "$val" >/dev/null 2>&1
}

case "${1:-}" in
	--inc) set_bri $((cur + STEP)) ;;
	--dec) set_bri $((cur - STEP)) ;;
	--get)
		echo $((cur * 100 / max))
		exit 0
		;;
	*)
		echo "$((cur * 100 / max))%"
		exit 0
		;;
esac
cur=$(cat "$BACKLIGHT/brightness")
pct=$((cur * 100 / max))
$notify_cmd -h int:value:"$pct" "Brightness" "${pct}%"
