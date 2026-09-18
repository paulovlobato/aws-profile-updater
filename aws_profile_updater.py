import sys
import configparser
import os

KEY_NAMES = ('aws_access_key_id', 'aws_secret_access_key', 'aws_session_token')
REQUIRED_KEY_NAMES = ('aws_access_key_id', 'aws_secret_access_key')


def parse_credentials(credentials_str):
    """Parse clipboard text into a dict of lowercase AWS credential keys.

    Accepts both the `key = value` file format and the shell format that the
    AWS console and `aws configure export-credentials` produce, e.g.
    `export AWS_ACCESS_KEY_ID="ASIA..."`.
    """
    credentials = {}
    for line in credentials_str.splitlines():
        line = line.strip()
        if line.startswith('export '):
            line = line[len('export '):].strip()
        if '=' not in line:
            continue
        key, value = line.split('=', 1)
        key = key.strip().lower()
        value = value.strip().strip('"').strip("'")
        if key in KEY_NAMES:
            credentials[key] = value
    return credentials


def update_aws_credentials(profile_name, credentials_str):
    creds_file_path = os.path.expanduser('~/.aws/credentials')
    parser = configparser.ConfigParser()
    parser.read(creds_file_path)

    credentials = parse_credentials(credentials_str)

    missing = [key for key in REQUIRED_KEY_NAMES if not credentials.get(key)]
    if missing:
        print(f"Could not find {', '.join(missing)} in the clipboard contents.")
        sys.exit(1)

    if profile_name not in parser.sections():
        print(f"No such profile {profile_name} exists in the credentials file.")
        sys.exit(1)

    for key in KEY_NAMES:
        if credentials.get(key):
            parser[profile_name][key] = credentials[key]

    with open(creds_file_path, 'w') as f:
        parser.write(f)
    print(f"Credentials for profile {profile_name} updated.")

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("You must provide 2 parameters: profile_name and credentials.")
        sys.exit(1)

    profile_name = sys.argv[1]
    credentials_str = sys.argv[2]
    update_aws_credentials(profile_name, credentials_str)
