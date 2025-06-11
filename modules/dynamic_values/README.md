# Dynamic values

This module will simplify the nested enterprise input json and create input for each level(Depth) in enterprise hierarchy

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_ibm"></a> [ibm](#requirement\_ibm) | >= 1.65.0, < 2.0.0 |

### Modules

No modules.

### Resources

No resources.

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enterprise_account_groups"></a> [enterprise\_account\_groups](#input\_enterprise\_account\_groups) | List of enterprise child account\_groups in the enterprise | `list(object({ name = string, key_name = string, parent_key_name = optional(string, null), owner_iam_id = optional(string, null) }))` | `[]` | no |
| <a name="input_enterprise_accounts"></a> [enterprise\_accounts](#input\_enterprise\_accounts) | List of enterprise child accounts in the enterprise | `list(object({ name = string, key_name = string, parent_key_name = optional(string, null), owner_iam_id = optional(string, null), add_owner_iam_policies = optional(bool, false) }))` | `[]` | no |
| <a name="input_enterprise_crn"></a> [enterprise\_crn](#input\_enterprise\_crn) | Enterprise CRN | `string` | n/a | yes |
| <a name="input_enterprise_primary_contact_iam_id"></a> [enterprise\_primary\_contact\_iam\_id](#input\_enterprise\_primary\_contact\_iam\_id) | Enterprise owner IAM id | `string` | n/a | yes |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_enterprise_hierarchy_depth_0"></a> [enterprise\_hierarchy\_depth\_0](#output\_enterprise\_hierarchy\_depth\_0) | n/a |
| <a name="output_enterprise_hierarchy_depth_1"></a> [enterprise\_hierarchy\_depth\_1](#output\_enterprise\_hierarchy\_depth\_1) | n/a |
| <a name="output_enterprise_hierarchy_depth_2"></a> [enterprise\_hierarchy\_depth\_2](#output\_enterprise\_hierarchy\_depth\_2) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
