# AWS Profile Updater

AWS Profile Updater is a utility script written in Python that helps you update your AWS credentials for a specific profile in the `~/.aws/credentials` file with the credentials copied to your clipboard. It is especially helpful when you frequently switch between AWS profiles and need to update credentials.

## Requirements

- Python 3
- An AWS account and access to AWS IAM to generate security credentials.
- A configured `~/.aws/credentials` file with the profiles you want to update.
- A clipboard tool for your operating system (see [Clipboard support](#clipboard-support)).

## Installation

Install with a single command:

```bash
curl -fsSL https://raw.githubusercontent.com/paulovlobato/aws-profile-updater/master/install.sh | bash
```

This downloads the scripts, installs them to `/usr/local/bin`, and makes the command available as `aws-profile-updater` anywhere in your terminal.

> **Note:** The installer writes to `/usr/local/bin`, so it may prompt for your password (or you may need to run it with `sudo`).

## Usage

1. Copy your new AWS credentials to your clipboard. Either of these formats works:

    ```plaintext
    [profile_name]
    aws_access_key_id = your_access_key
    aws_secret_access_key = your_secret_key
    aws_session_token = your_session_token
    ```

    ```bash
    export AWS_ACCESS_KEY_ID="your_access_key"
    export AWS_SECRET_ACCESS_KEY="your_secret_key"
    export AWS_SESSION_TOKEN="your_session_token"
    ```

    The second format is what the AWS console and `aws configure export-credentials` produce, so it can be copied straight from there.

2. Run the `aws-profile-updater` anywhere in your terminal, with the name of the AWS profile you want to update as the argument. For example:

    ```bash
    aws-profile-updater profile_name
    ```

    This script automatically fetches the credentials from your clipboard and passes them to the Python script.

## Clipboard support

The wrapper script automatically detects your operating system and uses the appropriate clipboard tool:

| OS | Tool |
|----|------|
| macOS | `pbpaste` (built-in) |
| Linux (Wayland) | `wl-paste` (from `wl-clipboard`) |
| Linux (X11) | `xclip` or `xsel` |
| Windows (Git Bash / WSL) | `powershell.exe Get-Clipboard` |

On Linux, if none of these tools are installed, the script will tell you which one to install. For example, on Debian/Ubuntu:

```bash
sudo apt install xclip        # X11
sudo apt install wl-clipboard # Wayland
```

On a Wayland session, install `wl-clipboard`. Falling back to `xclip` there can fail with `Error: target STRING not available`, because apps only publish the clipboard as `UTF8_STRING`.

## Details

The Python script `aws_profile_updater.py` does the heavy lifting. It takes two command-line arguments: the name of the AWS profile to update, and a string of new AWS credentials. It then updates the specified AWS profile in your `~/.aws/credentials` file with the new credentials.

The shell script `aws_profile_updater.sh` serves as a handy wrapper that fetches the credentials from your clipboard using the appropriate tool for your operating system, and then invokes the Python script with the appropriate arguments.

## Note

Ensure you have the necessary permissions to read and write the `~/.aws/credentials` file.

Also make sure that the profile name is already present in your `~/.aws/credentials` file. The script won't create any new profiles in there, only find the profile and update the credentials.
