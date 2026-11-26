# Fedora Hyprland — ThinkPad Z16 Gen 1

Fedora-native Hyprland configuration for Lenovo ThinkPad Z16 Gen 1: Ryzen 9 PRO 6950H, Radeon 680M iGPU, Radeon RX 6500M dGPU, 32 GB RAM, 1 TB SSD and OLED touchscreen.

## Scope
Fedora manages the OS, kernel, AMDGPU/Mesa graphics, system services, desktop packages and power management. This project has no Nix or Home Manager dependency. Windows 11 remains a separate dual-boot option; the scripts do not repartition disks or edit Windows/EFI/bootloader settings.

## Desktop
Hyprland, muted Catppuccin Mocha/graphite styling, slim Waybar, Kitty, Fuzzel and SwayNC. Workspaces: 1 Main, 2 Terminal/Development, 3 Creative, 4 Communication, 5 Gaming.

## Z16 strategy
- Radeon 680M for normal desktop use; RX 6500M on demand with DRI_PRIME=1.
- OLED: comfortable lower brightness on battery, dark theme and screen blanking; measure refresh-rate changes.
- AC: Performance when exposed by the platform, otherwise Balanced. Battery: Power Saver when available, otherwise Balanced.
- Do not run TLP and power-profiles-daemon together.
- Windows is not modified by these scripts.

## Install
Review fedora/packages.txt and the scripts before running. Use a current Fedora Workstation installation.

```bash
git clone https://github.com/brianrsmith1/Fedora-Hyprland.git
cd Fedora-Hyprland
bash fedora/validate.sh
bash fedora/install.sh
bash shared/install-dotfiles.sh
```

Log out and choose Hyprland in your session selector. The package manifest covers the core desktop and host stack; optional gaming and creative applications are listed in docs/software.md and are not silently installed by the base script.

## Validation status
This is a Z16-targeted configuration, not a claim of physical validation. Test GPU selection, suspend/resume, external displays, Wi-Fi, audio, charger events, thermals and battery runtime on the actual laptop. Preserve Windows and keep a working recovery path.
