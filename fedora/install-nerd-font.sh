#!/usr/bin/env bash
set -euo pipefail
VERSION="3.5.1"
URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v${VERSION}/JetBrainsMono.tar.xz"
DEST="${XDG_DATA_HOME:-$HOME/.local/share}/fonts/JetBrainsMonoNerd"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
command -v curl >/dev/null || { echo "Install curl first."; exit 1; }
command -v tar >/dev/null || { echo "Install tar first."; exit 1; }
curl --fail --location --proto '=https' --tlsv1.2 "$URL" -o "$TMP/JetBrainsMono.tar.xz"
mkdir -p "$DEST"
tar -xJf "$TMP/JetBrainsMono.tar.xz" -C "$DEST"
if command -v fc-cache >/dev/null; then fc-cache -f "$DEST"; fi
echo "JetBrainsMono Nerd Font v${VERSION} installed for this user."
