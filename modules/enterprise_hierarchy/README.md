# Enterprise hierarchy

This module create enterprise child accounts and account groups at multiple depths of an enterprise hierarchy

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_ibm"></a> [ibm](#requirement\_ibm) | >= 1.65.0, < 2.0.0 |

### Modules

No modules.

### Resources

| Name | Type |
|------|------|
| [ibm_enterprise_account.enterprise_account](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/enterprise_account) | resource |
| [ibm_enterprise_account_group.enterprise_account_group](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/enterprise_account_group) | resource |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enterprise_crn"></a> [enterprise\_crn](#input\_enterprise\_crn) | Enterprise CRN | `string` | n/a | yes |
| <a name="input_enterprise_hierarchy"></a> [enterprise\_hierarchy](#input\_enterprise\_hierarchy) | tree based input for creating enterprise children | <pre>map(map(object({<br/>    name                   = string<br/>    parent_key_name        = optional(string, null)<br/>    owner_iam_id           = optional(string, null)<br/>    add_owner_iam_policies = optional(bool, false)<br/>    key_name               = string<br/>    enterprise_iam_managed = optional(bool, true)<br/>    mfa                    = optional(string, "NONE")<br/>  })))</pre> | n/a | yes |
| <a name="input_enterprise_primary_contact_iam_id"></a> [enterprise\_primary\_contact\_iam\_id](#input\_enterprise\_primary\_contact\_iam\_id) | Enterprise owner IAM id | `string` | n/a | yes |
| <a name="input_parent_account_groups"></a> [parent\_account\_groups](#input\_parent\_account\_groups) | account group object | <pre>map(object({<br/>    crn                    = string<br/>    name                   = string<br/>    parent                 = string<br/>    primary_contact_iam_id = string<br/>  }))</pre> | n/a | yes |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_account_groups"></a> [account\_groups](#output\_account\_groups) | enterprise account groups |
| <a name="output_accounts"></a> [accounts](#output\_accounts) | enterprise accounts |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
