#!/bin/bash

profile_name=$1

# Resolve the real location of this script, following symlinks (portable across macOS/Linux)
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do
  DIR="$(cd -P "$(dirname "$SOURCE")" && pwd)"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
SCRIPT_DIR="$(cd -P "$(dirname "$SOURCE")" && pwd)"

# Check if profile name is provided
if [ -z "$profile_name" ]; then
  echo "Profile name is missing. Please provide a profile name as the first argument."
  exit 1
fi

# Fetch clipboard contents using the tool appropriate for the operating system
get_clipboard() {
  case "$(uname -s)" in
    Darwin)
      pbpaste
      ;;
    Linux)
      # Prefer the native Wayland tool. Under Wayland, XWayland apps often
      # advertise only UTF8_STRING, which makes a plain `xclip -o` fail with
      # "target STRING not available", so ask for that target explicitly first.
      if command -v wl-paste >/dev/null 2>&1; then
        wl-paste 2>/dev/null
      elif command -v xclip >/dev/null 2>&1; then
        xclip -selection clipboard -o -t UTF8_STRING 2>/dev/null ||
          xclip -selection clipboard -o 2>/dev/null
      elif command -v xsel >/dev/null 2>&1; then
        xsel --clipboard --output 2>/dev/null
      else
        if [ "${XDG_SESSION_TYPE:-}" = "wayland" ] || [ -n "${WAYLAND_DISPLAY:-}" ]; then
          echo "No clipboard tool found. Install wl-clipboard: sudo apt install wl-clipboard" >&2
        else
          echo "No clipboard tool found. Install one of: wl-clipboard (Wayland), xclip, or xsel." >&2
        fi
        return 1
      fi
      ;;
    MINGW*|MSYS*|CYGWIN*)
      powershell.exe -command "Get-Clipboard"
      ;;
    *)
      echo "Unsupported operating system: $(uname -s)" >&2
      return 1
      ;;
  esac
}

if ! credentials=$(get_clipboard) || [ -z "$credentials" ]; then
  echo "No credentials found in the clipboard. Please copy the credentials and try again."
  exit 1
fi

cd "$SCRIPT_DIR"
python3 aws_profile_updater.py "$profile_name" "$credentials"
