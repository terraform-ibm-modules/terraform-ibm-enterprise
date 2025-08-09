# Lookup data from given enterprise account name
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
      owner_iam_id    = var.owner_iam_id
    },
    {
      key_name        = "${var.prefix}-group-key-2"
      name            = "${var.prefix}_account_group_2"
      parent_key_name = "${var.prefix}-group-key-1"
      owner_iam_id    = var.owner_iam_id
  }]
  enterprise_accounts = [
    {
      key_name               = "${var.prefix}-acc-key-1"
      name                   = "${var.prefix}_account_1"
      parent_key_name        = null
      add_owner_iam_policies = true # this field enable child account to have IAM_APIKey with owner IAM policies
      owner_iam_id           = var.owner_iam_id
    },
    {
      key_name               = "${var.prefix}-acc-key-2"
      name                   = "${var.prefix}_account_2"
      parent_key_name        = null
      add_owner_iam_policies = true
      owner_iam_id           = var.owner_iam_id
    }
  ]
}

########################################################################################################################
# Trusted Profile Template and Template Assignment
########################################################################################################################

locals {
  enterprise_accounts_by_iam_id = {
    for account in module.enterprise.enterprise_accounts_iam_response :
    account.iam_service_id => account
  }

  sorted_iam_service_ids = sort(keys(local.enterprise_accounts_by_iam_id))

  # sorting the enterprise accounts in order so that the identities order do not change in trusted policy template
  sorted_enterprise_accounts_data = [
    for id in local.sorted_iam_service_ids :
    local.enterprise_accounts_by_iam_id[id]
  ]
}

module "create_trusted_profile_template" {
  source               = "terraform-ibm-modules/trusted-profile/ibm//modules/trusted-profile-template"
  version              = "3.1.1"
  template_name        = "${var.prefix}-enable-service-id-to-invite-users-template"
  template_description = "Trusted Profile template for Enterprise with required access for inviting users"
  profile_name         = "${var.prefix}-enable-service-id-to-invite-users"
  profile_description  = "Trusted Profile for Enterprise sub accounts with required access for inviting users"
  identities = [
    for account in local.sorted_enterprise_accounts_data : {
      type       = "serviceid"
      iam_id     = account.iam_service_id
      identifier = replace(account.iam_service_id, "iam-", "")
    }
  ]
  account_group_ids_to_assign = []
  account_ids_to_assign       = []
  policy_templates = [
    {
      name        = "${var.prefix}-iam-admin-access"
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

# Temp workaround for : https://github.com/terraform-ibm-modules/terraform-ibm-trusted-profile/issues/192
# Since the number of sub accounts created is not known during the planning phase therefore assignment has to be done separately
# and sometimes throws out error that the template cannot be assigned as it is in locked state.
resource "time_sleep" "sleep_time" {
  depends_on      = [module.create_trusted_profile_template]
  create_duration = "60s"
}

resource "ibm_iam_trusted_profile_template_assignment" "account_assignment_for_new_accounts" {
  depends_on = [time_sleep.sleep_time]
  count      = length(module.enterprise.enterprise_accounts_iam_response)

  template_id      = module.create_trusted_profile_template.trusted_profile_template_id
  template_version = module.create_trusted_profile_template.trusted_profile_template_version
  target           = module.enterprise.enterprise_accounts_iam_response[count.index].id
  target_type      = "Account"

  provisioner "local-exec" {
    command = "echo Assigned template to Account: ${module.enterprise.enterprise_accounts_iam_response[count.index].id}"
  }
}

########################################################################################################################
# IAM Policy Template, Access Group Template and Template Assignment
########################################################################################################################

resource "ibm_iam_policy_template" "init_service_id_user_api_key_creator_policy_template" {
  name        = "${var.prefix}-init-service-id-user-api-key-creator-policy"
  description = "Policy template for service ID and user API key creation."
  committed   = true

  policy {
    type  = "access"
    roles = ["Viewer"]
    resource {
      attributes {
        key      = "serviceName"
        value    = "iam-identity"
        operator = "stringEquals"
      }
    }
  }
}

resource "ibm_iam_access_group_template" "initial_access_group_template" {
  depends_on = [
    ibm_iam_policy_template.init_service_id_user_api_key_creator_policy_template
  ]

  name        = "${var.prefix}-initial-access-group-template"
  description = "The access group template for sub accounts to assign access to new users being invited to the sub account"
  group {
    name        = "${var.prefix}-new-user-access"
    description = "The access group to be assigned to the new users being invited to the sub account"
    action_controls {
      access {
        add = true
      }
    }
    members {
      action_controls {
        add    = true
        remove = true
      }
    }
  }

  policy_template_references {
    id      = split("/", ibm_iam_policy_template.init_service_id_user_api_key_creator_policy_template.id)[0]
    version = ibm_iam_policy_template.init_service_id_user_api_key_creator_policy_template.version
  }
  committed = true
}

resource "ibm_iam_access_group_template_assignment" "iam_access_group_template_assignment_instance" {
  depends_on = [
    module.enterprise,
    ibm_iam_access_group_template.initial_access_group_template
  ]
  for_each         = { for account in module.enterprise.enterprise_accounts_iam_response : account.name => account }
  target           = each.value.id
  target_type      = "Account"
  template_id      = split("/", ibm_iam_access_group_template.initial_access_group_template.id)[0]
  template_version = ibm_iam_access_group_template.initial_access_group_template.version
}

########################################################################################################################
# Inviting Users to Sub Account
########################################################################################################################

module "invite_users_account_1" {
  providers = {
    ibm = ibm.account-1
  }
  depends_on = [
    ibm_iam_trusted_profile_template_assignment.account_assignment_for_new_accounts,
    ibm_iam_access_group_template_assignment.iam_access_group_template_assignment_instance
  ]
  source                        = "../../modules/account_invite"
  ibmcloud_api_key              = module.enterprise.enterprise_accounts_iam_response[0].iam_apikey
  existing_account_id           = module.enterprise.enterprise_accounts_iam_response[0].id
  existing_account_service_id   = replace(module.enterprise.enterprise_accounts_iam_response[0].iam_service_id, "iam-", "")
  existing_trusted_profile_name = "${var.prefix}-enable-service-id-to-invite-users"
  users_to_invite = [
    {
      email                   = "goldeneye.development@ibm.com"
      exisiting_access_groups = [ibm_iam_access_group_template.initial_access_group_template.group[0].name]
    }
  ]
}

module "invite_users_account_2" {
  providers = {
    ibm = ibm.account-2
  }
  depends_on = [
    module.invite_users_account_1,
    ibm_iam_trusted_profile_template_assignment.account_assignment_for_new_accounts,
    ibm_iam_access_group_template_assignment.iam_access_group_template_assignment_instance
  ]
  source                        = "../../modules/account_invite"
  ibmcloud_api_key              = module.enterprise.enterprise_accounts_iam_response[1].iam_apikey
  existing_account_id           = module.enterprise.enterprise_accounts_iam_response[1].id
  existing_account_service_id   = replace(module.enterprise.enterprise_accounts_iam_response[1].iam_service_id, "iam-", "")
  existing_trusted_profile_name = "${var.prefix}-enable-service-id-to-invite-users"
  users_to_invite = [
    {
      email                   = "goldeneye.development@ibm.com"
      exisiting_access_groups = [ibm_iam_access_group_template.initial_access_group_template.group[0].name]
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
  version = "1.3.0"
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
  version              = "2.7.1"
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
  version                  = "1.3.12"
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
  version                 = "1.7.0"
  region                  = local.sm_region
  secrets_manager_guid    = local.sm_guid
  secret_group_id         = module.secrets_manager_group.secret_group_id
  secret_name             = "${var.prefix}-enterprise-arbitrary-secret"
  secret_description      = "Enterprise child IAM_APIKey"
  secret_type             = "arbitrary"
  secret_payload_password = module.enterprise.enterprise_accounts_iam_response[0].iam_apikey
}
