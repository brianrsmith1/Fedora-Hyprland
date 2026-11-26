#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
[[ -r /etc/os-release ]] && . /etc/os-release
[[ "${ID:-}" == fedora ]] || { echo "This installer is for Fedora."; exit 1; }
command -v sudo >/dev/null && command -v dnf >/dev/null || exit 1
bash "$ROOT/fedora/validate.sh"
echo "Installs Fedora-native Hyprland, AMD graphics, system services and core desktop tools."
echo "No partition, Windows, EFI, bootloader or firmware changes are made."
read -r -p "Continue? [y/N] " answer
[[ "$answer" =~ ^[Yy]$ ]] || exit 0
FEDORA_VERSION="$(rpm -E %fedora)"
sudo dnf install -y "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-${FEDORA_VERSION}.noarch.rpm" "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${FEDORA_VERSION}.noarch.rpm"
mapfile -t packages < <(grep -Ev '^[[:space:]]*(#|$)' "$ROOT/fedora/packages.txt")
if rpm -q tlp >/dev/null 2>&1; then
  filtered=()
  for package in "${packages[@]}"; do [[ "$package" == "power-profiles-daemon" ]] || filtered+=("$package"); done
  packages=("${filtered[@]}")
fi
sudo dnf install -y --skip-unavailable "${packages[@]}"
bash "$ROOT/fedora/install-nerd-font.sh" || true
if ! rpm -q tlp >/dev/null 2>&1; then bash "$ROOT/fedora/install-power-profile.sh"; fi
echo "Fedora Hyprland host setup completed. Review docs/power-and-longevity.md and install shared configs with bash shared/install-dotfiles.sh."
