data "ibm_enterprises" "enterprise" {
  name = var.enterprise_name
}

module "enterprise" {
  source                            = "../.."
  enterprise_crn                    = data.ibm_enterprises.enterprise.enterprises[0].crn
  enterprise_primary_contact_iam_id = data.ibm_enterprises.enterprise.enterprises[0].primary_contact_iam_id
  enterprise_json_input             = var.enterprise_json_input
}
