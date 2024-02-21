# for now added support for upto 3 level depth of enterprise hierarchy
variable "enterprise_json_input" {
  description = "List of enterprise child account groups and account"
  type = object({
    accounts       = optional(list(object({ name = string, key_name = string, parent = optional(string, null), owner_iam_id = optional(string, null) })))
    account_groups = optional(list(object({ name = string, key_name = string, parent = optional(string, null), owner_iam_id = optional(string, null) })))
  })
}

variable "enterprise_crn" {
  type        = string
  description = "Enterprise CRN"
}

variable "enterprise_primary_contact_iam_id" {
  type        = string
  description = "Enterprise owner IAM id"
}
