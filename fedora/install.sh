#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
[[ -r /etc/os-release ]] && . /etc/os-release
[[ "${ID:-}" == fedora ]] || { echo "This installer is for Fedora."; exit 1; }
command -v sudo >/dev/null && command -v dnf >/dev/null || exit 1
bash "$ROOT/fedora/validate.sh"
echo "Installs Fedora-owned Hyprland, AMD graphics, system services and Steam."
echo "User apps, creative tools, gaming launchers and CLI tools are managed by Home Manager."
echo "No bootloader, partition, Windows installation, firmware setting or login shell is changed."
read -r -p "Continue? [y/N] " answer
[[ "$answer" =~ ^[Yy]$ ]] || exit 0
FEDORA_VERSION="$(rpm -E %fedora)"
sudo dnf install -y \
  "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-${FEDORA_VERSION}.noarch.rpm" \
  "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${FEDORA_VERSION}.noarch.rpm"
mapfile -t packages < <(grep -Ev '^[[:space:]]*(#|$)' "$ROOT/fedora/packages.txt")
if rpm -q tlp >/dev/null 2>&1; then
  echo "TLP is installed. Skipping power-profiles-daemon to avoid two competing power managers."
  filtered=()
  for package in "${packages[@]}"; do
    [[ "$package" == "power-profiles-daemon" ]] || filtered+=("$package")
  done
  packages=("${filtered[@]}")
fi
sudo dnf install -y --skip-unavailable "${packages[@]}"
bash "$ROOT/fedora/install-nerd-font.sh" || echo "Nerd Font setup skipped; install it later with bash fedora/install-nerd-font.sh."
echo "Fedora host packages installed."
echo "Next: review docs/nix-fedora.md, then run bash fedora/nix-setup.sh."
