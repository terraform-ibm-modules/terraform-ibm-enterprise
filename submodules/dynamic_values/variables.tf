# for now added support for upto 3 level depth of enterprise heirarchy
variable "enterprise_json_input" {
  description = "List of enterprise child account groups and account"
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
