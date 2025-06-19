
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

output "enterprise_accounts_iam_response" {
  description = "List of accounts created in an Enterprise"
  sensitive   = true
  value = flatten([[for key, value in module.enterprise_hierarchy_depth_0.accounts : {
    id : value.id,
    parent : value.parent,
    name : value.name,
    crn : value.crn,
    owner_iam_id : value.owner_iam_id
    iam_apikey : value.iam_apikey
    iam_service_id : value.iam_service_id
    iam_apikey_id : value.iam_apikey_id
    }],
    [for key, value in module.enterprise_hierarchy_depth_1.accounts : {
      id : value.id,
      parent : value.parent,
      name : value.name,
      crn : value.crn,
      owner_iam_id : value.owner_iam_id
      iam_apikey : value.iam_apikey
      iam_service_id : value.iam_service_id
      iam_apikey_id : value.iam_apikey_id
    }],
    [for key, value in module.enterprise_hierarchy_depth_2.accounts : {
      id : value.id,
      parent : value.parent,
      name : value.name,
      crn : value.crn,
      owner_iam_id : value.owner_iam_id
      iam_apikey : value.iam_apikey
      iam_service_id : value.iam_service_id
      iam_apikey_id : value.iam_apikey_id
    }]
  ])
}
