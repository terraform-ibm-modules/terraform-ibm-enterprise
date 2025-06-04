# Lookup data from given enterprise account
data "ibm_enterprise_accounts" "enterprise_accounts" {
  name = var.enterprise_account_name
}

# Call root level module to create a hierarchy of enterprise child accounts and account groups
module "enterprise" {
  source                            = "../.."
  enterprise_crn                    = data.ibm_enterprise_accounts.enterprise_accounts.accounts[0].parent
  enterprise_primary_contact_iam_id = data.ibm_enterprise_accounts.enterprise_accounts.accounts[0].owner_iam_id
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

locals {

  sub_account_users_to_invite = {
    "${var.prefix}_account_1" = ["mukul.palit@ibm.com"]
    "${var.prefix}_account_2" = ["mukul.palit@ibm.com"]
  }

  account_ids = [
    for account in module.enterprise.enterprise_accounts_iam_response : account.id
  ]
  # Filter and transform only those accounts whose name matches sub_account_users_to_invite
  matched_account_user_map = {
    for account in module.enterprise.enterprise_accounts_iam_response :
    account.name => {
      users          = local.sub_account_users_to_invite[account.name]
      id             = account.id
      iam_apikey     = account.iam_apikey
      iam_service_id = account.iam_service_id
    }
    if contains(keys(local.sub_account_users_to_invite), account.name)
  }
}

module "invite_user_trusted_profile_template" {
  source                      = "terraform-ibm-modules/trusted-profile/ibm//modules/trusted-profile-template"
  version                     = "3.1.0"
  template_name               = "Invite User Trusted Template"
  template_description        = "Trusted Profile template for Enterpise sub accounts with required access for inviting users"
  profile_name                = "Invite User Trusted Profile"
  profile_description         = "Trusted Profile for Enterpise sub accounts with required access for inviting users"
  identities                  = []
  account_group_ids_to_assign = []
  account_ids_to_assign       = local.account_ids
  policy_templates = [
    {
      name        = "identity-access"
      description = "Policy template for identity services"
      roles       = ["Administrator"]
      attributes = [{
        key      = "service_group_id"
        value    = "IAM" # assigns access to All Identity and Access enabled services
        operator = "stringEquals"
      }]
    }
  ]
}

module "invite_users" {
  source             = "../../modules/subaccount_invite"
  for_each           = local.matched_account_user_map
  account_id         = each.value.id
  users_to_invite    = local.sub_account_users_to_invite
  account_iam_apikey = each.value.iam_apikey
  access_group_name  = "inital-access-group"
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
  version              = "1.19.6"
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
  version                 = "1.4.0"
  region                  = local.sm_region
  secrets_manager_guid    = local.sm_guid
  secret_group_id         = module.secrets_manager_group.secret_group_id
  secret_name             = "${var.prefix}-enterprise-arbitrary-secret"
  secret_description      = "Enterprise child IAM_APIKey"
  secret_type             = "arbitrary"
  secret_payload_password = module.enterprise.enterprise_accounts_iam_response[0].iam_apikey
}
