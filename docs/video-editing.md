# Video, audio and creative production

## Recommended baseline for this Z16
Hardware: Ryzen 9 PRO 6950H (8C/16T), Radeon 680M iGPU, RX 6500M dGPU with 4 GB VRAM, 32 GB RAM.

- **Kdenlive** for timeline editing and delivery.
- **OBS Studio** for screen capture, recording and streaming.
- **Blender** for 3D, compositing and motion graphics.
- **Audacity** for audio cleanup; Ardour is an optional DAW.
- **FFmpeg + HandBrake** for media inspection, conversion and transcodes.
- **GIMP / Inkscape** for raster and vector graphics.
- **darktable / RawTherapee** for RAW photo workflows.

These user applications are installed by standalone Home Manager. Fedora provides the system graphics, audio, portal and multimedia integration. Enable the appropriate Fedora multimedia repositories/codecs for your Fedora release and verify VA-API with vainfo; package availability and codec licensing vary by region and repository.

## Editing performance
- Use the 680M for desktop composition and light playback; try the RX 6500M for GPU-heavy effects if the application exposes a reliable GPU selector.
- The RX 6500M has only 4 GB VRAM. Start with 1080p timelines and moderate effects; 4K editing is possible with proxies but heavy grading, noise reduction, compositing and large effects stacks can exceed VRAM.
- Generate proxies for 4K, 10-bit, HEVC, camera RAW or high-bitrate footage. Set preview resolution to 1/2 or 1/4 and render timeline previews for complex sections.
- Keep media, proxies, project files and cache on fast Linux-native storage (Btrfs/ext4). Use a separate external SSD for large source footage and backups. Avoid using the Windows system partition as the active Linux project/cache volume.
- Keep at least 15–20% of the Linux data volume free. Video caches and renders can expand quickly.
- For long exports, plug into AC, use a balanced/performance power profile, ensure vents are clear, and monitor temperatures. Do not disable thermal protections or force fixed clocks.

## Codec and acceleration checks
Fedora:
~~~sh
vainfo
ffmpeg -hide_banner -hwaccels
ffmpeg -hide_banner -encoders | grep -Ei 'vaapi|amf|h264|hevc|av1'
~~~

Do not assume every codec/encoder is hardware accelerated just because VA-API is installed. Test a short sample export and compare CPU/GPU use and output quality. The RX 6500M lacks AV1 hardware decode; AV1 footage may decode on the CPU or need proxies.

## DaVinci Resolve caveat
Resolve's Linux requirements and supported driver stack are more restrictive than Kdenlive's, and its Linux build is primarily validated against a specific enterprise Linux base. This machine has 32 GB RAM and 4 GB discrete VRAM, but compatibility with the RX 6500M/Mesa stack is not guaranteed. Do not make Resolve a Linux-only dependency until you have installed the exact version, confirmed GPU compute is detected, opened representative footage, and completed a real export. Keep Windows for Resolve if your workflow depends on it.

## Backup and project hygiene
- Keep source footage in a read-only or backed-up location; never make the only copy your editing workspace.
- Back up project files and media separately from render output.
- Use dated project folders: Project/Footage, Audio, Graphics, Proxies, ProjectFiles and Exports.
- Test restoration of a project backup before deleting source media.
