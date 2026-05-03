# yt-dlp One-Click Installer for macOS

[![Version](https://img.shields.io/badge/version-1.2.0-blue)](https://github.com/)
[![Platform](https://img.shields.io/badge/platform-macOS%20(Apple%20Silicon%20%26%20Intel)-green)](https://www.apple.com/macos/)
[![License](https://img.shields.io/badge/license-MIT-lightgrey)](https://opensource.org/licenses/MIT)

**The easiest and safest way to install yt-dlp + Homebrew + ffmpeg on any Mac with a single double-click.**

---

## ✨ What This Does

This project provides a professional, polished, one-click installer script (`install-yt-dlp.command`) that automatically sets up everything you need to use **yt-dlp** — the best YouTube and video downloader available — on macOS.

### What gets installed:

- **Homebrew** (the missing package manager for macOS) — if not already present
- **yt-dlp** — the powerful, actively maintained successor to youtube-dl
- **ffmpeg** — required for merging separate audio + video streams and converting formats

The installer works perfectly on both **Apple Silicon (M1/M2/M3/M4)** and **Intel Macs**.

---

## 🚀 Quick Start

1. **Download** the latest `install-yt-dlp.command` file
2. **Double-click** it in Finder (or right-click → Open)
3. Enter your Mac password when prompted (only needed the first time)
4. Wait for the beautiful green **INSTALLATION COMPLETE** banner
5. Press any key to close the window

**That’s it!** Open a new Terminal window and start downloading.

---

## 📋 Example Commands

After installation, you can use these commands in Terminal:

```bash
# Best quality video + audio (merged automatically with ffmpeg)
yt-dlp "https://www.youtube.com/watch?v=..."

# Download audio only and convert to high-quality MP3
yt-dlp -x --audio-format mp3 "https://www.youtube.com/watch?v=..."

# List all available formats before downloading
yt-dlp -F "https://www.youtube.com/watch?v=..."

# Download a specific format
yt-dlp -f "bestvideo[height<=1080]+bestaudio" "https://www.youtube.com/watch?v=..."

# Full help and all options
yt-dlp --help
```

**Tip:** Files are saved to whatever folder your Terminal is currently in.

---

## ✅ Features

- **True one-click experience** — double-click and go
- **Beautiful terminal UI** with colors, progress spinner, and clear messages
- **Smart architecture detection** — works on both Apple Silicon and Intel
- **Safe & idempotent** — safe to run multiple times
- **Avoids dangerous patterns** — does *not* use `curl | bash`
- **Detailed error handling** — shows full output if something fails
- **Automatic shell profile setup** — adds Homebrew to your PATH permanently
- **macOS guard** — clearly tells you if you try to run it on the wrong OS
- **Professional polish** — clean code, versioned releases, and helpful documentation

---

## 🛠 Requirements

- macOS 10.15 (Catalina) or newer (recommended)
- Internet connection (only needed during first install)
- Administrator password (only for the initial Homebrew installation)

---

## 🔧 Troubleshooting

### "Homebrew not found" or permission errors
This is normal on first run. The script will install Homebrew for you. Just enter your Mac password when prompted.

If you ever need to reinstall Homebrew manually:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Command not found after install
Close your current Terminal window and open a **new** one. The script adds Homebrew to your shell profile automatically.

You can also run this manually:
```bash
source ~/.zprofile
```

### ffmpeg install failed
yt-dlp will still work for many downloads. You can install ffmpeg later with:
```bash
brew install ffmpeg
```

### Script window closes too fast
The script is designed to keep the window open. If it closes immediately, run it from Terminal instead:
```bash
cd ~/Downloads
./install-yt-dlp.command
```

### Still having issues?
Run the script from Terminal to see full detailed output:
```bash
cd ~/Downloads
./install-yt-dlp.command
```

---

## 📁 Where Does Everything Go?

| Item              | Location (Apple Silicon)      | Location (Intel)       |
|-------------------|-------------------------------|------------------------|
| Homebrew          | `/opt/homebrew/`              | `/usr/local/`          |
| yt-dlp command    | `/opt/homebrew/bin/yt-dlp`    | `/usr/local/bin/yt-dlp`|
| ffmpeg command    | `/opt/homebrew/bin/ffmpeg`    | `/usr/local/bin/ffmpeg`|
| Downloaded files  | Current working directory     | Current working directory |

---

## 💡 Why Use This Installer?

Most people install yt-dlp by copying random commands from the internet. This often leads to broken setups, PATH issues, or security risks.

This installer solves those problems by:
- Using the **official** Homebrew installer
- Properly handling both Apple Silicon and Intel Macs
- Adding Homebrew to your shell profile the correct way (no duplicates)
- Providing clear, beautiful feedback during installation
- Being fully versioned and maintained

---

## 🤝 Contributing

Found a bug or want to improve the script? Contributions are welcome!

1. Fork the repository
2. Make your changes
3. Test on both Apple Silicon and Intel Macs if possible
4. Open a Pull Request

---

## 📜 License

This project is released under the **MIT License**.

---

## 🙏 Credits

- [yt-dlp](https://github.com/yt-dlp/yt-dlp) — the best video downloader
- [Homebrew](https://brew.sh) — the missing package manager for macOS
- [ffmpeg](https://ffmpeg.org) — the multimedia framework

---

**Enjoy downloading!** 🎥

*Made with care for the macOS community. Last updated: May 2026 — Version 1.2.0*
