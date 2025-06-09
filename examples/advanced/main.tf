# Lookup data from given enterprise account
data "ibm_enterprise_accounts" "enterprise_accounts" {
  name = var.enterprise_account_name
}

# Fetch the IBM_id from cloud api key to be used as the owner for the new sub accounts to be created
data "external" "get_iam_id" {
  program = ["bash", "-c", "chmod +x ${path.module}/get_iam_id.sh && ${path.module}/get_iam_id.sh"]

  query = {
    ibmcloud_api_key    = var.ibmcloud_api_key
    ibmcloud_account_id = var.ibmcloud_enterprise_account_id
  }
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
      owner_iam_id    = data.external.get_iam_id.result.iam_id
    },
    {
      key_name        = "${var.prefix}-group-key-2"
      name            = "${var.prefix}_account_group_2"
      parent_key_name = "${var.prefix}-group-key-1"
      owner_iam_id    = data.external.get_iam_id.result.iam_id
  }]
  enterprise_accounts = [
    {
      key_name               = "${var.prefix}-account-key-1"
      name                   = "${var.prefix}_account_1"
      parent_key_name        = null
      add_owner_iam_policies = true # this field enable child account to have IAM_APIKey with owner IAM policies
      owner_iam_id           = data.external.get_iam_id.result.iam_id
    },
    {
      key_name               = "${var.prefix}-account-key-2"
      name                   = "${var.prefix}_account_2"
      parent_key_name        = null
      add_owner_iam_policies = true
      owner_iam_id           = data.external.get_iam_id.result.iam_id
    },
    {
      key_name               = "${var.prefix}-account-key-3"
      name                   = "${var.prefix}_account_3"
      parent_key_name        = null
      add_owner_iam_policies = true
      owner_iam_id           = data.external.get_iam_id.result.iam_id
    }
  ]
}

########################################################################################################################
# Trusted Profile and Access Group Template
########################################################################################################################

locals {

  sub_account_users_to_invite = {
    "${var.prefix}_account_1" = ["mukul.palit@ibm.com", "vipin.kumar17@ibm.com", "aayush.abhyarthi@ibm.com"]
    "${var.prefix}_account_3" = ["mukul.palit@ibm.com", "aashiq.jacob@ibm.com", "arya.girish.k@ibm.com"]
  }

  filtered_enterprise_accounts = [
    for account in module.enterprise.enterprise_accounts_iam_response :
    account if contains(keys(local.sub_account_users_to_invite), account.name)
  ]
}

module "create_trusted_profile_template" {
  source               = "terraform-ibm-modules/trusted-profile/ibm//modules/trusted-profile-template"
  version              = "3.1.0"
  template_name        = "enable-service-id-to-invite-users-template"
  template_description = "Trusted Profile template for Enterpise with required access for inviting users"
  profile_name         = var.trusted_profile_name
  profile_description  = "Trusted Profile for Enterpise sub accounts with required access for inviting users"
  identities = [
    for account in local.filtered_enterprise_accounts : {
      type       = "serviceid"
      iam_id     = account.iam_service_id
      identifier = replace(account.iam_service_id, "iam-", "")
    }
  ]
  account_group_ids_to_assign = []
  account_ids_to_assign       = []
  policy_templates = [
    {
      name        = "iam-admin-access"
      description = "Grants Administrator role to all Identity and Access enabled services (IAM service group)."
      roles       = ["Administrator"]
      attributes = [{
        key      = "service_group_id"
        value    = "IAM" # assigns access to All Identity and Access enabled services
        operator = "stringEquals"
      }]
    }
  ]
}

resource "time_sleep" "sleep_time" {
  depends_on      = [module.create_trusted_profile_template]
  create_duration = "60s"
}

# Since the number of sub accounts created is not known during the planning phase therefore assignment has to be done separately
resource "ibm_iam_trusted_profile_template_assignment" "account_assignment_for_new_accounts" {
  depends_on = [time_sleep.sleep_time, module.enterprise]
  count      = length(local.filtered_enterprise_accounts)

  template_id      = module.create_trusted_profile_template.trusted_profile_template_id
  template_version = module.create_trusted_profile_template.trusted_profile_template_version
  target           = local.filtered_enterprise_accounts[count.index].id
  target_type      = "Account"

  provisioner "local-exec" {
    command = "echo Assigned template to Account: ${local.filtered_enterprise_accounts[count.index].id}"
  }
}

# Creating access group template with all the initial access needed for the new user
module "create_initial_access" {
  source                            = "../../modules/initial_new_user_access"
  access_group_template_name        = "initial-access-group-template"
  access_group_template_description = "The access group template for sub accounts to assign access to new users being invited to the sub account"
  access_group_name                 = "new-user-access"
  access_group_description          = "The access group to be assigned to the new users being invited to the sub account"
}

########################################################################################################################
# Inviting Users to Sub Account
########################################################################################################################

module "invite_users" {
  depends_on                    = [module.enterprise, module.create_trusted_profile_template, ibm_iam_trusted_profile_template_assignment.account_assignment_for_new_accounts, module.create_initial_access]
  source                        = "../../modules/subaccount_invite"
  for_each                      = { for account in local.filtered_enterprise_accounts : account.name => account }
  account_id                    = each.value.id
  users_to_invite               = local.sub_account_users_to_invite[each.key]
  account_iam_apikey            = each.value.iam_apikey
  account_service_id            = replace(each.value.iam_service_id, "iam-", "")
  access_group_name             = module.create_initial_access.template_access_group_name
  access_group_template_id      = module.create_initial_access.template_id
  access_group_template_version = module.create_initial_access.template_version
  trusted_profile_name          = var.trusted_profile_name
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
