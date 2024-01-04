########################################################################################################################
# Input Variables
########################################################################################################################

variable "enterprise_crn" {
  type        = string
  description = "The CRN of the parent Enterprise account to use."
}

variable "enterprise_primary_contact_iam_id" {
  type        = string
  description = "The IAM id of the parent Enterprise account owner."
}

variable "enterprise_json_input" {
  description = "List of account groups and account names"
  type = map(list(object({
    name         = string
    owner_iam_id = optional(string, "root")
    accounts     = optional(list(object({ name = string, owner_iam_id = optional(string, "root") })))
    account_groups = optional(list(object(
      { name     = string,
        accounts = optional(list(object({ name = string, owner_iam_id = optional(string, "root") })))
        account_groups = optional(list(object({
          name     = string,
          accounts = optional(list(object({ name = string, owner_iam_id = optional(string, "root") })))
          account_groups = optional(list(object(
          { name = string })))
        })))
    })))
    }))
  )
}
