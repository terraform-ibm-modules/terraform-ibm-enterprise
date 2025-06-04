#!/bin/bash
# set -x # Enable while debugging to enable a mode of the shell where all executed commands are printed to the terminal.
set -e

read -ra USER_EMAILS_LIST <<<"$USER_EMAILS"

# Authenticate with the IBM Cloud CLI using the API key
ibmcloud login --apikey "$API_KEY" --no-region >/dev/null 2>&1

for user_email in "${USER_EMAILS_LIST[@]}"; do
    ibmcloud account user-invite "$user_email" --access-groups "$CREW_INIT_GROUP"
done
