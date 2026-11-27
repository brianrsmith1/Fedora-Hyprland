#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck disable=SC1091
[[ -r /etc/os-release ]] && . /etc/os-release
[[ "${ID:-}" == fedora ]] || { echo "This installer is for Fedora only." >&2; exit 1; }
[[ "${EUID}" -ne 0 ]] || { echo "Run as your regular user, not with sudo." >&2; exit 1; }
for cmd in sudo dnf rpm; do command -v "$cmd" >/dev/null 2>&1 || { echo "Missing required command: $cmd" >&2; exit 1; }; done
bash "$ROOT/fedora/validate.sh"
echo "Installs Fedora-native Hyprland, AMD Mesa, audio, portals, host tools and Steam."
echo "Hyprland desktop packages use the third-party nett00n/hyprland COPR; Starship uses atim/starship."
echo "Power profiles use Fedora's TuneD/tuned-ppd stack; TLP is not configured by this installer."
echo "It does not alter partitions, Windows, EFI entries, bootloader or firmware."
read -r -p "Continue? [y/N] " answer
[[ "$answer" =~ ^[Yy]$ ]] || exit 0
FEDORA_VERSION="$(rpm -E %fedora)"
sudo dnf install -y dnf-plugins-core
sudo dnf copr enable -y nett00n/hyprland
sudo dnf copr enable -y atim/starship
sudo dnf install -y \
  "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-${FEDORA_VERSION}.noarch.rpm" \
  "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${FEDORA_VERSION}.noarch.rpm"
mapfile -t packages < <(grep -Ev '^[[:space:]]*(#|$)' "$ROOT/fedora/packages.txt")
if rpm -q tlp >/dev/null 2>&1; then
  echo "TLP is installed; skipping the repository TuneD power-profile helper."
  filtered=()
  for package in "${packages[@]}"; do [[ "$package" == "tuned-ppd" ]] || filtered+=("$package"); done
  packages=("${filtered[@]}")
fi
sudo dnf install -y "${packages[@]}"
if ! rpm -q tlp >/dev/null 2>&1; then bash "$ROOT/fedora/install-power-profile.sh"; fi
if ! fc-list 2>/dev/null | grep -qi "JetBrainsMono Nerd Font"; then bash "$ROOT/fedora/install-nerd-font.sh"; fi
echo "Fedora host packages installed."
echo "Next: install shared desktop configs with: bash shared/install-dotfiles.sh"
