# ThinkPad Z16 power, OLED and battery longevity

Target: Ryzen 9 PRO 6950H, Radeon 680M + RX 6500M, OLED touchscreen.

- Fedora uses TuneD with `tuned-ppd`; this setup does not install the standalone `power-profiles-daemon` because the two providers conflict.
- AC: request TuneD's `throughput-performance` profile when available, otherwise `balanced`.
- Battery: request TuneD's `powersave` profile when available, otherwise `balanced`.
- If no AC power-supply device is exposed (as in many VMs), the helper leaves the current TuneD profile unchanged.
- TLP users should keep TLP as their sole power manager; the installer skips the repository TuneD helper when TLP is installed.
- Keep the 680M for routine desktop use and use the RX 6500M selectively.
- OLED: moderate brightness on battery, dark UI, screen blanking; test refresh rate instead of assuming lower always saves power.
- Keep Lenovo firmware defaults initially; no speculative undervolts, fan curves or kernel parameters.
- Compare Fedora and Windows under matched brightness, refresh, Wi-Fi and workload. Runtime improvement is not guaranteed.
