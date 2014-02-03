#! /bin/bash

# This script assumes the controller's SSH key is in the same directory as itself
# See https://github.com/ideasonpurpose/ansible-playbooks for more info

# Check for the public key, fail if it's not there
if [ ! -f id_dsa.pub ]; then
    echo 'id_dsa.pub Key not found'
    exit 1
fi

# Create the .ssh directory if it doesn't exist
mkdir -p ~/.ssh
chmod 0700 ~/.ssh

# Append the transferred public key to authorized_keys (or create the file with the key)
cat id_dsa.pub >> .ssh/authorized_keys
chmod 0600 .ssh/authorized_keys

# Remove the public key
rm id_dsa.pub
