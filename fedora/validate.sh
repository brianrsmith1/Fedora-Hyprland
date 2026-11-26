#!/usr/bin/env bash
set -euo pipefail
echo "Fedora Hyprland preflight"
if ! grep -qi '^ID=fedora' /etc/os-release; then echo "Warning: this configuration targets Fedora."; fi
for cmd in sudo dnf; do command -v "$cmd" >/dev/null || { echo "Missing required command: $cmd" >&2; exit 1; }; done
echo "Kernel: $(uname -r)"
echo "Session: ${XDG_SESSION_TYPE:-unknown}"
echo "Graphics:"
if command -v lspci >/dev/null 2>&1; then lspci -nnk | grep -A3 -Ei 'VGA|Display|3D' || true; else echo "lspci not installed yet (pciutils)."; fi
echo "Battery:"
grep -H . /sys/class/power_supply/BAT*/{status,capacity,cycle_count} 2>/dev/null || true
echo "Preflight complete. Review docs/installation.md, docs/hardware.md and docs/power-and-longevity.md."
