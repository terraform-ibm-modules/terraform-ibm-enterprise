# IBM Enterprise Account module

[![Stable (Adopted)](https://img.shields.io/badge/Status-Stable%20(Adopted)-yellowgreen?style=plastic)](https://terraform-ibm-modules.github.io/documentation/#/badge-status)
[![latest release](https://img.shields.io/github/v/release/terraform-ibm-modules/terraform-ibm-enterprise?logo=GitHub&sort=semver)](https://github.com/terraform-ibm-modules/terraform-ibm-enterprise/releases/latest)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)
[![Renovate enabled](https://img.shields.io/badge/renovate-enabled-brightgreen.svg)](https://renovatebot.com/)
[![semantic-release](https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg)](https://github.com/semantic-release/semantic-release)

This is a collection of sub modules and which will take tree based enterprise inputs and create child accounts and account-groups in an enterprise
* [dynamic_values](submodules/dynamic_values)
* [enterprise_hierarchy](submodules/enterprise_hierarchy)

<!-- Below content is automatically populated via pre-commit hook -->
<!-- BEGIN OVERVIEW HOOK -->
## Overview
* [terraform-ibm-enterprise](#terraform-ibm-enterprise)
* [Submodules](./modules)
    * [account_invite](./modules/account_invite)
    * [dynamic_values](./modules/dynamic_values)
    * [enterprise_hierarchy](./modules/enterprise_hierarchy)
* [Examples](./examples)
    * [Advanced example](./examples/advanced)
    * [Basic example](./examples/basic)
* [Contributing](#contributing)
<!-- END OVERVIEW HOOK -->

<!-- This heading should always match the name of the root level module (aka the repo name) -->
## terraform-ibm-enterprise

### Usage

Full examples are in the [examples](./examples/) folder, but basic usage is as follows for creation of enterprise children is

```hcl
provider "ibm" {
  ibmcloud_api_key = "XXXXXXXX" # pragma: allowlist secret
}

data "ibm_enterprises" "enterprise" {
  name = "my-enterprise-account"
}

module "enterprise" {
  source                            = "terraform-ibm-modules/terraform-ibm-enterprise"
  enterprise_crn                    = data.ibm_enterprises.enterprise.enterprises[0].crn
  enterprise_primary_contact_iam_id = data.ibm_enterprises.enterprise.enterprises[0].primary_contact_iam_id
  enterprise_account_groups = [
    {
      key_name        = "group-key-1"
      name            = "account_group_1"
      parent_key_name = null
  }]

  enterprise_accounts = [
    {
      key_name        = "acct-key-1"
      name            = "account_1"
      parent_key_name = null
    }
    {
      key_name        = "acct-key-2"
      name            = "account_2"
      parent_key_name = null
      add_owner_iam_policies =  true # this field enable child account to have IAM_APIKey with owner IAM policies
    }
  ]
                                      }
```

### Required IAM access policies

- Account Management
  - **Enterprise** service
      - `Administrator` platform access

<!-- Below content is automatically populated via pre-commit hook -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.0 |
| <a name="requirement_ibm"></a> [ibm](#requirement\_ibm) | >= 1.65.0, < 2.0.0 |

### Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_dynamic_values"></a> [dynamic\_values](#module\_dynamic\_values) | ./modules/dynamic_values | n/a |
| <a name="module_enterprise_hierarchy_depth_0"></a> [enterprise\_hierarchy\_depth\_0](#module\_enterprise\_hierarchy\_depth\_0) | ./modules/enterprise_hierarchy | n/a |
| <a name="module_enterprise_hierarchy_depth_1"></a> [enterprise\_hierarchy\_depth\_1](#module\_enterprise\_hierarchy\_depth\_1) | ./modules/enterprise_hierarchy | n/a |
| <a name="module_enterprise_hierarchy_depth_2"></a> [enterprise\_hierarchy\_depth\_2](#module\_enterprise\_hierarchy\_depth\_2) | ./modules/enterprise_hierarchy | n/a |

### Resources

No resources.

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enterprise_account_groups"></a> [enterprise\_account\_groups](#input\_enterprise\_account\_groups) | List of enterprise child account\_groups in the enterprise | `list(object({ name = string, key_name = string, parent_key_name = optional(string, null), owner_iam_id = optional(string, null) }))` | `[]` | no |
| <a name="input_enterprise_accounts"></a> [enterprise\_accounts](#input\_enterprise\_accounts) | List of enterprise child accounts in the enterprise | `list(object({ name = string, key_name = string, parent_key_name = optional(string, null), owner_iam_id = optional(string, null), add_owner_iam_policies = optional(bool, false) }))` | `[]` | no |
| <a name="input_enterprise_crn"></a> [enterprise\_crn](#input\_enterprise\_crn) | The CRN of the parent Enterprise account to use. | `string` | n/a | yes |
| <a name="input_enterprise_primary_contact_iam_id"></a> [enterprise\_primary\_contact\_iam\_id](#input\_enterprise\_primary\_contact\_iam\_id) | The IAM id of the parent Enterprise account owner. | `string` | n/a | yes |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_enterprise_account_groups"></a> [enterprise\_account\_groups](#output\_enterprise\_account\_groups) | List of account groups created in an Enterprise |
| <a name="output_enterprise_accounts"></a> [enterprise\_accounts](#output\_enterprise\_accounts) | List of accounts created in an Enterprise |
| <a name="output_enterprise_accounts_iam_response"></a> [enterprise\_accounts\_iam\_response](#output\_enterprise\_accounts\_iam\_response) | List of accounts created in an Enterprise |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

<!-- Leave this section as is so that your module has a link to local development environment set up steps for contributors to follow -->
## Contributing

You can report issues and request features for this module in GitHub issues in the module repo. See [Report an issue or request a feature](https://github.com/terraform-ibm-modules/.github/blob/main/.github/SUPPORT.md).

To set up your local development environment, see [Local development setup](https://terraform-ibm-modules.github.io/documentation/#/local-dev-setup) in the project documentation.
