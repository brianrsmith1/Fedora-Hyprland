# Linux gaming setup — ThinkPad Z16 Gen 1

Target hardware: Ryzen 9 PRO 6950H, Radeon 680M iGPU, Radeon RX 6500M dGPU (4 GB VRAM), 32 GB RAM.

## Launcher options
Steam is installed by fedora/packages.txt through Fedora/RPM Fusion. Optional launchers include Heroic (Epic/GOG/Amazon), Lutris, Prism Launcher, itch.io, Bottles, ProtonUp-Qt and Discord. Install only the launchers you use, from Fedora repositories, RPM Fusion or Flathub after reviewing their source.

## Steam and Proton
1. Sign in and open Settings -> Compatibility.
2. Enable Steam Play for supported titles (and optionally all other titles).
3. Start with the latest stable Proton. Try GE-Proton only when a specific title benefits.
4. For a game-specific override, open Properties -> Compatibility and select a tool version.

## AMD hybrid graphics: select the RX 6500M
Use Radeon 680M for Hyprland and everyday work. Both GPUs use the in-kernel amdgpu driver and Mesa RADV. For a Steam game, leave Steam itself on the iGPU and use this per-game Launch Option:
```sh
DRI_PRIME=1 %command%
```
For other launchers, set DRI_PRIME=1 in that game's environment or run it with run-on-discrete-gpu. Confirm the renderer with glxinfo -B or vulkaninfo --summary. Never set DRI_PRIME globally.

## Performance expectations
The RX 6500M has 4 GB dedicated GDDR6 VRAM. Start at 1920x1080 with medium textures; use FSR/upscaling where available and avoid high-resolution texture packs. Plug in for demanding games and use a higher power profile only when needed. Higher power modes increase heat, fan noise and battery drain.

## Diagnostics and compatibility
- OpenGL renderer: glxinfo -B.
- Vulkan: vulkaninfo --summary.
- GameMode, MangoHud and Gamescope are optional; install them only if useful.
- Proton anti-cheat support is title- and publisher-specific. Check ProtonDB, Are We Anti-Cheat Yet? and recent player reports before purchasing. No setting can force a publisher to support Linux.

## Longevity
Keep Mesa and the kernel on the normal Fedora update cadence. Avoid unofficial kernels, automatic undervolting, overclocking and always-on performance daemons. Keep game libraries backed up.
