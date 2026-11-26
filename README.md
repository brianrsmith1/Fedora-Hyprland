# Fedora Hyprland — ThinkPad Z16 Gen 1

Fedora-native Hyprland configuration for Lenovo ThinkPad Z16 Gen 1: Ryzen 9 PRO 6950H, Radeon 680M iGPU, Radeon RX 6500M dGPU, 32 GB RAM, 1 TB SSD, OLED touchscreen.

## Scope
Fedora manages the OS, kernel, AMDGPU/Mesa, system services, packages and power management. No Nix or Home Manager dependency.

## Desktop
Hyprland, muted Catppuccin Mocha/graphite styling, slim Waybar, Kitty, Fuzzel and SwayNC. Workspaces: 1 Main, 2 Terminal/Development, 3 Creative, 4 Communication, 5 Gaming.

## Z16 strategy
- Radeon 680M for normal desktop use; RX 6500M on demand.
- OLED: comfortable lower brightness on battery, dark theme, screen blanking; measure refresh-rate changes.
- AC: Performance when available, otherwise Balanced. Battery: Power Saver when available, otherwise Balanced.
- Do not run TLP and power-profiles-daemon together.
- Windows 11 is not modified by these scripts.

## Install
Review fedora/packages.txt and scripts first.

    git clone https://github.com/brianrsmith1/Fedora-Hyprland.git
    cd Fedora-Hyprland
    bash fedora/validate.sh
    bash fedora/install.sh

Configuration is Z16-targeted but not physically validated. Test GPU selection, suspend/resume, external displays, Wi-Fi, audio, charger events, thermals and battery runtime.