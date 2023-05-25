#!/bin/bash

profile_name=$1
credentials=$(pbpaste)

# Check if profile name is provided
if [ -z "$profile_name" ]; then
  echo "Profile name is missing. Please provide a profile name as the 
first argument."
  exit 1
fi

# Check if credentials are available in the clipboard
if [ -z "$credentials" ]; then
  echo "No credentials found in the clipboard. Please copy the credentials 
and try again."
  exit 1
fi

python3 aws_profile_updater.py "$profile_name" "$credentials"

