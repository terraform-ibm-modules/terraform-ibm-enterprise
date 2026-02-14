locals {
  prefix = var.prefix != null ? (trimspace(var.prefix) != "" ? "${trimspace(var.prefix)}-" : "") : ""

  should_create_group = try(var.enterprise_account_config.create_account_group, false)

  # extract account and account group details from enterprise_account_config
  enterprise_account_group = local.should_create_group ? {
    key_name        = var.enterprise_account_config.parent_key_name
    name            = "${local.prefix}${var.enterprise_account_config.account_group_name}"
    parent_key_name = var.enterprise_account_config.account_group_parent_key_name
    owner_iam_id    = var.enterprise_account_config.owner_iam_id
  } : {}

  enterprise_account = {
    key_name               = var.enterprise_account_config.unique_identifier
    name                   = "${local.prefix}${var.enterprise_account_config.account_name}"
    parent_key_name        = var.enterprise_account_config.parent_key_name
    owner_iam_id           = var.enterprise_account_config.owner_iam_id
    add_owner_iam_policies = var.enterprise_account_config.add_owner_iam_policies
    enterprise_iam_managed = var.enterprise_account_config.enterprise_iam_managed
    mfa                    = var.enterprise_account_config.mfa
  }

  prefixed_users_to_invite = [
    for user in var.users_to_invite : (
      merge(user, {
        exisiting_access_groups = [
          for group_name in user.exisiting_access_groups :
          "${local.prefix}${group_name}"
        ]
      })
    )
  ]
}

########################################################################################################################
# Create Enterprise account and account group
########################################################################################################################

module "enterprise" {
  source                            = "../.."
  enterprise_crn                    = var.parent_enterprise_account_crn
  enterprise_primary_contact_iam_id = var.parent_enterprise_account_primary_contact_iam_id
  enterprise_account_groups         = local.should_create_group ? [local.enterprise_account_group] : []
  enterprise_accounts               = [local.enterprise_account]
}

########################################################################################################################
# Trusted Profile
########################################################################################################################

resource "ibm_iam_trusted_profile" "trusted_profile" {
  provider    = ibm.sub-account
  name        = "${local.prefix}${var.trusted_profile_name}"
  description = var.trusted_profile_description
}

resource "ibm_iam_trusted_profile_policy" "trusted_profile_iam_policy" {
  provider   = ibm.sub-account
  profile_id = ibm_iam_trusted_profile.trusted_profile.id

  roles = ["Administrator"]
  resource_attributes {
    name     = "service_group_id"
    operator = "stringEquals"
    value    = "IAM" # assigns access to All Identity and Access enabled services for enabling user invite feature
  }
}

resource "ibm_iam_trusted_profile_identity" "account_service_id_identity" {
  provider      = ibm.sub-account
  profile_id    = ibm_iam_trusted_profile.trusted_profile.id
  type          = "serviceid"
  identity_type = "serviceid"
  identifier    = replace(module.enterprise.enterprise_accounts_iam_response[0].iam_service_id, "iam-", "")
}

########################################################################################################################
# Access Group for new users
########################################################################################################################

module "iam_access_group" {
  providers = {
    ibm = ibm.sub-account
  }
  source            = "terraform-ibm-modules/iam-access-group/ibm"
  version           = "1.6.9"
  for_each          = var.access_groups
  access_group_name = "${local.prefix}${each.value.access_group_name}"
  dynamic_rules     = each.value.dynamic_rules
  add_members       = each.value.add_members
  policies          = each.value.policies
}

########################################################################################################################
# Inviting Users to Sub Account
########################################################################################################################

module "invite_users" {
  depends_on = [
    module.enterprise,
    ibm_iam_trusted_profile.trusted_profile,
    module.iam_access_group
  ]
  providers = {
    ibm = ibm.sub-account
  }
  source                        = "../../modules/account_invite"
  ibmcloud_api_key              = module.enterprise.enterprise_accounts_iam_response[0].iam_apikey
  existing_account_id           = module.enterprise.enterprise_accounts_iam_response[0].id
  existing_account_service_id   = replace(module.enterprise.enterprise_accounts_iam_response[0].iam_service_id, "iam-", "")
  existing_trusted_profile_name = "${local.prefix}${var.trusted_profile_name}"
  users_to_invite               = local.prefixed_users_to_invite
}
