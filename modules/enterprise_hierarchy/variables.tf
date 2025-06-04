variable "enterprise_hierarchy" {
  type = map(map(object({
    name                   = string
    parent_key_name        = optional(string, null)
    owner_iam_id           = optional(string, null)
    add_owner_iam_policies = optional(bool, false)
    key_name               = string
  })))
  description = "tree based input for creating enterprise children"
}

variable "enterprise_crn" {
  type        = string
  description = "Enterprise CRN"
}

variable "enterprise_primary_contact_iam_id" {
  type        = string
  description = "Enterprise owner IAM id"
}

variable "parent_account_groups" {
  type = map(object({
    crn                    = string
    name                   = string
    parent                 = string
    primary_contact_iam_id = string
  }))
  description = "account group object"
}
