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
  enterprise_json_input             = {
                                        account_groups = [{
                                          name = "depth_0_account_group1"
                                        }]
                                        accounts = [{
                                          name = "depth_0_account" },
                                        ]}
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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0, <1.6.0 |
| <a name="requirement_ibm"></a> [ibm](#requirement\_ibm) | >= 1.54.0, < 2.0.0 |

### Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_dynamic_values"></a> [dynamic\_values](#module\_dynamic\_values) | ./submodules/dynamic_values | n/a |
| <a name="module_enterprise_hierarchy_depth_0"></a> [enterprise\_hierarchy\_depth\_0](#module\_enterprise\_hierarchy\_depth\_0) | ./submodules/enterprise_hierarchy | n/a |
| <a name="module_enterprise_hierarchy_depth_1"></a> [enterprise\_hierarchy\_depth\_1](#module\_enterprise\_hierarchy\_depth\_1) | ./submodules/enterprise_hierarchy | n/a |
| <a name="module_enterprise_hierarchy_depth_2"></a> [enterprise\_hierarchy\_depth\_2](#module\_enterprise\_hierarchy\_depth\_2) | ./submodules/enterprise_hierarchy | n/a |

### Resources

No resources.

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enterprise_crn"></a> [enterprise\_crn](#input\_enterprise\_crn) | The CRN of the parent Enterprise account to use. | `string` | n/a | yes |
| <a name="input_enterprise_json_input"></a> [enterprise\_json\_input](#input\_enterprise\_json\_input) | List of enterprise child account groups and account | <pre>list(object({<br>    accounts = optional(list(object({ name = string, owner_iam_id = optional(string, "root") })), [])<br>    account_groups = optional(list(object(<br>      { name     = string,<br>        accounts = optional(list(object({ name = string, owner_iam_id = optional(string, "root") })), [])<br>        account_groups = optional(list(object({<br>          name     = string,<br>          accounts = optional(list(object({ name = string, owner_iam_id = optional(string, "root") })), [])<br>          account_groups = optional(list(object(<br>            { name           = string,<br>              accounts       = optional(list(object({ name = string, owner_iam_id = optional(string, "root") })), [])<br>              account_groups = optional(list(object({ name = string })), [])<br>          })), [])<br>        })), [])<br>    })), [])<br>  }))</pre> | n/a | yes |
| <a name="input_enterprise_primary_contact_iam_id"></a> [enterprise\_primary\_contact\_iam\_id](#input\_enterprise\_primary\_contact\_iam\_id) | The IAM id of the parent Enterprise account owner. | `string` | n/a | yes |

### Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

<!-- Leave this section as is so that your module has a link to local development environment set up steps for contributors to follow -->
## Contributing

You can report issues and request features for this module in GitHub issues in the module repo. See [Report an issue or request a feature](https://github.com/terraform-ibm-modules/.github/blob/main/.github/SUPPORT.md).

To set up your local development environment, see [Local development setup](https://terraform-ibm-modules.github.io/documentation/#/local-dev-setup) in the project documentation.
