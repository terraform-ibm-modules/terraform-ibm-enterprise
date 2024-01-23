# Lookup data from given enterprise account
data "ibm_enterprises" "enterprise" {
  name = var.enterprise_name
}

# Call root level module to create 1 account group with 1 account in it
module "enterprise" {
  source                            = "../.."
  enterprise_crn                    = data.ibm_enterprises.enterprise.enterprises[0].crn
  enterprise_primary_contact_iam_id = data.ibm_enterprises.enterprise.enterprises[0].primary_contact_iam_id
  enterprise_json_input = [{
    # Here is how to create a new account (not inside any account group)
    accounts = [{ name = "${var.prefix}_account" }]
    account_groups = [{
      # Here is how to create an empty account group
      name = "${var.prefix}_account_group",

      # Here is how to create a new account group with a new account in it
      # NB: There is currently a limitation with this when doing terraform destroy as accounts do not get fully deleted
      # until 21 days after deletion process has been triggered, and so the destroy of the account group will fail
      # until after the 21 days are up. A force delete option is being considered by backend team to address this.
      # This is why the account creation in a new account group is commented out below.

      # name     = "${var.prefix}_account_group",
      # accounts = [{ name = "${var.prefix}_account" }]
    }]
  }]
}
