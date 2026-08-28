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
      if command -v wl-paste >/dev/null 2>&1; then
        wl-paste
      elif command -v xclip >/dev/null 2>&1; then
        xclip -selection clipboard -o
      elif command -v xsel >/dev/null 2>&1; then
        xsel --clipboard --output
      else
        echo "No clipboard tool found. Install one of: wl-clipboard (Wayland), xclip, or xsel." >&2
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

credentials=$(get_clipboard)

# Check if credentials are available in the clipboard
if [ -z "$credentials" ]; then
  echo "No credentials found in the clipboard. Please copy the credentials and try again."
  exit 1
fi

cd "$SCRIPT_DIR"
python3 aws_profile_updater.py "$profile_name" "$credentials"
