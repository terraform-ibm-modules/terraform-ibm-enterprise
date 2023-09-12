
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

  depth_0_accounts = lookup(var.enterprise_json_input, "accounts", [])
  depth_1_accounts = length(local.depth_0_account_groups) > 0 ? flatten([for key, child_object in local.depth_0_account_groups : [
    for k, v in child_object.accounts : {
      "parent" = child_object.name
      "name"   = v.name
    }
    ] if child_object.accounts != null
  ]) : []

  depth_2_accounts = flatten([for key, child_object in local.depth_1_account_groups : [
    for k, v in child_object.accounts : {
      "parent" = child_object.name
      "name"   = v.name
    }
    ] if child_object.accounts != null
  ])


  // enterprise heirarchies
  enterprise_heirarchy_deapth_0 = {
    "account_groups" = length(local.depth_0_account_groups) > 0 ? ([for key, child_object in local.depth_0_account_groups : {
      "name" = child_object.name
    }]) : []
    "accounts" = local.depth_0_accounts
  }

  enterprise_heirarchy_deapth_1 = {
    "account_groups" = flatten([for key, child_object in local.depth_1_account_groups : {
      "name"   = child_object.name
      "parent" = child_object.parent
    }])
    "accounts" = local.depth_1_accounts
  }

  enterprise_heirarchy_deapth_2 = {
    "account_groups" = flatten([for key, child_object in local.depth_2_account_groups : {
      "name"   = child_object.name
      "parent" = child_object.parent
    }])
    "accounts" = local.depth_2_accounts
  }
}
