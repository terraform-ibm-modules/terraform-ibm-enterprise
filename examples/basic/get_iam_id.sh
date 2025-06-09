#!/bin/bash

# Read input from stdin (Terraform's 'query' arguments)
eval "$(jq -r '@sh "export IBMCLOUD_API_KEY=\(.ibmcloud_api_key) export IBMCLOUD_ACCOUNT_ID=\(.ibmcloud_account_id)"')"

if [ -z "$IBMCLOUD_API_KEY" ]; then
    echo "Error: IBMCLOUD_API_KEY not provided." >&2
    exit 1
fi

if [ -z "$IBMCLOUD_ACCOUNT_ID" ]; then
    echo "Error: IBMCLOUD_ACCOUNT_ID not provided. Please specify the target account ID." >&2
    exit 1
fi

LOGIN_OUTPUT=$(ibmcloud login --apikey "$IBMCLOUD_API_KEY" -c "$IBMCLOUD_ACCOUNT_ID" --no-region 2>&1)

LOGIN_STATUS=$?

if [ $LOGIN_STATUS -ne 0 ]; then
    echo "Error logging in to IBM Cloud." >&2
    echo "Error details: $LOGIN_OUTPUT" >&2
    exit 1
fi

# Retrieve IAM token
IAM_TOKEN_FULL_OUTPUT=$(ibmcloud iam oauth-tokens --output json 2>&1)
IAM_TOKEN_STATUS=$?

if [ $IAM_TOKEN_STATUS -ne 0 ]; then
    echo "Error retrieving IAM tokens. Ensure you are logged in." >&2
    echo "Error details: $IAM_TOKEN_FULL_OUTPUT" >&2
    exit 1
fi

# Extract the access token using jq
IAM_ACCESS_TOKEN=$(echo "$IAM_TOKEN_FULL_OUTPUT" | jq -r '.iam_token')

if [ -z "$IAM_ACCESS_TOKEN" ] || [ "$IAM_ACCESS_TOKEN" == "null" ]; then
    echo "Error: Could not extract IAM access token from the output." >&2
    echo "Raw token output: $IAM_TOKEN_FULL_OUTPUT" >&2
    exit 1
fi

# Decode the IAM token to get the 'iam_id' (which is typically the 'sub' claim)
IAM_ID=$(echo "$IAM_ACCESS_TOKEN" | cut -d'.' -f2 | base64 --decode 2>/dev/null | jq -r '.iam_id // .sub')

if [ -z "$IAM_ID" ] || [ "$IAM_ID" == "null" ]; then
    echo "Error: Could not extract IAM ID from the token. The 'iam_id' or 'sub' claim might be missing or the token structure is unexpected." >&2
    exit 1
fi

# Output the IAM ID as a JSON object to stdout
jq -n --arg iam_id "$IAM_ID" '{"iam_id": $iam_id}'
