data "ibm_iam_trusted_profiles" "iam_trusted_profiles" {
  count      = length(var.users_to_invite) > 0 ? 1 : 0
  account_id = var.existing_account_id
  name       = var.existing_trusted_profile_name
}

resource "terraform_data" "terraform_data" {
  count = var.install_required_binaries ? 1 : 0
  triggers_replace = {
    user_email_trigger           = each.value.email
    user_access_groups_trigger   = join(",", each.value.exisiting_access_groups)
    trusted_profile_name_trigger = var.existing_trusted_profile_name    
  }
  provisioner "local-exec" {
    command     = "${path.module}/scripts/install-binaries.sh ${local.binaries_path}"
    interpreter = ["/bin/bash", "-c"]
  }
}

resource "terraform_data" "invite_user" {
  for_each = { for idx, user_obj in var.users_to_invite : idx => user_obj }
  depends_on = [terraform_data.install_required_binaries]
  triggers = {
    user_email_trigger           = each.value.email
    user_access_groups_trigger   = join(",", each.value.exisiting_access_groups)
    trusted_profile_name_trigger = var.existing_trusted_profile_name
  }

  provisioner "local-exec" {
    command = " ${path.module}/scripts/install-binaries.sh ${local.binaries_path}"
    environment = {
      API_KEY            = var.ibmcloud_api_key
      USER_EMAIL         = each.value.email
      USER_ACCESS_GROUPS = join(",", each.value.exisiting_access_groups) # Join access groups with a comma
      SERVICE_ID         = var.existing_account_service_id
      TRUSTED_PROFILE_ID = data.ibm_iam_trusted_profiles.iam_trusted_profiles[0].profiles[0].id
    }
  }
}
