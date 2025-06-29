variable "ibmcloud_api_key" {
  type        = string
  sensitive   = true
  description = " The apikey used to authenticate to the account in the enterprise where users are to be invited."
}

variable "existing_account_service_id" {
  type        = string
  description = "The service ID of the account which is used to assume the trusted profile with permission (All Identity and Access enabled services) to invite users."
}

variable "existing_trusted_profile_name" {
  type        = string
  description = "The trusted profile used to send invite to the users. It needs Administrator access on All Identity and Access enabled services."
}

variable "existing_account_id" {
  type        = string
  description = "The ID of the account where the trusted profile for inviting users is created and the users will be invited."
}

variable "users_to_invite" {
  description = "A list containing the email ID of user to be invited to an enterprise account and the list of access groups that needs to be assigned to the user"
  type = list(object({
    email                   = string
    exisiting_access_groups = optional(list(string), [])
  }))
  default = [] # Allow for an empty list
}
