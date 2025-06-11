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
| [ibm_iam_trusted_profiles.iam_trusted_profiles](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/data-sources/iam_trusted_profiles) | data source |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_existing_account_id"></a> [existing\_account\_id](#input\_existing\_account\_id) | The ID of the account where the trusted profile for inviting users is created and the users will be invited. | `string` | n/a | yes |
| <a name="input_existing_account_service_id"></a> [existing\_account\_service\_id](#input\_existing\_account\_service\_id) | The service ID of the account which is used to assume the trusted profile with permission (All Identity and Access enabled services) to invite users. | `string` | n/a | yes |
| <a name="input_existing_trusted_profile_name"></a> [existing\_trusted\_profile\_name](#input\_existing\_trusted\_profile\_name) | The trusted profile used to send invite to the users. It needs Administrator access on All Identity and Access enabled services. | `string` | n/a | yes |
| <a name="input_ibmcloud_api_key"></a> [ibmcloud\_api\_key](#input\_ibmcloud\_api\_key) | The apikey used to authenticate to the account in the enterprise where users are to be invited. | `string` | n/a | yes |
| <a name="input_users_to_invite"></a> [users\_to\_invite](#input\_users\_to\_invite) | A list containing the email ID of user to be invited to an enterprise account and the list of access groups that needs to be assigned to the user | <pre>list(object({<br/>    email                   = string<br/>    exisiting_access_groups = list(string)<br/>  }))</pre> | `[]` | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_invited_users"></a> [invited\_users](#output\_invited\_users) | Invited users |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
