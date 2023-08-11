data "ibm_enterprises" "enterprise" {
  name = var.enterprise_name
}
locals {
  account_group_meta = ([
    for account_group in var.tree_based_input : {
      parent = (account_group.parent != "root" ? account_group.parent :
      data.ibm_enterprises.enterprise.enterprises[0].crn)
      primary_contact_iam_id = (account_group.parent != "root" ? account_group.parent : data.ibm_enterprises.enterprise.enterprises[0].primary_contact_iam_id)
      name                   = account_group.name
    }
  ])
}
resource "ibm_enterprise_account_group" "enterprise_account_group" {
  for_each = {
    for account_group in local.account_group_meta :
    account_group.name => account_group
  }
  parent                 = each.value.parent != "root" ? ibm_enterprise_account_group.enterprise_account_group[each.value.parent].crn : each.value.parent
  name                   = each.key
  primary_contact_iam_id = each.value.parent != "root" ? ibm_enterprise_account_group.enterprise_account_group[each.value.parent].primary_contact_iam_id : each.value.primary_contact_iam_id
}
