# for now added support for upto 3 level depth of enterprise hierarchy

variable "enterprise_accounts" {
  description = "List of enterprise child accounts in the enterprise"
  type        = list(object({ name = string, key_name = string, parent = optional(string, null), owner_iam_id = optional(string, null) }))
  validation {
    error_message = "Accounts key_name should be unique"
    condition     = length(distinct(var.enterprise_accounts[*].key_name)) == length(var.enterprise_accounts[*].key_name)
  }
}

variable "enterprise_account_groups" {
  description = "List of enterprise child account_groups in the enterprise"
  type        = list(object({ name = string, key_name = string, parent = optional(string, null), owner_iam_id = optional(string, null) }))
  validation {
    error_message = "Account_Groups key_name should be unique"
    condition     = length(distinct(var.enterprise_account_groups[*].key_name)) == length(var.enterprise_account_groups[*].key_name)
  }
}

variable "enterprise_crn" {
  type        = string
  description = "Enterprise CRN"
}

variable "enterprise_primary_contact_iam_id" {
  type        = string
  description = "Enterprise owner IAM id"
}
