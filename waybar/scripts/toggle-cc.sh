#!/bin/bash
LOCK_FILE="/tmp/waybar-cc.pid"
if [ -f "$LOCK_FILE" ] && kill -0 "$(cat "$LOCK_FILE")" 2>/dev/null; then
    kill "$(cat "$LOCK_FILE")"
    rm "$LOCK_FILE"
else
    waybar -c ~/.config/waybar/config-cc.jsonc \
           -s ~/.config/waybar/style-cc.css &
    echo $! > "$LOCK_FILE"
fi
