# Configuring enterprise account and account groups

The `enterprise_account_group` input variable allows you to define account groups within your IBM Cloud Enterprise account. Account groups provide a way to organize and manage your accounts hierarchically.

- Variable name: `enterprise_account_group`.
- Type: A list of objects.

  ***NOTE : Allows a maximum of one object representing an account group.***
- Default value: An empty list (`[]`).

### Options for enterprise_account_group

- `key_name` (required): A unique identifier for the account group.
- `name` (required): The display name of the account group.
- `parent_key_name` (optional): The key_name of the parent account group under which this account group will be created. If not provided, it will be created directly under the parent enterprise account.
- `owner_iam_id` (optional): The IAM ID of the user who will be assigned as the owner of this account group.

### Example Configuration for Enterprise Account Groups

```hcl
[
  {
    key_name        = "group-key-1"
    name            = "account_group_1"
    parent_key_name = null
    owner_iam_id    = "IBMid-792000SGMF"
  }
]
```

The `enterprise_account` input variable allows you to define individual accounts to be created under your IBM Cloud Enterprise account or within a specific account group.

- Variable name: `enterprise_account`.
- Type: A list of objects.

***NOTE : Allows a maximum of one object representing an account.***
- Default value: An empty list (`[]`).

### Options for enterprise_account

- `key_name` (required): A unique identifier for the account.
- `name` (required): The display name of the account.
- `parent_key_name` (optional): The key_name of the parent account group under which this account will be created. If not provided, it will be created directly under the enterprise root.
- `owner_iam_id` (optional): The IAM ID of the user who will be assigned as the owner of this account.
- `add_owner_iam_policies` (optional): (Boolean) Enables suba account to have IAM_API_KEY with owner IAM policies. Defaults to `true`.
- `enterprise_iam_managed` (optional): (Boolean) Enable sub accounts to inherit features like trusted profile template and access group template from the parent enterprise account. Defaults to `true`.
- `mfa` (optional): (String) The Multi-Factor Authentication (MFA) requirement for the account. Defaults to `NONE`.

### Example Configuration for Enterprise Accounts

```hcl
[
  {
    key_name               = "acc-key-1"
    name                   = "account_9"
    parent_key_name        = "group-key-1"
    add_owner_iam_policies = true
    owner_iam_id           = "IBMid-692000SGND"
  }
]
```