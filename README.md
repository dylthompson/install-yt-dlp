# install-yt-dlp.command

**One-click installer for yt-dlp + Homebrew + ffmpeg on macOS**

Version **1.1.0** — 2026-05-03

---

## What it does

This script installs everything you need to use **yt-dlp** (the best YouTube/video downloader) on macOS with a single double-click:

- **Homebrew** (package manager) — if not already installed
- **yt-dlp** — the powerful video downloader
- **ffmpeg** — required for merging separate audio + video streams and converting formats

It works on both **Apple Silicon (M1/M2/M3/M4)** and **Intel Macs**.

---

## How to use

1. Download `install-yt-dlp.command`
2. Double-click it in Finder (or right-click → Open)
3. Enter your Mac password when prompted (only needed for Homebrew install)
4. Wait for it to finish — you'll see a nice colored progress display
5. Open a **new Terminal window** and start using `yt-dlp`

That's it!

---

## Example commands after installation

```bash
# Best quality video + audio (merged with ffmpeg)
yt-dlp "https://www.youtube.com/watch?v=..."

# Audio only, converted to MP3
yt-dlp -x --audio-format mp3 "https://www.youtube.com/watch?v=..."

# List all available formats
yt-dlp -F "https://www.youtube.com/watch?v=..."

# Full help
yt-dlp --help
```

Files are saved to your **current folder** (where you run the command from).

---

## Requirements

- macOS 10.15 (Catalina) or newer (recommended)
- Internet connection (first run only)
- Administrator password (only for the initial Homebrew install)

---

## Troubleshooting

### "Homebrew not found" or permission errors
The script will automatically install Homebrew and add it to your shell profile.  
If you see issues, open Terminal and run:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### ffmpeg not installed / "cannot merge audio+video"
The script tries to install ffmpeg. If it fails, you can install it manually later:
```bash
brew install ffmpeg
```

### Script window closes too fast
This shouldn't happen — the script ends with `read -n 1` so the window stays open until you press a key.  
If it still closes, run it from Terminal instead of double-clicking:
```bash
./install-yt-dlp.command
```

### Already have Homebrew / yt-dlp?
The script is **idempotent** — safe to run again. It will just upgrade packages if needed.

### Still having problems?
Open Terminal and run the script from there to see full output:
```bash
cd ~/Downloads   # or wherever you saved it
./install-yt-dlp.command
```

---

## Why this script?

- Avoids the dangerous `curl | bash` pattern
- Shows a spinner during long operations
- Gives clear success/failure messages with colors
- Handles both Apple Silicon and Intel Macs automatically
- Adds Homebrew to your shell profile correctly (no duplicates)
- Leaves you with a working `yt-dlp` + `ffmpeg` setup

---

## Credits

- [yt-dlp](https://github.com/yt-dlp/yt-dlp) — the best YouTube downloader
- [Homebrew](https://brew.sh) — the missing package manager for macOS
- [ffmpeg](https://ffmpeg.org) — the multimedia framework

---

**Enjoy downloading!** 🎥

*Script maintained as a clean, user-friendly installer. Feel free to fork or improve.*