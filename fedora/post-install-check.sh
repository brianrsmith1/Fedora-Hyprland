#!/usr/bin/env bash
# Post-install smoke checks for the Fedora 45 + Hyprland ThinkPad Z16 setup.
# This script is diagnostic: it does not change packages, services or firmware.
set -uo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
errors=0
warnings=0

ok()   { printf '  [OK]   %s\n' "$*"; }
warn() { printf '  [WARN] %s\n' "$*"; ((warnings+=1)); }
fail() { printf '  [FAIL] %s\n' "$*"; ((errors+=1)); }

if [[ -r /etc/os-release ]]; then
  # shellcheck disable=SC1091
  . /etc/os-release
  [[ "${ID:-}" == fedora ]] && ok "Fedora detected (${VERSION_ID:-unknown})" || fail "Expected Fedora; found ${PRETTY_NAME:-unknown}"
else
  fail "/etc/os-release is unavailable"
fi

printf '\n== Core commands ==\n'
for cmd in Hyprland waybar kitty fuzzel swaync hyprlock hypridle hyprpaper thunar fish starship tuned-adm lspci glxinfo vulkaninfo wpctl nmcli brightnessctl; do
  if command -v "$cmd" >/dev/null 2>&1; then
    ok "$cmd"
  else
    case "$cmd" in
      glxinfo|vulkaninfo|lspci|tuned-adm) warn "$cmd is unavailable; install/check its Fedora package" ;;
      *) fail "$cmd is missing" ;;
    esac
  fi
done

printf '\n== Desktop configuration links ==\n'
for item in hypr waybar kitty fish fuzzel swaync; do
  target="$HOME/.config/$item"
  expected="$ROOT/shared/$item"
  if [[ -L "$target" && "$(readlink -f -- "$target" 2>/dev/null || true)" == "$(readlink -f -- "$expected")" ]]; then
    ok "~/.config/$item points to this checkout"
  elif [[ -e "$target" || -L "$target" ]]; then
    warn "~/.config/$item exists but is not linked to this checkout"
  else
    warn "~/.config/$item is not installed yet (run bash shared/install-dotfiles.sh)"
  fi
done
if [[ -x "$HOME/.local/bin/run-on-discrete-gpu" ]]; then
  ok "run-on-discrete-gpu helper is installed"
else
  warn "run-on-discrete-gpu helper is missing"
fi

printf '\n== AMD graphics ==\n'
if command -v lspci >/dev/null 2>&1; then
  gpu_report="$(lspci -nnk 2>/dev/null | grep -A3 -Ei 'VGA compatible controller|Display controller|3D controller' || true)"
  if [[ -n "$gpu_report" ]]; then
    printf '%s\n' "$gpu_report"
    if grep -qi 'Kernel driver in use: amdgpu' <<<"$gpu_report"; then
      ok "amdgpu kernel driver is bound to at least one display device"
    else
      warn "No amdgpu binding found in the display-device report"
    fi
    gpu_count="$(grep -Eic 'VGA compatible controller|Display controller|3D controller' <<<"$gpu_report" || true)"
    if (( gpu_count >= 2 )); then
      ok "Two or more graphics devices are visible"
    else
      warn "Only one graphics device was detected; confirm the RX 6500M is visible"
    fi
  else
    warn "No display controller was found by lspci"
  fi
else
  warn "lspci is not installed; install pciutils"
fi

if command -v glxinfo >/dev/null 2>&1; then
  printf '\nDefault OpenGL renderer:\n'
  glxinfo -B 2>/dev/null | grep -E 'OpenGL vendor|OpenGL renderer|OpenGL version' || warn "glxinfo could not query the default renderer"
  printf '\nDRI_PRIME=1 OpenGL renderer (discrete-GPU test):\n'
  DRI_PRIME=1 glxinfo -B 2>/dev/null | grep -E 'OpenGL vendor|OpenGL renderer|OpenGL version' || warn "DRI_PRIME=1 renderer query failed; test after logging into Hyprland"
fi

if command -v vulkaninfo >/dev/null 2>&1; then
  printf '\nVulkan devices (summary):\n'
  vulkaninfo --summary 2>/dev/null | grep -E 'GPU[0-9]+|deviceName|driverName' | head -20 || warn "Vulkan device query failed"
fi

printf '\n== Power management ==\n'
if rpm -q tlp >/dev/null 2>&1; then
  ok "TLP is installed; repository TuneD helper should remain disabled"
elif rpm -q tuned-ppd >/dev/null 2>&1; then
  ok "tuned-ppd package is installed"
  systemctl is-active --quiet tuned.service && ok "tuned.service is active" || warn "tuned.service is not active"
  command -v tuned-adm >/dev/null 2>&1 && tuned-adm active || true
else
  warn "Neither TLP nor tuned-ppd is installed"
fi
for battery in /sys/class/power_supply/BAT*; do
  [[ -d "$battery" ]] || continue
  [[ -r "$battery/capacity" ]] && printf 'Battery %s: %s%%\n' "$(basename "$battery")" "$(cat "$battery/capacity")"
  [[ -r "$battery/status" ]] && printf 'Battery status: %s\n' "$(cat "$battery/status")"
done

printf '\n== Manual hardware tests still required ==\n'
printf '%s\n' \
  '  - Suspend and resume several times; check Wi-Fi, audio and touch input.' \
  '  - Test OLED brightness keys, touchscreen, touchpad and fingerprint reader (if fitted).' \
  '  - Test USB-C charging, external displays and docks.' \
  '  - Compare battery drain and temperatures on AC and battery.' \
  '  - Confirm Windows Boot Manager still boots before changing UEFI settings.'

printf '\nSummary: %d error(s), %d warning(s).\n' "$errors" "$warnings"
(( errors == 0 ))
