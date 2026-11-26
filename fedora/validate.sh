#!/usr/bin/env bash
set -euo pipefail
echo "Fedora-NixOS preflight"
if ! grep -qi '^ID=fedora' /etc/os-release; then echo "Warning: this script targets Fedora."; fi
for cmd in sudo dnf; do command -v "$cmd" >/dev/null || { echo "Missing $cmd"; exit 1; }; done
echo "Kernel: $(uname -r)"
echo "Session: ${XDG_SESSION_TYPE:-unknown}"
echo "GPU:"; lspci -nnk 2>/dev/null | grep -A3 -Ei 'VGA|Display|3D' || true
echo "Battery:"; grep -H . /sys/class/power_supply/BAT*/{status,capacity,cycle_count} 2>/dev/null || true
echo "Preflight complete. Review docs/hardware.md and docs/power-and-longevity.md."
