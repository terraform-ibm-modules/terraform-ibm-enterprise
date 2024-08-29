# Complete example to create4 enterprise child account with owner IAM policies

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
      key_name        = "group-key"
      name            = "test account_group"
      parent_key_name = null
  }]

  enterprise_accounts = [
    {
      key_name        = "acct-key"
      name            = "test account"
      parent_key_name = null
      add_owner_iam_policies =  true # this field enable child account to have IAM_APIKey with owner IAM policies
    }
  ]
}

```

The output of this module will have enterprise child account will have additional output field `iam_apikey`, which can be used to create resources in child account. To access this `iam_apikey`, we are saving this in `secret manager arbitary secrets` where this field can be accessed.

```
#Create a new SM instance if not using an existing one
module "secrets_manager" {
  source               = "terraform-ibm-modules/secrets-manager/ibm"
  version              = "1.17.8"
  resource_group_id    = null  # default resource group will be selected
  region               = "us-south"
  secrets_manager_name = "${var.prefix}-secrets-manager"
  allowed_network      = "public-and-private"
  sm_service_plan      = "trial"
}

locals {
  sm_guid = module.secrets_manager.secrets_manager_guid
}


module "secrets_manager_arbitrary_secret" {
  source                  = "terraform-ibm-modules/secrets-manager-secret/ibm"
  version                 = "1.3.2"
  region                  = "us-south"
  secrets_manager_guid    = local.sm_guid
  secret_group_id         = null
  secret_name             = "${var.prefix}-arbitrary-secret"
  secret_description      = "Enterprise child IAM_APIKey"
  secret_type             = "arbitrary"
  secret_payload_password = module.enterprise.enterprise_accounts_iam_response[0].iam_apikey # pragma: iam_apikey
  depends_on              = [module.enterprise]
}

```
