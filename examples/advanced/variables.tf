variable "ibmcloud_api_key" {
  type        = string
  description = "The IBM Cloud API Key with access to create enterprise sub accounts"
  sensitive   = true
}

variable "ibmcloud_enterprise_account_id" {
  type        = string
  description = "The account ID for the DAF Enterprise account."
}

variable "prefix" {
  type        = string
  description = "Prefix to append to all resources created by this example"
  default     = "tf-ibm"
}

variable "enterprise_account_name" {
  description = "Name of the enterprise account"
  type        = string
}

variable "existing_sm_instance_guid" {
  type        = string
  description = "Existing Secrets Manager GUID. The existing Secret Manager instance must have private certificate engine configured. If not provided an new instance will be provisioned."
  default     = null
}

variable "existing_sm_instance_region" {
  type        = string
  description = "Required if value is passed into var.existing_sm_instance_guid"
  default     = null
}

variable "region" {
  type        = string
  description = "Region to provision all resources created by this example."
  default     = "us-south"
}

variable "resource_group" {
  type        = string
  description = "Name of the resource group to use for this example. If not set, a resource group is created."
  default     = null
}

variable "trusted_profile_name" {
  type        = string
  description = "Name of the trusted profile under the template that will be reflected in the sub account"
  default     = "enable-service-id-to-invite-users"
}
