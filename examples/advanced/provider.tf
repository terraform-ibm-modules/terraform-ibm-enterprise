provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key
  region           = var.existing_sm_instance_region == null ? var.region : var.existing_sm_instance_region
  alias            = "ibm-sm"
}

provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key
  region           = var.region
}

provider "ibm" {
  ibmcloud_api_key = module.enterprise.enterprise_accounts_iam_response[0].iam_apikey
  region           = var.region
  alias            = "account-1"
}

provider "ibm" {
  ibmcloud_api_key = module.enterprise.enterprise_accounts_iam_response[1].iam_apikey
  region           = var.region
  alias            = "account-2"
}
