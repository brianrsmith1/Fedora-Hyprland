#!/usr/bin/env bash
set -euo pipefail
if rpm -q tlp >/dev/null 2>&1; then
  echo "TLP is installed; not installing the power-profiles-daemon helper."
  exit 0
fi
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
sudo install -D -m 0755 "$ROOT/shared/power/z16-power-profile.sh" /usr/local/sbin/z16-power-profile
sudo install -D -m 0644 "$ROOT/shared/power/z16-power-profile.service" /etc/systemd/system/z16-power-profile.service
sudo install -D -m 0644 "$ROOT/shared/power/90-z16-power-profile.rules" /etc/udev/rules.d/90-z16-power-profile.rules
sudo systemctl daemon-reload
sudo udevadm control --reload-rules
sudo systemctl enable --now z16-power-profile.service
