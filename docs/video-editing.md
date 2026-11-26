# Video, audio and creative production

## Recommended baseline for this Z16
Hardware: Ryzen 9 PRO 6950H (8C/16T), Radeon 680M iGPU, RX 6500M dGPU with 4 GB VRAM, 32 GB RAM.

Suggested applications include Kdenlive, OBS Studio, Blender, Audacity, FFmpeg, HandBrake, GIMP, Inkscape, darktable and RawTherapee. These are optional applications; the Fedora base installer does not install all of them. Install from Fedora repositories, RPM Fusion or Flathub after checking package provenance.

Fedora provides the system graphics, audio, portal and multimedia integration. Enable suitable Fedora multimedia repositories/codecs for your Fedora release and verify VA-API with vainfo; package availability and codec licensing vary by region and repository.

## Editing performance
- Use the 680M for desktop composition and light playback; try the RX 6500M for GPU-heavy effects if the application exposes a reliable GPU selector.
- The RX 6500M has only 4 GB VRAM. Start with 1080p timelines and moderate effects; 4K editing is more practical with proxies but heavy grading, noise reduction, compositing and large effects stacks can exceed VRAM.
- Generate proxies for 4K, 10-bit, HEVC, camera RAW or high-bitrate footage. Set preview resolution to 1/2 or 1/4 and render timeline previews for complex sections.
- Keep media, proxies, project files and cache on fast Linux-native storage. Back up source footage and project files separately.
- For long exports, plug into AC, use Balanced or Performance as appropriate, ensure vents are clear and monitor temperatures. Do not disable thermal protections or force fixed clocks.

## Codec and acceleration checks
```sh
vainfo
ffmpeg -hide_banner -hwaccels
ffmpeg -hide_banner -encoders | grep -Ei 'vaapi|h264|hevc|av1'
```
Do not assume every codec/encoder is hardware accelerated just because VA-API is installed. Test a short sample export and compare CPU/GPU use and output quality. The RX 6500M lacks AV1 hardware decode; AV1 footage may decode on the CPU or need proxies.

## DaVinci Resolve caveat
Resolve's Linux requirements and supported driver stack are more restrictive than Kdenlive's. Compatibility with the RX 6500M/Mesa stack is not guaranteed. Do not make Resolve a Linux-only dependency until you have confirmed GPU compute, opened representative footage and completed a real export. Keep Windows available if your workflow depends on Resolve.

## Backup and project hygiene
Keep source footage in a backed-up location, use dated project folders, and test restoration of project backups before deleting source media.
