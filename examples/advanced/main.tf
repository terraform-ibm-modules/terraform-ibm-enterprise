# Lookup data from given enterprise account
data "ibm_enterprises" "enterprise" {
  name = var.enterprise_name
}

# Call root level module to create a hierarchy of enterprise child accounts and account groups
module "enterprise" {
  source                            = "../.."
  enterprise_crn                    = data.ibm_enterprises.enterprise.enterprises[0].crn
  enterprise_primary_contact_iam_id = data.ibm_enterprises.enterprise.enterprises[0].primary_contact_iam_id
  enterprise_account_groups = [
    {
      key_name        = "${var.prefix}-group-key-1"
      name            = "${var.prefix}_account_group_1"
      parent_key_name = null
    },
    {
      key_name        = "${var.prefix}-group-key-2"
      name            = "${var.prefix}_account_group_2"
      parent_key_name = "${var.prefix}-group-key-1"
  }]
  enterprise_accounts = [
    {
      key_name               = "${var.prefix}-acc-key-1"
      name                   = "${var.prefix}_account_1"
      parent_key_name        = null
      add_owner_iam_policies = true # this field enable child account to have IAM_APIKey with owner IAM policies
    },
    {
      key_name        = "${var.prefix}-acc-key-2"
      name            = "${var.prefix}_account_2"
      parent_key_name = null
    }
  ]
}

########################################################################################################################
# Locals
########################################################################################################################

locals {
  sm_guid   = var.existing_sm_instance_guid == null ? module.secrets_manager[0].secrets_manager_guid : var.existing_sm_instance_guid
  sm_region = var.existing_sm_instance_region == null ? var.region : var.existing_sm_instance_region
}


########################################################################################################################
# Resource Group
########################################################################################################################

module "resource_group" {
  source  = "terraform-ibm-modules/resource-group/ibm"
  version = "1.1.6"
  # if an existing resource group is not set (null) create a new one using prefix
  resource_group_name          = var.resource_group == null ? "${var.prefix}-resource-group" : null
  existing_resource_group_name = var.resource_group
}

########################################################################################################################
# Secrets Manager resources
########################################################################################################################

#Create a new SM instance if not using an existing one
module "secrets_manager" {
  source               = "terraform-ibm-modules/secrets-manager/ibm"
  version              = "1.17.10"
  count                = var.existing_sm_instance_guid == null ? 1 : 0
  resource_group_id    = module.resource_group.resource_group_id
  region               = local.sm_region
  secrets_manager_name = "${var.prefix}-secrets-manager"
  allowed_network      = "public-and-private"
  sm_service_plan      = "trial"
}

# Create a secret group to place the certificate in
module "secrets_manager_group" {
  source                   = "terraform-ibm-modules/secrets-manager-secret-group/ibm"
  version                  = "1.2.2"
  region                   = local.sm_region
  secrets_manager_guid     = local.sm_guid
  secret_group_name        = "${var.prefix}-certs"
  secret_group_description = "A secret group to store private certs"
  providers = {
    ibm = ibm.ibm-sm
  }
}

module "secrets_manager_arbitrary_secret" {
  source                  = "terraform-ibm-modules/secrets-manager-secret/ibm"
  version                 = "1.3.2"
  region                  = local.sm_region
  secrets_manager_guid    = local.sm_guid
  secret_group_id         = module.secrets_manager_group.secret_group_id
  secret_name             = "${var.prefix}-enterprise-arbitrary-secret"
  secret_description      = "Enterprise child IAM_APIKey"
  secret_type             = "arbitrary"
  secret_payload_password = module.enterprise.enterprise_accounts_iam_response[0].iam_apikey
}
