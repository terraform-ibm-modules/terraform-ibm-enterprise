resource "ibm_iam_access_group_template_assignment" "iam_access_group_template_assignment_instance" {
  target           = var.account_id
  target_type      = "Account"
  template_id      = split("/", var.access_group_template_id)[0]
  template_version = var.access_group_template_version
}

resource "null_resource" "invite_user" {
  depends_on = [
  ibm_iam_access_group_template_assignment.iam_access_group_template_assignment_instance]
  provisioner "local-exec" {
    command = "chmod +x ${path.module}/invite_user.sh && ${path.module}/invite_user.sh"
    environment = {
      API_KEY              = var.account_iam_apikey
      CREW_INIT_GROUP      = var.access_group_name
      USER_EMAILS          = join(" ", var.users_to_invite)
      SERVICE_ID           = var.account_service_id
      TRUSTED_PROFILE_NAME = var.trusted_profile_name
    }
  }
}
