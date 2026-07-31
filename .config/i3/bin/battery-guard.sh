#!/usr/bin/env bash
# Low-battery notify + suspend. Run from autostart (loop) or systemd timer.
# Thresholds: warn at WARN%, critical notify at CRIT%, suspend at SUSPEND%.

WARN="${BAT_WARN:-15}"
CRIT="${BAT_CRIT:-10}"
SUSPEND_AT="${BAT_SUSPEND:-8}"
INTERVAL="${BAT_INTERVAL:-60}"
STATE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/i3-battery-guard"
mkdir -p "$STATE_DIR"

notify() {
	local urgency=$1 title=$2 body=$3
	if command -v dunstify >/dev/null 2>&1; then
		dunstify -u "$urgency" -h string:x-dunst-stack-tag:battery-guard \
			-i battery-caution "$title" "$body"
	else
		notify-send -u "$urgency" "$title" "$body"
	fi
}

read_battery() {
	local bat path status energy full pct
	for bat in /sys/class/power_supply/BAT*; do
		[[ -d "$bat" ]] || continue
		status=$(cat "$bat/status" 2>/dev/null || echo Unknown)
		if [[ -f "$bat/capacity" ]]; then
			pct=$(cat "$bat/capacity")
		elif [[ -f "$bat/energy_now" && -f "$bat/energy_full" ]]; then
			energy=$(cat "$bat/energy_now")
			full=$(cat "$bat/energy_full")
			pct=$((energy * 100 / full))
		else
			continue
		fi
		echo "$status $pct"
		return 0
	done
	return 1
}

check_once() {
	local status pct
	read -r status pct < <(read_battery) || return 0

	# Reset flags when charging / full
	if [[ "$status" != "Discharging" ]]; then
		rm -f "$STATE_DIR"/warned "$STATE_DIR"/critical "$STATE_DIR"/suspend_armed
		return 0
	fi

	if ((pct <= SUSPEND_AT)); then
		if [[ ! -f "$STATE_DIR/suspend_armed" ]]; then
			touch "$STATE_DIR/suspend_armed"
			notify critical "Battery critical (${pct}%)" "Suspending in 30s — plug in to cancel"
			(
				sleep 30
				# re-check before suspend
				read -r s p < <(read_battery) || exit 0
				[[ "$s" == "Discharging" ]] || exit 0
				((p <= SUSPEND_AT)) || exit 0
				notify critical "Battery critical (${p}%)" "Suspending now"
				systemctl suspend
			) &
		fi
	elif ((pct <= CRIT)); then
		if [[ ! -f "$STATE_DIR/critical" ]]; then
			touch "$STATE_DIR/critical"
			notify critical "Battery low (${pct}%)" "Plug in soon — suspend at ${SUSPEND_AT}%"
		fi
	elif ((pct <= WARN)); then
		if [[ ! -f "$STATE_DIR/warned" ]]; then
			touch "$STATE_DIR/warned"
			notify normal "Battery (${pct}%)" "Consider plugging in"
		fi
	fi
}

if [[ "${1:-}" == "--once" ]]; then
	check_once
	exit 0
fi

while true; do
	check_once
	sleep "$INTERVAL"
done
