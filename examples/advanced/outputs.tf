########################################################################################################################
# Outputs
########################################################################################################################
output "enterprise_account_iam_response" {
  description = "The account with IAM details created in an Enterprise"
  value       = module.enterprise.enterprise_accounts_iam_response
}