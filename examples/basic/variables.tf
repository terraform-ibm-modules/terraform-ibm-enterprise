variable "ibmcloud_api_key" {
  type        = string
  description = "The IBM Cloud API Key with access to create enterprise sub accounts"
  sensitive   = true
}

variable "prefix" {
  type        = string
  description = "Prefix to append to all resources created by this example"
  default     = "tf-ibm-enterprise"
}

variable "enterprise_account_name" {
  description = "Name of the parent enterprise account"
  type        = string
}

variable "owner_iam_id" {
  description = "The IAM ID of the user to be assigned as the owner for the sub accounts"
  type        = string
}
