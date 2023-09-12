module "dynamic_values" {
  source                = "./submodules/dynamic_values"
  enterprise_json_input = var.enterprise_json_input
}
module "enterprise_heirarchy_deapth_0" {
  source                            = "./submodules/enterprise_heirarchy"
  enterprise_heirarchy              = module.dynamic_values.enterprise_heirarchy_deapth_0
  parent_account_groups             = null
  enterprise_crn                    = var.enterprise_crn
  enterprise_primary_contact_iam_id = var.enterprise_primary_contact_iam_id
}
module "enterprise_heirarchy_deapth_1" {
  source                            = "./submodules/enterprise_heirarchy"
  enterprise_heirarchy              = module.dynamic_values.enterprise_heirarchy_deapth_1
  parent_account_groups             = module.enterprise_heirarchy_deapth_0.account_groups
  enterprise_crn                    = var.enterprise_crn
  enterprise_primary_contact_iam_id = var.enterprise_primary_contact_iam_id
}
module "enterprise_heirarchy_deapth_2" {
  source                            = "./submodules/enterprise_heirarchy"
  enterprise_heirarchy              = module.dynamic_values.enterprise_heirarchy_deapth_2
  parent_account_groups             = module.enterprise_heirarchy_deapth_1.account_groups
  enterprise_crn                    = var.enterprise_crn
  enterprise_primary_contact_iam_id = var.enterprise_primary_contact_iam_id
}
