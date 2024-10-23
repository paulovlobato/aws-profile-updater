# AWS Profile Updater

AWS Profile Updater is a utility script written in Python that helps you update your AWS credentials for a specific profile in the `~/.aws/credentials` file with the credentials copied to your clipboard. It is especially helpful when you frequently switch between AWS profiles and need to update credentials.

## Requirements

- Python 3
- An AWS account and access to AWS IAM to generate security credentials.
- A configured `~/.aws/credentials` file with the profiles you want to update.

## Installation

1. Clone this repository to your local machine.

    ```bash
    $ git clone https://github.com/paulovlobato/aws-profile-updater.git
    ```

2. Move the script directory to a location that's common for executable scripts, such as `/usr/local/bin`:

    ```bash
    $ sudo mv /path/to/aws-profile-updater /usr/local/bin/aws_profile_updater
    ```

    Replace `/path/to/aws-profile-updater` with the actual path to your script's directory.

3. Make the `update_aws_profile.sh` script executable:

    ```bash
    $ sudo chmod +x /usr/local/bin/aws_profile_updater/update_aws_profile.sh
    ```

4. Create a symbolic link for the script into your `/bin` folder, so you can run it anywhere from your terminal:
   
    ```
    $ sudo ln -s /usr/local/bin/aws_profile_updater/aws-profile-updater.sh /usr/local/bin/aws-profile-updater
    ```
## Usage

1. Copy your new AWS credentials to your clipboard. Make sure they are in the following format:

    ```plaintext
    [profile_name]
    aws_access_key_id = your_access_key
    aws_secret_access_key = your_secret_key
    aws_session_token = your_session_token
    ```

2. Run the `aws-profile-updater` anywhere in your terminal, with the name of the AWS profile you want to update as the argument. For example:

    ```bash
    aws-profile-updater profile_name
    ```

    This script automatically fetches the credentials from your clipboard and passes them to the Python script.

## Details

The Python script `update_aws_profile.py` does the heavy lifting. It takes two command-line arguments: the name of the AWS profile to update, and a string of new AWS credentials. It then updates the specified AWS profile in your `~/.aws/credentials` file with the new credentials. 

The shell script `update_aws_profile.sh` serves as a handy wrapper that fetches the credentials from your clipboard using the `pbpaste` command, and then invokes the Python script with the appropriate arguments.

## Note

Ensure you have the necessary permissions to read and write the `~/.aws/credentials` file.

Also make sure that the profile name is already present in your `~/.aws/credentials` file. The script won't create any new profiles in there, only find the profile and update the credentials.
