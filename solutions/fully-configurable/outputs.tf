output "enterprise_account_group" {
  description = "The account group created in an Enterprise"
  value       = module.enterprise.enterprise_account_groups
}

output "enterprise_account" {
  description = "The account created in an Enterprise"
  value       = module.enterprise.enterprise_accounts
}

output "enterprise_account_iam_response" {
  description = "The account with IAM details created in an Enterprise"
  value       = module.enterprise.enterprise_accounts_iam_response
  #sensitive   = true
}
