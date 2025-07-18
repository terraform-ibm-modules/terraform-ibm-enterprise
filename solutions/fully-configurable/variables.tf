########################################################################################################################
# common variables
########################################################################################################################

variable "ibmcloud_api_key" {
  type        = string
  description = "The IBM Cloud API key used to provision resources."
  sensitive   = true
}

variable "provider_visibility" {
  description = "Set the visibility value for the IBM terraform provider. Supported values are `public`, `private`, `public-and-private`. [Learn more](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/guides/custom-service-endpoints)."
  type        = string
  default     = "private"
  nullable    = false

  validation {
    condition     = contains(["public", "private", "public-and-private"], var.provider_visibility)
    error_message = "Invalid value for 'provider_visibility'. Allowed values are 'public', 'private', or 'public-and-private'."
  }
}

variable "prefix" {
  type        = string
  nullable    = true
  description = "The prefix to be added to all resources created by this solution. To skip using a prefix, set this value to null or an empty string. The prefix must begin with a lowercase letter and may contain only lowercase letters, digits, and hyphens '-'. It should not exceed 16 characters, must not end with a hyphen('-'), and can not contain consecutive hyphens ('--'). Example: prod-us-south. [Learn more](https://terraform-ibm-modules.github.io/documentation/#/prefix.md)."

  validation {
    # - null and empty string is allowed
    # - Must not contain consecutive hyphens (--): length(regexall("--", var.prefix)) == 0
    # - Starts with a lowercase letter: [a-z]
    # - Contains only lowercase letters (a–z), digits (0–9), and hyphens (-) and must not exceed 16 characters in length: [a-z0-9-]{0,14}
    # - Must not end with a hyphen (-): [a-z0-9]
    condition = (var.prefix == null || var.prefix == "" ? true :
      alltrue([
        can(regex("^[a-z][-a-z0-9]{0,14}[a-z0-9]$", var.prefix)),
        length(regexall("--", var.prefix)) == 0
      ])
    )
    error_message = "Prefix must begin with a lowercase letter and may contain only lowercase letters, digits, and hyphens '-'. It should not exceed 16 characters, must not end with a hyphen('-'), and cannot contain consecutive hyphens ('--')."
  }
}

########################################################################################################################
# enterprise variables
########################################################################################################################

variable "parent_enterprise_account_crn" {
  type        = string
  description = "The CRN of the parent Enterprise account to use."
  nullable    = false
}

variable "parent_enterprise_account_primary_contact_iam_id" {
  type        = string
  description = "The IAM id of the parent Enterprise account owner."
  nullable    = false
}

variable "enterprise_account_config" {
  type = object({
    unique_identifier             = string
    account_name                  = string
    parent_key_name               = optional(string, null)
    create_account_group          = optional(bool, false)
    account_group_name            = optional(string, null)
    account_group_parent_key_name = optional(string, null)
    owner_iam_id                  = optional(string, null)
    add_owner_iam_policies        = optional(bool, true)
    enterprise_iam_managed        = optional(bool, true)
    mfa                           = optional(string, "NONE")
  })
  description = "The account to be created under the parent enterprise account. [Learn more](https://github.com/terraform-ibm-modules/terraform-ibm-enterprise/tree/main/solutions/fully-configurable/DA-enterprise_account_config.md)."
}

##############################################################################
# trusted profile and access group policy variables
##############################################################################

variable "trusted_profile_name" {
  description = "The name of the trusted profile that will be created in the sub account and used to invite users after being assumed by the sub account service ID. If a prefix input variable is specified, the prefix is added to the name in the `<prefix>-<name>` format."
  type        = string
  default     = "enable-service-id-to-invite-users"
}

variable "trusted_profile_description" {
  description = "The description for the trusted profile that will be created in the sub account and used to invite users after being assumed by the sub account service ID."
  type        = string
  default     = "Trusted Profile for sub account with required access for inviting users"
}

variable "access_groups" {
  description = "Map of access group configurations to create multiple access groups for the newly invited users. [Learn more](https://github.com/terraform-ibm-modules/terraform-ibm-enterprise/tree/main/solutions/fully-configurable/DA-access_groups.md)."
  type = map(object({
    access_group_name = string
    add_members       = optional(bool, false)
    dynamic_rules = optional(map(object({
      expiration        = number
      identity_provider = string
      conditions = list(object({
        claim    = string
        operator = string
        value    = string
      }))
    })), {})
    policies = optional(map(object({
      roles              = list(string)
      account_management = optional(bool)
      tags               = set(string)
      resources = optional(list(object({
        region               = optional(string)
        attributes           = optional(map(string))
        service              = optional(string)
        resource_instance_id = optional(string)
        resource_type        = optional(string)
        resource             = optional(string)
        resource_group_id    = optional(string)
      })))
      resource_attributes = optional(list(object({
        name     = string
        value    = string
        operator = optional(string)
      })))
    })), {})
  }))
  default = {}
}

########################################################################################################################
# account invite variables
########################################################################################################################

variable "users_to_invite" {
  description = "A list containing the email ID of user to be invited to an enterprise account and the list of access groups that needs to be assigned to the user. [Learn more](https://github.com/terraform-ibm-modules/terraform-ibm-enterprise/tree/main/solutions/fully-configurable/DA-users_to_invite.md)."
  type = list(object({
    email                   = string
    exisiting_access_groups = optional(list(string), [])
  }))
  default = [] # Allow for an empty list
}
