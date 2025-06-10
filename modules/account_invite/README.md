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
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 3.2.1, <4.0.0 |

### Modules

No modules.

### Resources

| Name | Type |
|------|------|
| [null_resource.invite_user](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [ibm_iam_access_group.accgroup](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/data-sources/iam_access_group) | data source |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_existing_access_group_name"></a> [existing\_access\_group\_name](#input\_existing\_access\_group\_name) | The access group name for initial access group for new users | `string` | n/a | yes |
| <a name="input_existing_account_service_id"></a> [existing\_account\_service\_id](#input\_existing\_account\_service\_id) | The sub account service ID. | `string` | n/a | yes |
| <a name="input_ibmcloud_api_key"></a> [ibmcloud\_api\_key](#input\_ibmcloud\_api\_key) | The sub account api key of the enterprise. | `string` | n/a | yes |
| <a name="input_trusted_profile_name"></a> [trusted\_profile\_name](#input\_trusted\_profile\_name) | The trusted profile to be assumed by the sub account. | `string` | n/a | yes |
| <a name="input_users_to_invite"></a> [users\_to\_invite](#input\_users\_to\_invite) | The list of user email IDs to be invited to the sub account of the enterprise. | `list(string)` | n/a | yes |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_invited_users"></a> [invited\_users](#output\_invited\_users) | Invited users |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
