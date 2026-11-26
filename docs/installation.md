# Fedora + Windows installation and rollback

## Intended layout
- Fedora is the Linux OS configured by this repository.
- Windows 11 remains a permanent dual-boot option.
- This repository does not partition disks, resize Windows, replace the EFI System Partition or rewrite bootloader entries.

## Before installing Fedora
1. Back up important Windows files and verify the backup.
2. Confirm Windows boots normally. If BitLocker/device encryption is enabled, save its recovery key.
3. Create Fedora installation media and boot it in UEFI mode.
4. Install Fedora only into intended free space. Do not delete Windows EFI, recovery or data partitions.
5. Keep Windows Boot Manager available and test both operating systems before changing firmware boot order.

Partitioning is a high-impact manual step. If the disk layout is unclear, stop and inspect it rather than guessing.

## Install this Fedora desktop
1. Install and fully update Fedora Workstation, then reboot.
2. Clone this repository:
   ```bash
   git clone https://github.com/brianrsmith1/Fedora-Hyprland.git
   cd Fedora-Hyprland
   ```
3. Review fedora/packages.txt and run:
   ```bash
   bash fedora/validate.sh
   bash fedora/install.sh
   ```
   Run as your regular user, not with sudo. The installer asks before enabling RPM Fusion and installing the listed host packages. It does not change partitions, Windows, EFI, bootloader or firmware. If TLP is installed, it skips power-profiles-daemon and the repository's profile helper.
4. Link the desktop configuration:
   ```bash
   bash shared/install-dotfiles.sh
   ```
   Existing config directories are moved to timestamped backups before links are created. Review the script first. To roll back, remove the symlinks and restore the backup directories.
5. Log out and select Hyprland from the display/session menu. If the session is not listed, reboot and inspect the display manager's session list.

## First-boot checks
- Confirm Windows and Fedora remain selectable in the firmware boot menu.
- Check Wi-Fi, Bluetooth, audio, microphone, brightness keys, touchpad and touchscreen.
- Test suspend/resume, external displays, USB-C docks and charger plug/unplug behavior.
- Run lspci -nnk, glxinfo -B and vulkaninfo --summary; confirm the Radeon 680M and RX 6500M are visible and use amdgpu.
- Test the RX 6500M only for a selected game using DRI_PRIME=1 %command%.
- Check powerprofilesctl get after AC/battery transitions if power-profiles-daemon is installed.

## Rollback
- **Desktop config:** remove the symlinks under ~/.config and restore the timestamped backups made by shared/install-dotfiles.sh.
- **Power helper:** disable z16-power-profile.service, remove /etc/udev/rules.d/90-z16-power-profile.rules and /etc/systemd/system/z16-power-profile.service, then reload systemd/udev. Do not do this while another power manager depends on it.
- **Fedora:** use the previous kernel from the boot menu if an update regresses.
- **Windows:** select the existing Windows Boot Manager entry. Never delete Windows partitions or EFI files as a Linux troubleshooting shortcut.
