provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key
  visibility       = var.provider_visibility
}

provider "ibm" {
  ibmcloud_api_key = module.enterprise.enterprise_accounts_iam_response[0].iam_apikey
  alias            = "sub-account"
  visibility       = var.provider_visibility
}
