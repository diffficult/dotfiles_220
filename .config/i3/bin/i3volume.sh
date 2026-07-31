#!/usr/bin/env bash

## Copyright (C) 2020-2023 Aditya Shakya <adi1090x@gmail.com>
##
## Script to manage speaker volume on Archcraft.
#
# Updated to use pactl instead of pulsemixer for PipeWire compatibility
#

notify_cmd='dunstify -u low -h string:x-dunst-stack-tag:obvolume'

# Get Volume
get_volume() {
	pactl get-sink-volume @DEFAULT_SINK@ | grep -o '[0-9]*%' | head -1 | tr -d '%'
}

# Get icons
get_icon() {
	current="$(get_volume)"
	if [[ "$current" -eq "0" ]]; then
		icon="/usr/share/icons/AdwaitaLegacy/24x24/legacy/audio-volume-muted.png"
	elif [[ ("$current" -ge "0") && ("$current" -le "33") ]]; then
		icon="/usr/share/icons/AdwaitaLegacy/24x24/legacy/audio-volume-low.png"
	elif [[ ("$current" -ge "33") && ("$current" -le "66") ]]; then
		icon="/usr/share/icons/AdwaitaLegacy/24x24/legacy/audio-volume-medium.png"
	elif [[ ("$current" -ge "66") && ("$current" -le "100") ]]; then
		icon="/usr/share/icons/AdwaitaLegacy/24x24/legacy/audio-volume-high.png"
	fi
}

# Notify
notify_user() {
	${notify_cmd} -i "$icon" "Volume : $(get_volume)%"
}

# Increase Volume
## inc_volume() {
## 	[[ `pulsemixer --get-mute` == 1 ]] && pulsemixer --unmute
## 	pulsemixer --max-volume 100 --change-volume +5 && get_icon && notify_user
## }
inc_volume() {
  local vol
  vol=$(get_volume)
  if [[ "$vol" -ge 100 ]]; then
    pactl set-sink-volume @DEFAULT_SINK@ 100%
  else
    pactl set-sink-volume @DEFAULT_SINK@ +5%
  fi
  pkill -RTMIN+10 i3blocks
  get_icon && notify_user
}

dec_volume() {
  pactl set-sink-volume @DEFAULT_SINK@ -5% && pkill -RTMIN+10 i3blocks && get_icon && notify_user
}

# Toggle Mute
## toggle_mute() {
## 	if [[ `pulsemixer --get-mute` == 0 ]]; then
## 		pulsemixer --toggle-mute && ${notify_cmd} -i "$iDIR/volume-mute.png" "Mute"
## 	else
## 		pulsemixer --toggle-mute && get_icon && ${notify_cmd} -i "$icon" "Unmute"
## 	fi
## }

toggle_mute() {
  if [[ `pactl get-sink-mute @DEFAULT_SINK@` == "Mute: no" ]]; then
    pactl set-sink-mute @DEFAULT_SINK@ 1 && pkill -RTMIN+10 i3blocks && ${notify_cmd} -i "/usr/share/icons/AdwaitaLegacy/24x24/legacy/audio-volume-muted.png" "Mute"
  else
    pactl set-sink-mute @DEFAULT_SINK@ 0 && pkill -RTMIN+10 i3blocks && get_icon && ${notify_cmd} -i "$icon" "Unmute"
  fi
}

# Toggle Mic
toggle_mic() {
	if [[ `pactl get-source-mute @DEFAULT_SOURCE@` == "Mute: no" ]]; then
		pactl set-source-mute @DEFAULT_SOURCE@ 1 && ${notify_cmd} -i "/usr/share/icons/AdwaitaLegacy/24x24/legacy/microphone-sensitivity-muted-symbolic.svg" "Microphone Switched OFF"
	else
		pactl set-source-mute @DEFAULT_SOURCE@ 0 && ${notify_cmd} -i "/usr/share/icons/AdwaitaLegacy/24x24/legacy/microphone-sensitivity-high-symbolic.svg" "Microphone Switched ON"
	fi
}

# Execute accordingly
if [[ "$1" == "--get" ]]; then
	get_volume
elif [[ "$1" == "--inc" ]]; then
	inc_volume
elif [[ "$1" == "--dec" ]]; then
	dec_volume
elif [[ "$1" == "--toggle" ]]; then
	toggle_mute
elif [[ "$1" == "--toggle-mic" ]]; then
	toggle_mic
else
	echo $(get_volume)%
fi
