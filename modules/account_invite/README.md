# Account Invite

This module invites user to an enterprise account.

Features :
* Assigns access group to enterprise account
* Runs a bash script to assume a trusted profile and invite users via their email IDs

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.0 |
| <a name="requirement_ibm"></a> [ibm](#requirement\_ibm) | >= 1.65.0, < 2.0.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 3.2.1 |

### Modules

No modules.

### Resources

| Name | Type |
|------|------|
| [ibm_iam_access_group_template_assignment.iam_access_group_template_assignment_instance](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/iam_access_group_template_assignment) | resource |
| [null_resource.invite_user](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_group_name"></a> [access\_group\_name](#input\_access\_group\_name) | The access group name for initial access group for new users | `string` | n/a | yes |
| <a name="input_access_group_template_id"></a> [access\_group\_template\_id](#input\_access\_group\_template\_id) | The ID of the access group template to be assigned to new user | `string` | n/a | yes |
| <a name="input_access_group_template_version"></a> [access\_group\_template\_version](#input\_access\_group\_template\_version) | The version of the access group template to be assigned to new user | `string` | n/a | yes |
| <a name="input_account_iam_apikey"></a> [account\_iam\_apikey](#input\_account\_iam\_apikey) | The sub account api key of the enterprise. | `string` | n/a | yes |
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | The ID of the sub account in the enterprise. | `string` | n/a | yes |
| <a name="input_account_service_id"></a> [account\_service\_id](#input\_account\_service\_id) | The sub account service ID. | `string` | n/a | yes |
| <a name="input_trusted_profile_name"></a> [trusted\_profile\_name](#input\_trusted\_profile\_name) | The trusted profile to be assumed by the sub account. | `string` | n/a | yes |
| <a name="input_users_to_invite"></a> [users\_to\_invite](#input\_users\_to\_invite) | The list of user email IDs to be invited to each sub account of the enterprise. | `list(string)` | n/a | yes |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_invited_users"></a> [invited\_users](#output\_invited\_users) | Invited users |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
