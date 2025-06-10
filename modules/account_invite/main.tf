data "ibm_iam_access_group" "accgroup" {
  access_group_name = var.existing_access_group_name
}

resource "null_resource" "invite_user" {
  provisioner "local-exec" {
    command = "${path.module}/invite_user.sh"
    environment = {
      API_KEY              = var.ibmcloud_api_key
      CREW_INIT_GROUP      = data.ibm_iam_access_group.accgroup.groups[0].name
      USER_EMAILS          = join(" ", var.users_to_invite)
      SERVICE_ID           = var.existing_account_service_id
      TRUSTED_PROFILE_NAME = var.trusted_profile_name
    }
  }
}
