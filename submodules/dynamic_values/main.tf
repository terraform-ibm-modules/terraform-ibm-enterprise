
// account_groups
locals {

  nested_account_groups = { for value in var.enterprise_account_groups :
    value.key_name => value if(value.parent != null)
  }

  nested_accounts = { for value in var.enterprise_accounts :
    value.key_name => value if(value.parent != null)
  }


  depth_0_account_groups = { for value in var.enterprise_account_groups :
    value.key_name => value if(value.parent == null)
  }

  depth_0_accounts = { for value in var.enterprise_accounts :
    value.key_name => value if(value.parent == null)
  }

  depth_1_account_groups = {
    for value in local.nested_account_groups :
    value.key_name => value
    if contains(keys(local.depth_0_account_groups), value.parent)
  }

  depth_2_account_groups = {
    for value in local.nested_account_groups :
    value.key_name => value if contains(keys(local.depth_1_account_groups), value.parent)
  }

  depth_1_accounts = {
    for value in local.nested_accounts :
    value.key_name => value
    if contains(keys(local.depth_1_account_groups), value.parent)
  }

  depth_2_accounts = {
    for value in local.nested_accounts :
    value.key_name => value
    if contains(keys(local.depth_2_account_groups), value.parent)
  }

  enterprise_hierarchy_depth_0 = {
    "account_groups" = local.depth_0_account_groups
    "accounts"       = local.depth_0_accounts
  }

  enterprise_hierarchy_depth_1 = {
    "account_groups" = local.depth_1_account_groups
    "accounts"       = local.depth_1_accounts
  }

  enterprise_hierarchy_depth_2 = {
    "account_groups" = local.depth_2_account_groups
    "accounts"       = local.depth_2_accounts
  }
}
