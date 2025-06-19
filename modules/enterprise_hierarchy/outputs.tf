output "account_groups" {
  value       = ibm_enterprise_account_group.enterprise_account_group
  description = "enterprise account groups"
}

output "accounts" {
  value       = ibm_enterprise_account.enterprise_account
  description = "enterprise accounts"
}
