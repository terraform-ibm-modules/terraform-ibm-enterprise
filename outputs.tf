
output "enterprise_account_groups" {
  description = "List of account groups created in an Enterprise"
  value = flatten([[for key, value in module.enterprise_hierarchy_depth_0.account_groups : {
    parent : value.parent,
    name : value.name,
    crn : value.crn,
    primary_contact_iam_id : value.primary_contact_iam_id
    }],
    [for key, value in module.enterprise_hierarchy_depth_1.account_groups : {
      parent : value.parent,
      name : value.name,
      crn : value.crn,
      primary_contact_iam_id : value.primary_contact_iam_id
    }],
    [for key, value in module.enterprise_hierarchy_depth_2.account_groups : {
      parent : value.parent,
      name : value.name,
      crn : value.crn,
      primary_contact_iam_id : value.primary_contact_iam_id
    }]
  ])
}

output "enterprise_accounts" {
  description = "List of accounts created in an Enterprise"
  value = flatten([[for key, value in module.enterprise_hierarchy_depth_0.accounts : {
    parent : value.parent,
    name : value.name,
    crn : value.crn,
    owner_iam_id : value.owner_iam_id
    }],
    [for key, value in module.enterprise_hierarchy_depth_1.accounts : {
      parent : value.parent,
      name : value.name,
      crn : value.crn,
      owner_iam_id : value.owner_iam_id
    }],
    [for key, value in module.enterprise_hierarchy_depth_2.accounts : {
      parent : value.parent,
      name : value.name,
      crn : value.crn,
      owner_iam_id : value.owner_iam_id
    }]
  ])
}
