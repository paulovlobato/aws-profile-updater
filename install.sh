#!/bin/bash
#
# Installer for AWS Profile Updater.
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/paulovlobato/aws-profile-updater/master/install.sh | bash
#
# Installs the scripts to /usr/local/bin and makes the command
# available as `aws-profile-updater` anywhere in your terminal.

set -euo pipefail

INSTALL_DIR="/usr/local/bin"
REPO_RAW="https://raw.githubusercontent.com/paulovlobato/aws-profile-updater/master"

# If we're not root, re-run ourselves with sudo so the install to
# /usr/local/bin succeeds even when piped via `curl ... | bash`.
# (When piped, $0 is "bash", so we re-fetch the script from the URL.)
if [ "$(id -u)" -ne 0 ]; then
  echo "Not running as root, re-running with sudo..."
  exec sudo bash -c "curl -fsSL '$REPO_RAW/install.sh' | bash"
fi

# Download the two scripts into a temp dir, then move them into place.
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

echo "Downloading AWS Profile Updater..."
curl -fsSL "$REPO_RAW/aws_profile_updater.py" -o "$TMP_DIR/aws_profile_updater.py"
curl -fsSL "$REPO_RAW/aws_profile_updater.sh" -o "$TMP_DIR/aws_profile_updater.sh"

echo "Installing to $INSTALL_DIR..."
install -m 0644 "$TMP_DIR/aws_profile_updater.py" "$INSTALL_DIR/aws_profile_updater.py"
install -m 0755 "$TMP_DIR/aws_profile_updater.sh" "$INSTALL_DIR/aws-profile-updater"

echo "Done. You can now run:"
echo "  aws-profile-updater <profile_name>"
