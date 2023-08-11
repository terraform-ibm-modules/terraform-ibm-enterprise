variable "enterprise_name" {
  description = "name of the enterprise"
  type        = string
  default     = "terraform test1"
}
variable "tree_based_input" {
  description = "List of account groups and account names"
  type = list(
    object({
      type                   = string
      name                   = string
      ref_name               = optional(string),        # used internally only. If not set, then use name. Validate that ref_name are unique.
      parent                 = optional(string, "root") #parent reference an ref_name
      primary_contact_iam_id = optional(string, "root") #parent reference an ref_name  s
    })
  )
  default = [
    {
      type = "account group"
      name = "parent account group"
    },
    {
      type   = "account group"
      name   = "child account group"
      parent = "parent account group"
    }
  ]
}
