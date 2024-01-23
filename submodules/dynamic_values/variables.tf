# for now added support for upto 3 level depth of enterprise hierarchy
variable "enterprise_json_input" {
  description = "List of enterprise child account groups and account"
  type = list(object({
    accounts = optional(list(object({ name = string, owner_iam_id = optional(string, "root") })))
    account_groups = optional(list(object(
      { name     = string,
        accounts = optional(list(object({ name = string, owner_iam_id = optional(string, "root") })))
        account_groups = optional(list(object({
          name     = string,
          accounts = optional(list(object({ name = string, owner_iam_id = optional(string, "root") })))
          account_groups = optional(list(object(
            { name           = string,
              accounts       = optional(list(object({ name = string, owner_iam_id = optional(string, "root") })))
              account_groups = optional(list(object({ name = string })))
          })))
        })))
    })))
  }))
}

variable "enterprise_crn" {
  type        = string
  description = "Enterprise CRN"
}

variable "enterprise_primary_contact_iam_id" {
  type        = string
  description = "Enterprise owner IAM id"
}
