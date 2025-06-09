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

# Call root level module to create 1 account group with 1 account in it
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
  }]

  enterprise_accounts = [
    {
      key_name        = "${var.prefix}-acct-key-1"
      name            = "${var.prefix}_account_1"
      parent_key_name = null
      owner_iam_id    = data.external.get_iam_id.result.iam_id
    }
  ]

}
