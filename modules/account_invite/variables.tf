variable "existing_access_group_name" {
  type        = string
  description = "The access group name for initial access group for new users"
}

variable "users_to_invite" {
  type        = list(string)
  description = "The list of user email IDs to be invited to the sub account of the enterprise."
}

variable "ibmcloud_api_key" {
  type        = string
  sensitive   = true
  description = "The sub account api key of the enterprise."
}

variable "existing_account_service_id" {
  type        = string
  description = "The sub account service ID."
}

variable "trusted_profile_name" {
  type        = string
  description = "The trusted profile to be assumed by the sub account."
}
