# Software selection and package ownership

This repository separates operating-system ownership from user application ownership.

- Fedora provides the kernel, AMD graphics drivers, Hyprland session, Waybar, portals, PipeWire, networking, power management, firmware utilities and Steam host integration.
- Standalone Home Manager provides user applications, development tools, launchers, creative software and dotfiles.
- Windows remains available for software, games or production workflows that require native Windows support.

## Daily desktop (Fedora)
Hyprland, Waybar, Kitty, Fuzzel, SwayNC, Hyprlock, Hypridle, Thunar, xdg-desktop-portals, PipeWire/WirePlumber, NetworkManager, Blueman, power-profiles-daemon and AMD Mesa/RADV.

## Terminal and development (Home Manager)
Fish, Starship, zoxide, fzf, ripgrep, fd, bat, eza, btop, fastfetch, Git, GitHub CLI, Neovim, tmux, direnv, nix-direnv, shellcheck, shfmt, jq, yq, unzip, zip and rsync.

## Gaming
- Steam + Proton — Steam is installed by Fedora/RPM Fusion so it uses the host graphics stack.
- Heroic Games Launcher — Epic, GOG and Amazon Prime Gaming libraries.
- Lutris — flexible launcher for Battle.net, EA App, Ubisoft Connect, GOG and custom Wine runners.
- Prism Launcher — Minecraft Java instances and modpacks.
- itch.io — indie games and game jams.
- Bottles — isolated Wine environments for Windows applications and selected launchers.
- ProtonUp-Qt — manage GE-Proton and other compatibility tools.
- Discord — optional voice/text companion for multiplayer.
- Wine, Winetricks, Protontricks, GameMode, Gamescope, MangoHud and Vulkan tools — compatibility and diagnostics.

The Radeon 680M iGPU is the default desktop renderer; use DRI_PRIME=1 %command% per demanding Steam game to select the RX 6500M. Avoid forcing the dGPU globally because it increases idle power use.

## Creative production (Home Manager)
- Kdenlive — primary general-purpose video editor; use proxies and reduced preview resolution for 4K footage.
- OBS Studio — screen capture, recording and streaming.
- Blender — 3D, compositing and motion graphics; complex scenes can exceed 4 GB VRAM.
- Audacity — audio cleanup and editing; Ardour is an optional DAW.
- HandBrake + FFmpeg — transcode, inspect and batch-process media.
- GIMP + Inkscape — raster and vector graphics.
- darktable + RawTherapee — RAW photo workflows.

The RX 6500M has 4 GB VRAM. 1080p timelines are the sensible starting point; 4K editing is possible with proxies, but heavy grading, noise reduction and compositing can exceed GPU memory. DaVinci Resolve is not installed automatically because its Linux driver/base requirements and this GPU's VRAM make compatibility uncertain. Keep Windows if Resolve or another Windows-only creative suite is mission-critical.

## Compatibility notes
Proton and Wine are compatibility layers, not Windows emulation or anti-cheat workarounds. Easy Anti-Cheat and BattlEye work only when the individual game publisher enables/configures support for that title. Kernel-level anti-cheat, unsupported launchers/DRM and some competitive multiplayer games may remain unavailable. Check current reports for each title before buying or troubleshooting.

## Longevity policy
Keep overlays off by default. Use GameMode only while gaming and MangoHud only when needed. Do not force the RX 6500M globally, run TLP alongside power-profiles-daemon, disable Secure Boot as a generic fix, or apply unsupported CPU/GPU overclocking or undervolting.
