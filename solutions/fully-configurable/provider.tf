provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key
  region           = var.region
}

provider "ibm" {
  ibmcloud_api_key = module.enterprise.enterprise_accounts_iam_response[0].iam_apikey
  region           = var.region
  alias            = "sub-account"
}