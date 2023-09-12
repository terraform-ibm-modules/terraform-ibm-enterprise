variable "enterprise_crn" {
  type        = string
  description = "Enterprise CRN"
}

variable "enterprise_primary_contact_iam_id" {
  type        = string
  description = "Enterprise owner IAM id"
}
variable "enterprise_json_input" {
  description = "List of account groups and account names"
  type = map(list(object({
    name     = string
    accounts = optional(list(object({ name = string })))
    account_groups = optional(list(object(
      { name     = string,
        accounts = optional(list(object({ name = string })))
        account_groups = optional(list(object({
          name     = string,
          accounts = optional(list(object({ name = string })))
          account_groups = optional(list(object(
          { name = string })))
        })))
    })))
    }))
  )
}
