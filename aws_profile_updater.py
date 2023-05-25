import sys
import configparser
import os

def update_aws_credentials(profile_name, credentials_str):
    creds_file_path = os.path.expanduser('~/.aws/credentials')
    parser = configparser.ConfigParser()
    parser.read(creds_file_path)

    # Split the credentials string into separate lines and then split each line into key and value
    # credentials = dict(line.split('=') for line in credentials_str.split('\n') if line)
    credentials = {}
    for line in credentials_str.split('\n'):
        if line and '=' in line:
            key, value = line.split('=', 1)
            credentials[key] = value.strip()

    if profile_name in parser.sections():
        if 'aws_access_key_id' in credentials:
            parser[profile_name]['aws_access_key_id'] = credentials['aws_access_key_id'].strip()
        if 'aws_secret_access_key' in credentials:
            parser[profile_name]['aws_secret_access_key'] = credentials['aws_secret_access_key'].strip()
        if 'aws_session_token' in credentials:
            parser[profile_name]['aws_session_token'] = credentials['aws_session_token'].strip()

        with open(creds_file_path, 'w') as f:
            parser.write(f)
        print(f"Credentials for profile {profile_name} updated.")
    else:
        print(f"No such profile {profile_name} exists in the credentials file.")

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("You must provide 2 parameters: profile_name and credentials.")
        sys.exit(1)

    profile_name = sys.argv[1]
    credentials_str = sys.argv[2]
    update_aws_credentials(profile_name, credentials_str)
