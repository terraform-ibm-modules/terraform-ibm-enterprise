variable "account_id" {
  type        = string
  description = "The ID of the sub account in the enterprise."
}

variable "access_group_name" {
  type        = string
  description = "The access group name for initial access group for new users"
}

variable "users_to_invite" {
  type        = list(string)
  description = "The list of user email IDs to be invited to each sub account of the enterprise."
}

variable "account_iam_apikey" {
  type        = string
  description = "The sub account api key of the enterprise."
}

variable "access_group_template_id" {
  type        = string
  description = "The ID of the access group template to be assigned to new user"
}

variable "access_group_template_version" {
  type        = string
  description = "The version of the access group template to be assigned to new user"
}

variable "account_service_id" {
  type        = string
  description = "The sub account service ID."
}

variable "trusted_profile_name" {
  type        = string
  description = "The trusted profile to be assumed by the sub account."
}
