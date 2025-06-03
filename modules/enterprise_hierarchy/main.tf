resource "ibm_enterprise_account_group" "enterprise_account_group" {
  for_each               = var.enterprise_hierarchy.account_groups
  parent                 = each.value.parent_key_name == null ? var.enterprise_crn : var.parent_account_groups[each.value.parent_key_name].crn
  name                   = each.value.name
  primary_contact_iam_id = each.value.owner_iam_id == null ? var.enterprise_primary_contact_iam_id : each.value.owner_iam_id
}


resource "ibm_enterprise_account" "enterprise_account" {
  for_each     = var.enterprise_hierarchy.accounts
  parent       = each.value.parent_key_name != null ? var.parent_account_groups[each.value.parent_key_name].crn : var.enterprise_crn
  name         = each.value.name
  owner_iam_id = each.value.owner_iam_id == null ? var.enterprise_primary_contact_iam_id : each.value.owner_iam_id
  traits {
    enterprise_iam_managed = true
  }
  options {
    create_iam_service_id_with_apikey_and_owner_policies = each.value.add_owner_iam_policies
  }
}
