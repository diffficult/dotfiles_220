#!/bin/bash
if rfkill list bluetooth | grep -q "Soft blocked: no"; then
    rfkill block bluetooth
    dunstify -u low -h string:x-dunst-stack-tag:bluetooth "Bluetooth" "Disabled" -i bluetooth-disabled
else
    rfkill unblock bluetooth
    dunstify -u low -h string:x-dunst-stack-tag:bluetooth "Bluetooth" "Enabled" -i bluetooth
fi
