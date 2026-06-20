#!/usr/bin/env bash
# Switch to workspace $1. If already on it, cycle focus between its windows.
target="$1"
active="$(hyprctl activeworkspace -j | jq -r '.id')"

if [ "$active" = "$target" ]; then
    hyprctl dispatch cyclenext
else
    hyprctl dispatch workspace "$target"
fi
