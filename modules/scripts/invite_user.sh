#!/bin/bash
set -e

# Authenticate with the IBM Cloud CLI using the API key
ibmcloud login --apikey "$API_KEY" --no-region >/dev/null 2>&1

# assume TP
ibmcloud iam trusted-profile-assume "$TRUSTED_PROFILE_ID"

echo "Inviting $USER_EMAIL to account $SERVICE_ID"

# Initialize an empty array to hold command arguments
INVITE_ARGS=("$USER_EMAIL")

# Split the comma-separated access groups into an array
IFS=',' read -ra ACCESS_GROUPS_LIST <<< "$USER_ACCESS_GROUPS"

# Construct the --access-groups arguments
if [ ${#ACCESS_GROUPS_LIST[@]} -gt 0 ]; then
    for group in "${ACCESS_GROUPS_LIST[@]}"; do
        if [ -n "$group" ]; then # Ensure group name is not empty
            # Add --access-groups and the group name as separate elements to the array
            INVITE_ARGS+=("--access-groups" "$group")
        fi
    done
fi

echo "Executing command: ibmcloud account user-invite ${INVITE_ARGS[*]}"
ibmcloud account user-invite "${INVITE_ARGS[@]}"

echo "Invitation process completed for $USER_EMAIL."
