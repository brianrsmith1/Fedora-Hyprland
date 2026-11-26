# Power, thermals and longevity

The priorities are low idle overhead, stable thermals, predictable suspend and battery health—not chasing benchmark numbers.

## Policy
- Keep the stock Lenovo firmware power/thermal policy initially.
- Use power-profiles-daemon on Fedora, with its balanced profile as the default.
- Never run TLP and power-profiles-daemon together.
- Do not apply generic CPU undervolts, forced boost limits, fan curves or kernel parameters. The Z16 firmware and CPU generation determine what is safe and supported.
- Keep vents clear; clean dust with the device powered off and follow Lenovo's service manual.
- Avoid routinely leaving the battery at 100% while docked. Use supported charge thresholds if available.
- Use a quality USB-C/Lenovo charger with adequate wattage.
- Prefer stable Fedora updates and pinned Nix flake inputs; keep a known-good kernel and Home Manager generation.

## Fedora
~~~sh
powerprofilesctl get
powerprofilesctl list
powerprofilesctl set balanced
~~~
Use power-saver on battery when runtime matters, and performance only for sustained workloads when plugged in and thermals are healthy.

## Legacy NixOS reference
The nixos/ directory retains an older example. It is not part of the Fedora host configuration or the root Home Manager flake.

## SSD care
Modern SSDs handle normal desktop workloads. Keep periodic TRIM enabled (systemd's fstrim timer), maintain free space, and avoid unnecessary write-heavy logging. Do not schedule daily manual fstrim if the system timer already handles it.

## Maintenance cadence
- Monthly: install normal security updates; check firmware updates.
- Quarterly: review battery capacity/cycle count, inspect vents, verify backups and recovery boot.
- Before major upgrades: back up data and confirm a working rollback path.
