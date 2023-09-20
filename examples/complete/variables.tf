variable "enterprise_name" {
  description = "name of the enterprise"
  type        = string
}

# for now added support for upto 3 level depth of enterprise hierarchy
variable "enterprise_json_input" {
  description = "List of enterprise child account groups and account"
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
  default = {
    account_groups = [{
      name     = "depth_1_account_group1",
      accounts = [{ name = "depth_2_account" }]
    }]
    accounts = [
      { name = "depth0 account" },
    ]
  }
}

variable "ibmcloud_api_key" {
  type        = string
  description = "The IBM Cloud API key for generating token this account authenticates to"
  sensitive   = true
}
