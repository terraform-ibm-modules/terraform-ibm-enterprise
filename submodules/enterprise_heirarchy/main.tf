
resource "ibm_enterprise_account_group" "enterprise_account_group" {
  for_each = {
    for account_group in var.enterprise_heirarchy.account_groups :
    account_group.name => account_group
  }
  parent                 = each.value.parent != null ? var.parent_account_groups[each.value.parent].crn : var.enterprise_crn
  name                   = each.key
  primary_contact_iam_id = var.enterprise_primary_contact_iam_id
}

resource "ibm_enterprise_account" "enterprise_account" {
  for_each = {
    for i, account in var.enterprise_heirarchy.accounts :
    "${i}_${account.name}" => account
  }
  parent       = each.value.parent != null ? var.parent_account_groups[each.value.parent].crn : var.enterprise_crn
  name         = each.value.name
  owner_iam_id = var.enterprise_primary_contact_iam_id
}
