# Configuring Enterprise Account and Account Groups

The `enterprise_account_config` input variable allows you to define the configuration for creating a new account within your Enterprise, and optionally, an associated account group as its parent.

- Variable name: `enterprise_account_config`.
- Type: An object.
***Note: This variable defines the configuration for a single account and its optional parent account group.***

### Options for enterprise_account_config

This variable combines configuration for both the account and, if desired, its direct parent account group.

#### Core Account Configuration:

- `key_name` (required, string): A unique identifier for the account.
- `name` (required, string): The display name of the account as it will appear in IBM Cloud.
- `parent_key_name` (optional, string): The key_name of the parent account group under which this account will be created.

If `create_account_group` is `true`, this parent_key_name should match the `account_group_key_name` defined within this same enterprise_account_config.

If not provided (i.e., null), the account will be created directly under the `enterprise root` (as defined by `parent_enterprise_account_crn` for the module).

***Note: If `create_account_group` is `false`, then this variable should be set to null.***

- `owner_iam_id` (optional, string): The IAM ID of the user who will be assigned as the owner of this account. This owner will also be applied to the account group if create_account_group is `true`.
- `add_owner_iam_policies` (optional, boolean): Enables the child account to have an IAM API key with owner IAM policies. Defaults to `true`.
- `enterprise_iam_managed` (optional, boolean): Enables child accounts to inherit features like trusted profile templates and access group templates from the parent enterprise account. Defaults to `true`.
- `mfa` (optional, string): The Multi-Factor Authentication (MFA) requirement for the account. Defaults to `NONE`.

#### Account Group Configuration (Conditional):

These options are relevant when create_account_group is set to `true`.
- `create_account_group` (optional, boolean): Set to true to create an account group as the parent for this account. If true, `account_group_key_name` and `account_group_name` must be provided. Defaults to `false`.
- `account_group_key_name` (optional, string): The unique identifier for the account group that will be created. This should typically match the `parent_key_name` of the account if you intend for this group to be its direct parent.
- `account_group_name` (optional, string): The display name of the account group that will be created.
- `account_group_parent_key_name` (optional, string): The key_name of the parent account group under which the new account group will be created. If not provided (i.e., null), the new account group will be created directly under the enterprise root.

### Example Configuration for enterprise_account_config

1. Creating an Account Directly under the Enterprise Root:

```hcl
{
  key_name               = "my-new-account"
  name                   = "account-1"
  parent_key_name        = null # Creates directly under the enterprise
  owner_iam_id           = "IBMid-1234567890"
  add_owner_iam_policies = true
  enterprise_iam_managed = true
  mfa                    = "NONE"
  create_account_group          = false # Not creating a new account group
  account_group_key_name        = null
  account_group_name            = null
  account_group_parent_key_name = null
}
```

2. Creating an Account within a New Account Group (created by this module):

```hcl
{
  key_name               = "app-dev-account"
  name                   = "account-2"
  parent_key_name        = "dev-team-group" # Links to the new group below
  owner_iam_id           = "IBMid-9876543210"
  add_owner_iam_policies = true
  enterprise_iam_managed = true
  mfa                    = "NONE"

  create_account_group          = true # Instructs the module to create the account group
  account_group_key_name        = "dev-team-group" # Key for the new account group
  account_group_name            = "Development Team Accounts"
  account_group_parent_key_name = null # Creates the group directly under the enterprise
}
```
