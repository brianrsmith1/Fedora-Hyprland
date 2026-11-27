# Desktop configuration reference

This repository keeps the desktop configuration in `shared/` and links it into `~/.config`. The installer makes timestamped backups of any existing files, directories or symlinks before creating links. Re-running it leaves links that already point at this checkout in place.

## Session startup

Hyprland exports `WAYLAND_DISPLAY`, `XDG_CURRENT_DESKTOP` and `XDG_SESSION_TYPE` to both D-Bus activation and the systemd user manager. This is important for xdg-desktop-portal, screen sharing, file pickers and applications launched outside the terminal.

The session starts Waybar, SwayNC, Hypridle and Hyprpaper. A wallpaper is optional: create `~/Pictures/Wallpapers` and add JPG, PNG or WebP files. The startup helper selects one at login; Super+Shift+W selects another. If the folder is absent or empty, the desktop starts without a wallpaper and does not fail.

## Keybindings

| Keys | Action |
| --- | --- |
| Super+Enter | Kitty terminal |
| Super+Space | Fuzzel application launcher |
| Super+E | Thunar file manager |
| Super+Q | Close focused window |
| Super+V | Toggle floating |
| Super+F | Fullscreen |
| Super+Ctrl+L | Lock screen |
| Super+Shift+R | Reload Hyprland |
| Super+Shift+W | Random wallpaper |
| Super+N | Toggle notification center |
| Super+Shift+N | Toggle Do Not Disturb |
| Super+Shift+M | Power/logout menu |
| Super+Shift+S | Select and annotate screenshot |
| Super+1…5 | Switch workspace |
| Super+Shift+1…5 | Move window to workspace |
| Super+H/J/K/L | Focus left/down/up/right |
| Super+Shift+H/J/K/L | Move window left/down/up/right |

The function-row media and brightness keys use PipeWire/WirePlumber, playerctl and brightnessctl. Touchpad natural scrolling and tap-to-click are enabled; edit `shared/hypr/hyprland.conf` if you prefer different behavior.

## Appearance

The palette is a restrained Catppuccin Mocha/graphite variant. Waybar, Fuzzel, Kitty, SwayNC and Starship share the same muted colors and JetBrainsMono Nerd Font. The font installer downloads a pinned Nerd Fonts release and installs it per-user.

## Hardware policy

The Radeon 680M remains the default renderer for the desktop. Use `DRI_PRIME=1` only for selected applications or games that benefit from the RX 6500M. No global dGPU environment variable, fixed clocks, undervolting or speculative kernel parameters are applied.

Power profiles use TuneD/tuned-ppd unless TLP is already installed. Do not run two competing laptop power managers at the same time.
