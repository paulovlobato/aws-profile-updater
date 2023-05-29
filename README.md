# AWS Profile Updater

AWS Profile Updater is a utility script written in Python that helps you update your AWS credentials for a specific profile in the `~/.aws/credentials` file with the credentials copied to your clipboard. It is especially helpful when you frequently switch between AWS profiles and need to update credentials.

## Requirements

- Python 3
- An AWS account and access to AWS IAM to generate security credentials.
- A configured `~/.aws/credentials` file with the profiles you want to update.

## Installation

1. Clone this repository to your local machine.

    ```bash
    git clone https://github.com/paulovlobato/aws-profile-updater.git
    cd aws-profile-updater
    ```

2. Move the script directory to a location that's common for executable scripts, such as `/usr/local/bin`:

    ```bash
    mv /path/to/aws-profile-updater /usr/local/bin
    ```

    Replace `/path/to/aws-profile-updater` with the actual path to your script's directory.

3. Update the PATH environment variable. You can add the following line to your `~/.bash_profile` or `~/.zshrc` file, depending on the shell you are using:

    ```bash
    export PATH=$PATH:/usr/local/bin/aws-profile-updater
    ```

    Then source the file:

    ```bash
    source ~/.bash_profile  # if you use bash shell
    ```

    Or:

    ```bash
    source ~/.zshrc  # if you use zsh shell
    ```

4. Make sure the `update_aws_profile.sh` script is executable. If it isn't, run this command to make it so:

    ```bash
    chmod +x /usr/local/bin/aws-profile-updater/update_aws_profile.sh
    ```

## Usage

1. Clone this repository to your local machine.

    ```bash
    git clone https://github.com/paulovlobato/aws-profile-updater.git
    cd aws-profile-updater
    ```

2. Copy your new AWS credentials to your clipboard. Make sure they are in the following format:

    ```plaintext
    aws_access_key_id = your_access_key
    aws_secret_access_key = your_secret_key
    aws_session_token = your_session_token
    ```

3. Run the `update_aws_profile.sh` shell script with the name of the AWS profile you want to update as the argument. For example:

    ```bash
    chmod +x update_aws_profile.sh
    ./update_aws_profile.sh your_profile_name
    ```

    This script automatically fetches the credentials from your clipboard and passes them to the Python script.

## Details

The Python script `update_aws_profile.py` does the heavy lifting. It takes two command-line arguments: the name of the AWS profile to update, and a string of new AWS credentials. It then updates the specified AWS profile in your `~/.aws/credentials` file with the new credentials. 

The shell script `update_aws_profile.sh` serves as a handy wrapper that fetches the credentials from your clipboard using the `pbpaste` command, and then invokes the Python script with the appropriate arguments.

## Note

Ensure you have the necessary permissions to read and write the `~/.aws/credentials` file.
