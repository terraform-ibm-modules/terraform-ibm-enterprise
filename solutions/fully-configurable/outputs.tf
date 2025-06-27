output "enterprise_account_groups" {
  description = "List of account groups created in an Enterprise"
  value       = module.enterprise.enterprise_account_groups
}

output "enterprise_accounts" {
  description = "List of accounts created in an Enterprise"
  value       = module.enterprise.enterprise_accounts
}

output "enterprise_accounts_iam_response" {
  description = "List of accounts with IAM details created in an Enterprise"
  value       = module.enterprise.enterprise_accounts_iam_response
}
