#!/bin/bash
# Bluetooth D-Bus monitor for i3blocks refresh
# Watches BlueZ adapter and device property changes and signals i3blocks

REFRESH_SIGNAL="RTMIN+12"

# Loop ensures the monitor restarts if it ever crashes
while true; do
    dbus-monitor --system "type='signal',sender='org.bluez',interface='org.freedesktop.DBus.Properties',member='PropertiesChanged'" 2>/dev/null | while read -r line; do
        if [[ "$line" == *"org.bluez.Adapter1"* ]] || [[ "$line" == *"org.bluez.Device1"* ]]; then
            pkill -"$REFRESH_SIGNAL" i3blocks 2>/dev/null || true
        fi
    done
    # Small backoff before restarting
    sleep 2
done
