# ThinkPad Z16 power, OLED and battery longevity

Target: Ryzen 9 PRO 6950H, Radeon 680M + RX 6500M, OLED touchscreen.

- Fedora uses TuneD with `tuned-ppd`; this setup does not install the standalone `power-profiles-daemon` because the providers conflict.
- AC: Balanced by default to avoid unnecessary sustained fan noise, heat and power draw.
- Battery: Power Saver (`powersave`) when available, otherwise Balanced.
- For sustained heavy workloads, select `throughput-performance` manually with `sudo tuned-adm profile throughput-performance`; return to `balanced` afterward.
- If no AC power-supply device is exposed (as in many VMs), the helper leaves the current TuneD profile unchanged.
- TLP users should keep TLP as their sole power manager; the installer skips the repository TuneD helper when TLP is installed.
- Keep the 680M for routine desktop use and use the RX 6500M selectively.
- OLED: moderate brightness on battery, dark UI, screen blanking; test refresh rate instead of assuming lower always saves power.
- Keep Lenovo firmware defaults initially; no speculative undervolts, fan curves or kernel parameters.
- Compare Fedora and Windows under matched brightness, refresh, Wi-Fi and workload. Runtime improvement is not guaranteed.
