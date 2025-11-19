########################################################################################################################
# Input Variables
########################################################################################################################

variable "enterprise_crn" {
  type        = string
  description = "The CRN of the parent Enterprise account to use."

  validation {
    condition = anytrue([
      can(regex("^crn:v1:bluemix:[^:]+:enterprise::a/[0-9a-fA-F]{32}::enterprise:[0-9a-fA-F]{32}$", var.enterprise_crn)),
      var.enterprise_crn == null,
    ])
    error_message = "The value provided for 'enterprise_crn' is not valid."
  }
}

variable "enterprise_primary_contact_iam_id" {
  type        = string
  description = "The IAM id of the parent Enterprise account owner."
}


variable "enterprise_accounts" {
  description = "List of enterprise child accounts in the enterprise"
  type        = list(object({ name = string, key_name = string, parent_key_name = optional(string, null), owner_iam_id = optional(string, null), add_owner_iam_policies = optional(bool, false), enterprise_iam_managed = optional(bool, true), mfa = optional(string, "NONE") }))
  default     = []
  validation {
    error_message = "Accounts key_name should be unique"
    condition     = length(distinct(var.enterprise_accounts[*].key_name)) == length(var.enterprise_accounts[*].key_name)
  }
}

variable "enterprise_account_groups" {
  description = "List of enterprise child account_groups in the enterprise"
  type        = list(object({ name = string, key_name = string, parent_key_name = optional(string, null), owner_iam_id = optional(string, null) }))
  default     = []
  validation {
    error_message = "Account_Groups key_name should be unique"
    condition     = length(distinct(var.enterprise_account_groups[*].key_name)) == length(var.enterprise_account_groups[*].key_name)
  }
}
