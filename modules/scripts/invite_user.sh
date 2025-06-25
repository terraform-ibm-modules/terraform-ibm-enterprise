#!/bin/bash
set -e

# Authenticate with the IBM Cloud CLI using the API key
ibmcloud login --apikey "$API_KEY" --no-region >/dev/null 2>&1

# Assume TP (Trusted Profile)
ibmcloud iam trusted-profile-assume "$TRUSTED_PROFILE_ID"

echo "Inviting $USER_EMAIL to account $SERVICE_ID"

# Initialize an empty array to hold command arguments
INVITE_ARGS=("$USER_EMAIL")

if [ -n "$USER_ACCESS_GROUPS" ]; then # Check if the string is not empty
    # Add --access-groups and the comma-separated string as a single element
    INVITE_ARGS+=("--access-groups" "$USER_ACCESS_GROUPS")
fi

echo "Executing command: ibmcloud account user-invite ${INVITE_ARGS[*]}"
ibmcloud account user-invite "${INVITE_ARGS[@]}"

echo "Invitation process completed for $USER_EMAIL."
