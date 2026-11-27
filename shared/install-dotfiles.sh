#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG="$HOME/.config"
BIN="$HOME/.local/bin"
STAMP="$(date +%Y%m%d-%H%M%S)-$$"
mkdir -p "$CONFIG" "$BIN"

link_target() {
  local src="$1" dest="$2" current
  [[ -e "$src" ]] || { echo "Missing source: $src" >&2; return 1; }

  if [[ -L "$dest" ]]; then
    current="$(readlink -f -- "$dest" 2>/dev/null || true)"
    if [[ "$current" == "$(readlink -f -- "$src")" ]]; then
      echo "Already linked: $dest"
      return 0
    fi
  fi

  # Preserve files, directories, and unrelated symlinks rather than deleting them.
  if [[ -e "$dest" || -L "$dest" ]]; then
    mv -- "$dest" "${dest}.backup-$STAMP"
    echo "Backed up: $dest -> ${dest}.backup-$STAMP"
  fi
  ln -s -- "$src" "$dest"
  echo "Linked: $dest"
}

for item in hypr waybar kitty fish fuzzel swaync; do
  link_target "$ROOT/shared/$item" "$CONFIG/$item"
done

link_target "$ROOT/shared/starship.toml" "$CONFIG/starship.toml"
link_target "$ROOT/shared/scripts/run-on-discrete-gpu.sh" "$BIN/run-on-discrete-gpu"

echo "Desktop configs linked."
echo "Backups, if any, use suffix .backup-$STAMP."
echo "Ensure ~/.local/bin is on PATH; log out and select the Hyprland session."
