# Lookup data from given enterprise account
data "ibm_enterprises" "enterprise" {
  name = var.enterprise_name
}

# Call root level module to create a hierarchy of enterprise child accounts and account groups
module "enterprise" {
  source                            = "../.."
  enterprise_crn                    = data.ibm_enterprises.enterprise.enterprises[0].crn
  enterprise_primary_contact_iam_id = data.ibm_enterprises.enterprise.enterprises[0].primary_contact_iam_id
  enterprise_json_input = {
    account_groups = [
      {
        key_name = "${var.prefix}-group-key-1"
        name     = "${var.prefix}_account_group_1"
        parent   = null
      },
      {
        key_name = "${var.prefix}-group-key-2"
        name     = "${var.prefix}_account_group_2"
        parent   = "${var.prefix}-group-key-1"
    }]
    accounts = [
      {
        key_name = "${var.prefix}-acct-key-1"
        name     = "${var.prefix}_account_1"
        parent   = null
      },
      {
        key_name = "${var.prefix}-acc-key-2"
        name     = "${var.prefix}_account_2"
        parent   = null
      }
    ]
  }
}
