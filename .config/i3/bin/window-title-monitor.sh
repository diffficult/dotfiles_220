#!/bin/bash
# Window title monitor for i3blocks refresh
# Uses xtitle -s to watch active window title changes, then signals i3blocks

REFRESH_SIGNAL="RTMIN+11"

# Loop ensures monitor restarts if it ever crashes
while true; do
    xtitle -s 2>/dev/null | while read -r; do
        pkill -"$REFRESH_SIGNAL" i3blocks 2>/dev/null || true
    done
    # Small backoff before restarting
    sleep 1
done
