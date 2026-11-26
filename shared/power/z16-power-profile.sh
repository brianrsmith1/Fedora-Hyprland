#!/usr/bin/env bash
set -euo pipefail
command -v powerprofilesctl >/dev/null 2>&1 || exit 0
on_ac=0
for supply in /sys/class/power_supply/*; do
  [[ -r "$supply/type" && -r "$supply/online" ]] || continue
  [[ "$(cat "$supply/type")" == "Mains" ]] || continue
  if [[ "$(cat "$supply/online")" == "1" ]]; then on_ac=1; break; fi
done
available="$(powerprofilesctl list 2>/dev/null || true)"
if (( on_ac )); then
  if grep -qi performance <<<"$available"; then powerprofilesctl set performance; else powerprofilesctl set balanced; fi
else
  if grep -qi power-saver <<<"$available"; then powerprofilesctl set power-saver; else powerprofilesctl set balanced; fi
fi
