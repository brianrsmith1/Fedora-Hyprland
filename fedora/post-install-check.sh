#!/usr/bin/env bash
# Diagnostic smoke checks for the Fedora + Hyprland ThinkPad Z16 setup.
# This script does not change packages, services, firmware or partitions.
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
  if [[ "${ID:-}" == fedora ]]; then
    ok "Fedora detected (${VERSION_ID:-unknown})"
  else
    fail "Expected Fedora; found ${PRETTY_NAME:-unknown}"
  fi
else
  fail "/etc/os-release is unavailable"
fi

printf '\n== Core commands ==\n'
required=(Hyprland waybar kitty fuzzel swaync hyprlock hypridle hyprpaper thunar fish starship wpctl nmcli brightnessctl wl-paste wl-copy cliphist grim slurp swappy playerctl swaync-client wlogout)
optional=(tuned-adm lspci glxinfo vulkaninfo)
for cmd in "${required[@]}"; do
  if command -v "$cmd" >/dev/null 2>&1; then ok "$cmd"; else fail "$cmd is missing"; fi
done
for cmd in "${optional[@]}"; do
  if command -v "$cmd" >/dev/null 2>&1; then ok "$cmd"; else warn "$cmd is unavailable; install/check its Fedora package"; fi
done

printf '\n== Configuration files ==\n'
for file in \
  shared/hypr/hyprland.conf shared/hypr/hypridle.conf shared/hypr/hyprlock.conf \
  shared/waybar/config.jsonc shared/waybar/style.css shared/kitty/kitty.conf \
  shared/fuzzel/fuzzel.ini shared/swaync/config.json shared/swaync/style.css \
  shared/fish/config.fish shared/starship.toml; do
  if [[ -s "$ROOT/$file" ]]; then ok "$file exists"; else fail "$file is missing or empty"; fi
done

if command -v python3 >/dev/null 2>&1; then
  if python3 - "$ROOT" <<'PY'
import json
import pathlib
import sys

root = pathlib.Path(sys.argv[1])
for relative in ("shared/waybar/config.jsonc", "shared/swaync/config.json"):
    path = root / relative
    try:
        json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        print(f"[FAIL] {relative}: {exc}", file=sys.stderr)
        sys.exit(1)
    print(f"[OK]   {relative} parses as JSON")
PY
  then
    :
  else
    fail "JSON configuration validation failed"
  fi
else
  warn "python3 unavailable; skipped JSON configuration validation"
fi

printf '\n== Desktop configuration links ==\n'
for item in hypr waybar kitty fish fuzzel swaync; do
  target="$HOME/.config/$item"
  expected="$ROOT/shared/$item"
  if [[ -L "$target" && "$(readlink -f -- "$target" 2>/dev/null || true)" == "$(readlink -f -- "$expected")" ]]; then
    ok "$HOME/.config/$item points to this checkout"
  elif [[ -e "$target" || -L "$target" ]]; then
    warn "$HOME/.config/$item exists but is not linked to this checkout"
  else
    warn "$HOME/.config/$item is not installed yet (run bash shared/install-dotfiles.sh)"
  fi
done
if [[ -L "$HOME/.config/starship.toml" && "$(readlink -f -- "$HOME/.config/starship.toml" 2>/dev/null || true)" == "$(readlink -f -- "$ROOT/shared/starship.toml")" ]]; then
  ok "$HOME/.config/starship.toml points to this checkout"
else
  warn "$HOME/.config/starship.toml is not linked to this checkout"
fi
if [[ -x "$HOME/.local/bin/run-on-discrete-gpu" ]]; then
  ok "run-on-discrete-gpu helper is executable"
else
  warn "run-on-discrete-gpu helper is missing or not executable"
fi

printf '\n== AMD graphics ==\n'
if command -v lspci >/dev/null 2>&1; then
  gpu_report="$(lspci -nnk 2>/dev/null | grep -A3 -Ei 'VGA compatible controller|Display controller|3D controller' || true)"
  if [[ -n "$gpu_report" ]]; then
    printf '%s\n' "$gpu_report"
    if grep -qi 'Kernel driver in use: amdgpu' <<<"$gpu_report"; then
      ok "amdgpu is bound to at least one display device"
    else
      warn "No amdgpu binding found in the display-device report"
    fi
    gpu_count="$(grep -Eic 'VGA compatible controller|Display controller|3D controller' <<<"$gpu_report" || true)"
    if (( gpu_count >= 2 )); then
      ok "Two or more graphics devices are visible"
    else
      warn "Only one graphics device detected; confirm the RX 6500M is visible"
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
  if systemctl is-active --quiet tuned.service; then
    ok "tuned.service is active"
  else
    warn "tuned.service is not active"
  fi
  if command -v tuned-adm >/dev/null 2>&1; then
    tuned-adm active || true
  fi
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
