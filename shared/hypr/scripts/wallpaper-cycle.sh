#!/usr/bin/env bash
set -euo pipefail

WALLPAPER_DIR="${XDG_PICTURES_DIR:-$HOME/Pictures}/Wallpapers"
quiet=0
[[ "${1:-}" == "--quiet" ]] && quiet=1
message() { (( quiet )) || printf '%s\n' "$*" >&2; }

if [[ ! -d "$WALLPAPER_DIR" ]]; then
  message "Create $WALLPAPER_DIR and add image files to enable wallpaper cycling."
  exit 0
fi

mapfile -d '' wallpapers < <(
  find "$WALLPAPER_DIR" -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) -print0
)
if (("${#wallpapers[@]}" == 0)); then
  message "No supported wallpapers found in $WALLPAPER_DIR."
  exit 0
fi

command -v hyprctl >/dev/null 2>&1 || { message "hyprctl is unavailable; run this inside Hyprland."; exit 1; }
command -v hyprpaper >/dev/null 2>&1 || { message "hyprpaper is not installed."; exit 1; }

selected="${wallpapers[RANDOM % ${#wallpapers[@]}]}"
# hyprpaper starts asynchronously with the compositor; retry its IPC briefly.
for _ in {1..20}; do
  if hyprctl hyprpaper wallpaper ",$selected" >/dev/null 2>&1; then
    message "Wallpaper: $selected"
    exit 0
  fi
  sleep 0.25
done

message "Could not contact hyprpaper. Check that the daemon is running."
exit 1
