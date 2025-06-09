#!/bin/bash
set -e

read -ra USER_EMAILS_LIST <<<"$USER_EMAILS"

# Authenticate with the IBM Cloud CLI using the API key
ibmcloud login --apikey "$API_KEY" --no-region >/dev/null 2>&1

# search for trusted-profile ID using profile name
TRUSTED_PROFILE_ID=$(ibmcloud iam trusted-profiles --output json | \
                     jq -r ".[] | select(.name == \"$TRUSTED_PROFILE_NAME\") | .id")

if [ -z "$TRUSTED_PROFILE_ID" ]; then
    echo "Error: Trusted profile with name '$TRUSTED_PROFILE_NAME' not found or ID could not be retrieved."
    exit 1
else
    echo "Successfully found trusted profile ID:  $TRUSTED_PROFILE_ID"
fi

# assume TP
ibmcloud iam trusted-profile-assume "$TRUSTED_PROFILE_ID"

for user_email in "${USER_EMAILS_LIST[@]}"; do
    echo "Inviting $user_email to access group $CREW_INIT_GROUP and account $SERVICE_ID"

    ibmcloud account user-invite "$user_email" --access-groups "$CREW_INIT_GROUP"

done
