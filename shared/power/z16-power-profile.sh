#!/usr/bin/env bash
set -euo pipefail

# Prefer Fedora's TuneD profiles. Do not guess a battery state when the VM
# or hardware exposes no AC power-supply device.
command -v tuned-adm >/dev/null 2>&1 || exit 0

has_mains=0
on_ac=0
for supply in /sys/class/power_supply/*; do
  [[ -r "$supply/type" && -r "$supply/online" ]] || continue
  [[ "$(cat "$supply/type")" == "Mains" ]] || continue
  has_mains=1
  if [[ "$(cat "$supply/online")" == "1" ]]; then on_ac=1; break; fi
done

# VMware and other desktops may expose no battery/AC telemetry. Leave the
# administrator-selected TuneD profile unchanged in that case.
(( has_mains )) || exit 0

available="$(tuned-adm list 2>/dev/null || true)"
if (( on_ac )); then
  if grep -qE '^[[:space:]]*- throughput-performance([[:space:]]|$)' <<<"$available"; then
    tuned-adm profile throughput-performance
  else
    tuned-adm profile balanced
  fi
else
  if grep -qE '^[[:space:]]*- powersave([[:space:]]|$)' <<<"$available"; then
    tuned-adm profile powersave
  else
    tuned-adm profile balanced
  fi
fi
