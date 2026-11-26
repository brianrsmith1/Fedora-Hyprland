#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG="$HOME/.config"
BIN="$HOME/.local/bin"
STAMP="$(date +%Y%m%d-%H%M%S)"
mkdir -p "$CONFIG" "$BIN"
for item in hypr waybar kitty fish fuzzel swaync; do
  src="$ROOT/shared/$item"
  [[ -d "$src" ]] || continue
  dest="$CONFIG/$item"
  if [[ -e "$dest" && ! -L "$dest" ]]; then mv "$dest" "${dest}.backup-$STAMP"
  elif [[ -L "$dest" ]]; then rm "$dest"; fi
  ln -s "$src" "$dest"
done
install -d "$BIN"
ln -sfn "$ROOT/shared/scripts/run-on-discrete-gpu.sh" "$BIN/run-on-discrete-gpu"
echo "Linked desktop configs and run-on-discrete-gpu."
echo "Backups (if any) use suffix .backup-$STAMP. Ensure ~/.local/bin is on PATH."
