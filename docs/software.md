# Software selection and package ownership

This is a Fedora-only project. Fedora's DNF package manager owns the OS, desktop session, system libraries, graphics drivers and all packages installed by fedora/install.sh. There is no Nix or Home Manager in this repository.

## Installed by the base setup
Hyprland, Waybar, Kitty, Fuzzel, SwayNC, Hyprlock, Hypridle, Thunar, portals, PipeWire/WirePlumber, networking and Bluetooth applets, power-profiles-daemon (unless TLP is installed), AMD Mesa/RADV, Steam and diagnostic tools. See fedora/packages.txt for the exact manifest.

## Optional applications
The base installer intentionally does not install every optional launcher, appearance editor or creative application. Choose the apps you actually use and install them from Fedora repositories, RPM Fusion or Flathub after reviewing package provenance.

- **Gaming:** Heroic Games Launcher, Lutris, Prism Launcher, Bottles, ProtonUp-Qt, Discord, MangoHud, GameMode and Gamescope.
- **Appearance (optional):** nwg-look, if available from a trusted repository.
- **Creative:** Kdenlive, OBS Studio, Blender, Audacity, HandBrake, FFmpeg, GIMP, Inkscape, darktable and RawTherapee.
- **Development (included in the base setup):** Fish, Starship, zoxide, fzf, ripgrep, fd, bat, eza, btop, fastfetch, Git, GitHub CLI, Neovim, tmux, direnv, ShellCheck, shfmt, jq, yq, rsync, unzip and zip.

Steam is installed by the host package manifest. Keep the desktop on the Radeon 680M and use DRI_PRIME=1 %command% per demanding Steam game to select the RX 6500M. Do not force the dGPU globally.

## Creative-work notes
The RX 6500M has 4 GB VRAM. Start with 1080p timelines; 4K editing is more practical with proxies and reduced preview resolution. DaVinci Resolve compatibility with the Linux graphics stack is not guaranteed; keep Windows available if a Windows-only creative suite is mission-critical.

## Compatibility and longevity
Proton and Wine are compatibility layers, not Windows emulation or anti-cheat workarounds. Anti-cheat support is title- and publisher-specific. Keep overlays off by default, use GameMode only while gaming, and avoid unsupported overclocking, undervolting or fixed clocks.
