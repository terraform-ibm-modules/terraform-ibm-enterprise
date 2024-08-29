# Advanced example

This is a complete example to create enterprise child account with owner IAM policies. This example will create below resources -

Create new enterprise child account-groups.
Create new enterprise child accounts, if `add_owner_iam_policies` field is set in account inputs, account will have  owner IAM policies.
Create a new Secrets Manager instance if one is not passed in and configure it with a private cert engine.
Create a new arbitary secret with the value set as iam_apikey value.
