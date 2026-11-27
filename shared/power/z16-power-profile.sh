#!/usr/bin/env bash
set -euo pipefail

# Balanced is the sensible laptop default on AC. Use powersave on battery
# when available; select throughput-performance manually for sustained work.
# If no AC telemetry is exposed (for example, in a VM), leave the profile alone.
command -v tuned-adm >/dev/null 2>&1 || exit 0

has_mains=0
on_ac=0
for supply in /sys/class/power_supply/*; do
  [[ -r "$supply/type" && -r "$supply/online" ]] || continue
  [[ "$(cat "$supply/type")" == "Mains" ]] || continue
  has_mains=1
  if [[ "$(cat "$supply/online")" == "1" ]]; then on_ac=1; break; fi
done

(( has_mains )) || exit 0

available="$(tuned-adm list 2>/dev/null || true)"
if (( on_ac )); then
  tuned-adm profile balanced
else
  if grep -qE '^[[:space:]]*- powersave([[:space:]]|$)' <<<"$available"; then
    tuned-adm profile powersave
  else
    tuned-adm profile balanced
  fi
fi
