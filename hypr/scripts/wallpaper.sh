#!/bin/bash

WALLPAPER_DIR="$HOME/dotfiles/wallpapers"

# Opens picker with rofi
WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) |
    sed "s|$WALLPAPER_DIR/||" |
    rofi -dmenu -p "Wallpaper" |
    sed "s|^|$WALLPAPER_DIR/|")

# If user cancelled rofi, exit
if [[ -z "$WALLPAPER" ]]; then
    exit 0
fi

# Detect wallpaper brightness using imagemagick v7
# Returns a value from 0 (black) to 255 (white)
BRIGHTNESS=$(magick "$WALLPAPER" -colorspace Gray -format "%[fx:mean*255]" info: 2>/dev/null | cut -d. -f1)

# Choose theme based on brightness threshold (128 = midpoint)
if [[ "$BRIGHTNESS" -gt 160 ]]; then
    MATUGEN_MODE="light"
else
    MATUGEN_MODE="dark"
fi

# Generate colors with Matugen using detected mode
# --source-color-index 0 skips the interactive color picker
matugen image "$WALLPAPER" --mode "$MATUGEN_MODE" --source-color-index 0

# Update hyprpaper
hyprctl hyprpaper unload all
hyprctl hyprpaper preload "$WALLPAPER"
hyprctl hyprpaper wallpaper ",$WALLPAPER"

# Reload Hyprland colors
hyprctl reload

# Reload Waybar
killall -9 waybar
waybar &
