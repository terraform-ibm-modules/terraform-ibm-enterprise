
// account_groups
locals {
  input                  = var.enterprise_json_input
  depth_0_account_groups = lookup(var.enterprise_json_input, "account_groups", [])
  depth_1_account_groups = length(local.depth_0_account_groups) > 0 ? flatten([for key, child_object in local.depth_0_account_groups : [
    for k, v in child_object.account_groups : {
      "account_groups" = v.account_groups
      "parent"         = child_object.name
      "name"           = v.name
      "accounts"       = v.accounts
    }
    ] if child_object.account_groups != null
  ]) : []
  depth_2_account_groups = flatten([for key, child_object in local.depth_1_account_groups : [
    for k, v in child_object.account_groups : {
      "account_groups" = v.account_groups
      "parent"         = child_object.name
      "name"           = v.name
      "accounts"       = v.accounts
    }
    ] if child_object.account_groups != null
  ])


  // accounts

  accounts = lookup(var.enterprise_json_input, "accounts", [])
  depth_0_accounts = length(local.accounts) > 0 ? flatten([for key, v in local.accounts : [
    {
      "name"         = v.name
      "owner_iam_id" = v.owner_iam_id == "root" ? var.enterprise_primary_contact_iam_id : v.owner_iam_id
    }
    ]
  ]) : []
  depth_1_accounts = length(local.depth_0_account_groups) > 0 ? flatten([for key, child_object in local.depth_0_account_groups : [
    for k, v in child_object.accounts : {
      "parent"       = child_object.name
      "name"         = v.name
      "owner_iam_id" = v.owner_iam_id == "root" ? var.enterprise_primary_contact_iam_id : v.owner_iam_id
    }
    ] if child_object.accounts != null
  ]) : []

  depth_2_accounts = flatten([for key, child_object in local.depth_1_account_groups : [
    for k, v in child_object.accounts : {
      "parent"       = child_object.name
      "name"         = v.name
      "owner_iam_id" = v.owner_iam_id == "root" ? var.enterprise_primary_contact_iam_id : v.owner_iam_id
    }
    ] if child_object.accounts != null
  ])


  // enterprise heirarchies
  enterprise_hierarchy_depth_0 = {
    "account_groups" = length(local.depth_0_account_groups) > 0 ? ([for key, child_object in local.depth_0_account_groups : {
      "name" = child_object.name
    }]) : []
    "accounts" = local.depth_0_accounts
  }

  enterprise_hierarchy_depth_1 = {
    "account_groups" = flatten([for key, child_object in local.depth_1_account_groups : {
      "name"   = child_object.name
      "parent" = child_object.parent
    }])
    "accounts" = local.depth_1_accounts
  }

  enterprise_hierarchy_depth_2 = {
    "account_groups" = flatten([for key, child_object in local.depth_2_account_groups : {
      "name"   = child_object.name
      "parent" = child_object.parent
    }])
    "accounts" = local.depth_2_accounts
  }
}
