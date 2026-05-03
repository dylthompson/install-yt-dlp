#!/bin/bash
#
# install-yt-dlp.command — one-click installer for macOS
# Version: 1.2.0  (2026-05-03)
#
# Installs Homebrew (if missing), yt-dlp, and ffmpeg.
# Works on Apple Silicon and Intel Macs.
# Double-click this file in Finder to run it.
#
# Cleaned-up & polished release.
#

set -u

# ───── macOS guard ─────
if [[ "$(uname -s)" != "Darwin" ]]; then
  printf "\n%s%sThis script is for macOS only!%s\n" "$RED" "$BOLD" "$RESET"
  printf "It will not work on Linux or Windows.\n\n"
  read -n 1 -s -r -p "Press any key to close…"
  echo
  exit 1
fi

# ───── colors / styles ─────
BOLD="$(printf '\033[1m')"
DIM="$(printf '\033[2m')"
GREEN="$(printf '\033[32m')"
YELLOW="$(printf '\033[33m')"
RED="$(printf '\033[31m')"
CYAN="$(printf '\033[36m')"
MAGENTA="$(printf '\033[35m')"
BLUE="$(printf '\033[34m')"
RESET="$(printf '\033[0m')"

say()   { printf "\n%s%s%s\n" "$CYAN$BOLD" "$1" "$RESET"; }
ok()    { printf "  %s✓%s %s\n"  "$GREEN"  "$RESET" "$1"; }
warn()  { printf "  %s!%s %s\n"  "$YELLOW" "$RESET" "$1"; }
fail()  { printf "  %s✗%s %s\n"  "$RED"    "$RESET" "$1"; }

# ───── ASCII spinner ─────
SPIN='|/-\'

spinner() {
  local pid=$1
  local delay=0.1
  local i=0
  local frame
  while kill -0 "$pid" 2>/dev/null; do
    frame="${SPIN:i++%${#SPIN}:1}"
    printf "\r   %s%s%s " "$MAGENTA" "$frame" "$RESET"
    sleep "$delay"
  done
  printf "\r     \r"
}

# ───── run_with_spinner LABEL CMD [ARGS...] ─────
run_with_spinner() {
  local label="$1"; shift
  local tmp; tmp="$(mktemp)"

  printf "  %s%s%s\n" "$DIM" "$label" "$RESET"
  ( "$@" ) > "$tmp" 2>&1 &
  local pid=$!
  spinner "$pid"
  wait "$pid"
  local status=$?

  if [ "$status" -eq 0 ]; then
    ok "done"
  else
    fail "command failed (exit $status):  $*"
    printf "%s─── output ───%s\n" "$DIM" "$RESET"
    cat "$tmp"
    printf "%s──────────────%s\n" "$DIM" "$RESET"
  fi
  rm -f "$tmp"
  return $status
}

# ───── die: print failure context and pause before quitting ─────
die() {
  printf "\n%s%sInstallation aborted.%s  %s\n\n" "$RED" "$BOLD" "$RESET" "$1"
  printf "Open Terminal and run this script from there to see full output.\n\n"
  read -n 1 -s -r -p "Press any key to close…"
  echo
  exit 1
}

clear

# ───── banner ─────
printf "\n"
printf "%s╔════════════════════════════════════════════════════════════╗%s\n" "$BLUE" "$RESET"
printf "%s║%s                                                            %s║%s\n" "$BLUE" "$RESET" "$BLUE" "$RESET"
printf "%s║%s       %s██╗   ██╗████████╗   ██████╗ ██╗     ██████╗ %s        %s║%s\n" "$BLUE" "$RESET" "$BOLD$MAGENTA" "$RESET" "$BLUE" "$RESET"
printf "%s║%s       %s╚██╗ ██╔╝╚══██╔══╝   ██╔══██╗██║     ██╔══██╗%s        %s║%s\n" "$BLUE" "$RESET" "$BOLD$MAGENTA" "$RESET" "$BLUE" "$RESET"
printf "%s║%s        %s╚████╔╝    ██║      ██║  ██║██║     ██████╔╝%s        %s║%s\n" "$BLUE" "$RESET" "$BOLD$MAGENTA" "$RESET" "$BLUE" "$RESET"
printf "%s║%s         %s╚██╔╝     ██║      ██║  ██║██║     ██╔═══╝ %s        %s║%s\n" "$BLUE" "$RESET" "$BOLD$MAGENTA" "$RESET" "$BLUE" "$RESET"
printf "%s║%s          %s██║      ██║      ██████╔╝███████╗██║     %s        %s║%s\n" "$BLUE" "$RESET" "$BOLD$MAGENTA" "$RESET" "$BLUE" "$RESET"
printf "%s║%s          %s╚═╝      ╚═╝      ╚═════╝ ╚══════╝╚═╝     %s        %s║%s\n" "$BLUE" "$RESET" "$BOLD$MAGENTA" "$RESET" "$BLUE" "$RESET"
printf "%s║%s                                                            %s║%s\n" "$BLUE" "$RESET" "$BLUE" "$RESET"
printf "%s║%s               homebrew  ·  yt-dlp  ·  ffmpeg               %s║%s\n" "$BLUE" "$RESET" "$BLUE" "$RESET"
printf "%s║%s                                                            %s║%s\n" "$BLUE" "$RESET" "$BLUE" "$RESET"
printf "%s╚════════════════════════════════════════════════════════════╝%s\n" "$BLUE" "$RESET"

# ───── pick the right Homebrew prefix ─────
ARCH="$(uname -m)"
if [ -x "/opt/homebrew/bin/brew" ]; then
  BREW_PREFIX="/opt/homebrew"
elif [ -x "/usr/local/bin/brew" ]; then
  BREW_PREFIX="/usr/local"
elif [ "$ARCH" = "arm64" ]; then
  BREW_PREFIX="/opt/homebrew"
else
  BREW_PREFIX="/usr/local"
fi

# ───── 1. Homebrew ─────
say "1 / 3   Checking for Homebrew"

if ! command -v brew >/dev/null 2>&1; then
  if [ -x "$BREW_PREFIX/bin/brew" ]; then
    eval "$("$BREW_PREFIX/bin/brew" shellenv)"
    ok "Homebrew found at $BREW_PREFIX (added to PATH for this session)"
  else
    warn "Homebrew not found — installing now."
    warn "macOS may ask for your Mac password during this step."
    HOMEBREW_INSTALLER="$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" \
      || die "Could not download the Homebrew installer (network problem?)."
    /bin/bash -c "$HOMEBREW_INSTALLER" \
      || die "Homebrew install failed — check the messages above."

    SHELLENV_LINE="eval \"\$($BREW_PREFIX/bin/brew shellenv)\""
    touch "$HOME/.zprofile"
    if ! grep -Fxq "$SHELLENV_LINE" "$HOME/.zprofile"; then
      printf "%s\n" "$SHELLENV_LINE" >> "$HOME/.zprofile"
      ok "Added brew to ~/.zprofile so future shells find it."
    fi
    eval "$("$BREW_PREFIX/bin/brew" shellenv)"
    ok "Homebrew installed."
  fi
else
  ok "Homebrew already installed ($(brew --version | head -1))"
fi

printf "  %sUpdating Homebrew formulas…%s\n" "$DIM" "$RESET"
brew update >/dev/null 2>&1 || warn "brew update reported a problem — continuing anyway."
ok "Homebrew is up to date."

# ───── 2. yt-dlp ─────
say "2 / 3   Installing yt-dlp"
if command -v yt-dlp >/dev/null 2>&1; then
  run_with_spinner "Upgrading yt-dlp…" brew upgrade yt-dlp \
    || run_with_spinner "Reinstalling yt-dlp…" brew install yt-dlp \
    || die "Could not install yt-dlp."
else
  run_with_spinner "Installing yt-dlp…" brew install yt-dlp \
    || die "Could not install yt-dlp."
fi
command -v yt-dlp >/dev/null 2>&1 || die "yt-dlp not on PATH after install."
ok "yt-dlp $(yt-dlp --version)"

# ───── 3. ffmpeg ─────
say "3 / 3   Installing ffmpeg (needed for merging audio + video)"
FFMPEG_OK=0
if command -v ffmpeg >/dev/null 2>&1; then
  ok "ffmpeg already installed."
  FFMPEG_OK=1
else
  if run_with_spinner "Installing ffmpeg…" brew install ffmpeg; then
    FFMPEG_OK=1
  else
    warn "ffmpeg install failed — yt-dlp will still work but cannot merge separate audio + video formats."
  fi
fi

# Print ffmpeg version only once (fixed redundancy)
if command -v ffmpeg >/dev/null 2>&1; then
  ok "ffmpeg $(ffmpeg -version 2>&1 | head -n 1 | awk '{print $3}')"
fi

# ───── send-off ─────
printf "\n"
if [ "$FFMPEG_OK" -eq 1 ]; then
  printf "%s╔════════════════════════════════════════════════════════════╗%s\n" "$GREEN" "$RESET"
  printf "%s║%s                                                            %s║%s\n" "$GREEN" "$RESET" "$GREEN" "$RESET"
  printf "%s║%s         %sI N S T A L L A T I O N   C O M P L E T E%s          %s║%s\n" "$GREEN" "$RESET" "$BOLD" "$RESET" "$GREEN" "$RESET"
  printf "%s║%s                                                            %s║%s\n" "$GREEN" "$RESET" "$GREEN" "$RESET"
  printf "%s╚════════════════════════════════════════════════════════════╝%s\n" "$GREEN" "$RESET"
else
  printf "%s╔════════════════════════════════════════════════════════════╗%s\n" "$YELLOW" "$RESET"
  printf "%s║%s                                                            %s║%s\n" "$YELLOW" "$RESET" "$YELLOW" "$RESET"
  printf "%s║%s        %sI N S T A L L E D   —   W I T H   N O T E S%s         %s║%s\n" "$YELLOW" "$RESET" "$BOLD" "$RESET" "$YELLOW" "$RESET"
  printf "%s║%s                                                            %s║%s\n" "$YELLOW" "$RESET" "$YELLOW" "$RESET"
  printf "%s╚════════════════════════════════════════════════════════════╝%s\n" "$YELLOW" "$RESET"
fi
printf "\n"

printf "%sOpen a new Terminal window and try:%s\n\n" "$BOLD" "$RESET"
if [ "$FFMPEG_OK" -eq 1 ]; then
  printf "  %syt-dlp <url>%s                          best quality video\n" "$CYAN" "$RESET"
  printf "  %syt-dlp -x --audio-format mp3 <url>%s    audio only, as mp3\n" "$CYAN" "$RESET"
else
  printf "  %syt-dlp <url>%s                          best single combined file\n" "$CYAN" "$RESET"
  printf "  %s(audio-only and best-quality merged downloads need ffmpeg —%s\n" "$DIM" "$RESET"
  printf "  %s run 'brew install ffmpeg' once it's available.)%s\n" "$DIM" "$RESET"
fi
printf "  %syt-dlp -F <url>%s                       list all available formats\n" "$CYAN" "$RESET"
printf "  %syt-dlp --help%s                         full reference\n" "$CYAN" "$RESET"
printf "\n%sFiles save to your current folder unless you 'cd' somewhere else first.%s\n\n" "$DIM" "$RESET"

read -n 1 -s -r -p "Press any key to close this window…"
echo