variable "ibmcloud_api_key" {
  type        = string
  description = "The IBM Cloud API Key with access to create enterprise sub accounts"
  sensitive   = true
}

variable "enterprise_name" {
  description = "Name of the enterprise account"
  type        = string
}

variable "prefix" {
  type        = string
  description = "Prefix to append to all resources created by this example"
  default     = "enterprise"
}
