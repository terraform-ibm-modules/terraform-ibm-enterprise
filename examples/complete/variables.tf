variable "enterprise_name" {
  description = "name of the enterprise"
  type        = string
  default     = "terraform test1"
}

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
  default = {
  }
}

variable "ibmcloud_api_key" {
  type        = string
  description = "The IBM Cloud API key for generating token this account authenticates to"
  sensitive   = true
}
