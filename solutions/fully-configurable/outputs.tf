output "api_key" {
    value = module.enterprise.enterprise_accounts_iam_response[0].iam_apikey
    sensitive = true
}

output "prefixed_account_group" {
  value = local.prefixed_enterprise_account_groups
}

output "prefixed_account" {
  value = local.prefixed_enterprise_accounts
}

output "prefixed_invite" {
  value = local.prefixed_users_to_invite
}