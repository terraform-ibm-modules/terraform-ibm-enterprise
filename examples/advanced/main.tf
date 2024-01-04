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
    account_groups = [{
      # Here is how to create a hierarchy of enterprise child accounts and account groups
      # NB: There is currently a limitation with this when doing terraform destroy as accounts do not get fully deleted 
      # until 21 days after deletion process has been triggered, and so the destroy of the account group will fail 
      # until after the 21 days are up. A force delete option is being considered by backend team to address this.
      # This is why the account creation is commented out below.

      name="${var.prefix}_account_group_depth_0",
      # accounts = [{ name = "${var.prefix}_account_depth_0" }],
      account_groups=[
        {
          name="${var.prefix}_account_group_depth_1",
          # accounts = [{ name = "${var.prefix}_account_depth_1" }],
          account_groups=[
            {
              name="${var.prefix}_account_group_depth_2",
              # accounts = [{ name = "${var.prefix}_account_depth_2" }],
            }
          ]
        }
      ]
    }]
  }
}
