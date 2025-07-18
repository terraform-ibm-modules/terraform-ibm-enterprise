module "dynamic_values" {
  source                            = "./modules/dynamic_values"
  enterprise_account_groups         = var.enterprise_account_groups
  enterprise_accounts               = var.enterprise_accounts
  enterprise_crn                    = var.enterprise_crn
  enterprise_primary_contact_iam_id = var.enterprise_primary_contact_iam_id
}

module "enterprise_hierarchy_depth_0" {
  source                            = "./modules/enterprise_hierarchy"
  enterprise_hierarchy              = module.dynamic_values.enterprise_hierarchy_depth_0
  parent_account_groups             = null
  enterprise_crn                    = var.enterprise_crn
  enterprise_primary_contact_iam_id = var.enterprise_primary_contact_iam_id
}

module "enterprise_hierarchy_depth_1" {
  source                            = "./modules/enterprise_hierarchy"
  enterprise_hierarchy              = module.dynamic_values.enterprise_hierarchy_depth_1
  parent_account_groups             = module.enterprise_hierarchy_depth_0.account_groups
  enterprise_crn                    = var.enterprise_crn
  enterprise_primary_contact_iam_id = var.enterprise_primary_contact_iam_id
}

module "enterprise_hierarchy_depth_2" {
  source                            = "./modules/enterprise_hierarchy"
  enterprise_hierarchy              = module.dynamic_values.enterprise_hierarchy_depth_2
  parent_account_groups             = module.enterprise_hierarchy_depth_1.account_groups
  enterprise_crn                    = var.enterprise_crn
  enterprise_primary_contact_iam_id = var.enterprise_primary_contact_iam_id
}
