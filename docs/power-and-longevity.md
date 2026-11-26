# ThinkPad Z16 power, OLED and battery longevity

Target: Ryzen 9 PRO 6950H, Radeon 680M + RX 6500M, OLED touchscreen.

- AC: request Performance when supported, otherwise Balanced.
- Battery: request Power Saver when supported, otherwise Balanced.
- Keep the 680M for routine desktop use and use the RX 6500M selectively.
- OLED: moderate brightness on battery, dark UI, screen blanking; test refresh rate instead of assuming lower always saves power.
- Keep Lenovo firmware defaults initially; no speculative undervolts, fan curves or kernel parameters.
- Never run TLP and power-profiles-daemon together.
- Compare Fedora and Windows under matched brightness, refresh, Wi-Fi and workload. Runtime improvement is not guaranteed.
