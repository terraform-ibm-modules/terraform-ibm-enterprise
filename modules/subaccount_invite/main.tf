resource "ibm_iam_access_group" "init_access_group" {
  name        = var.access_group_name
  description = "Restricted for automation to manage resources in the account via terraform/automation"
}

resource "ibm_iam_access_group_policy" "crew_init_service_id_user_api_key_creator_policy" {
  access_group_id = ibm_iam_access_group.init_access_group.id
  roles           = ["Administrator", "Service ID creator", "User API key creator"]

  resources {
    service = "iam-identity"
  }
}

resource "ibm_iam_access_group_policy" "crew_init_all_services_policy" {
  access_group_id = ibm_iam_access_group.init_access_group.id
  roles           = ["Administrator", "Manager"]

  resources {
    service_type = "service"
  }
}

resource "ibm_iam_access_group_policy" "crew_init_all_platform_services_policy" {
  access_group_id    = ibm_iam_access_group.init_access_group.id
  roles              = ["Administrator"]
  account_management = true
}

resource "ibm_iam_access_group_policy" "crew_init_resource_group_policy" {
  access_group_id = ibm_iam_access_group.init_access_group.id
  roles           = ["Administrator"]

  resources {
    resource_type = "resource-group"
  }
}

resource "ibm_iam_access_group_policy" "crew_init_secrets_manager_policy" {
  access_group_id = ibm_iam_access_group.init_access_group.id
  roles           = ["Viewer", "Writer", "Reader", "SecretsReader"]

  resources {
    service = "secrets-manager"
  }
}

resource "ibm_iam_access_group_template" "initial_access_group_template" {
  name        = "initial-access-group"
  description = "The initial access group for assigning to newly invited users."
  group {
    name        = "add-users"
    description = "Add new users"
    action_controls {
      access {
        add = true
      }
    }
  }
  policy_template_references {
    id      = ibm_iam_access_group.init_access_group.id
    version = ibm_iam_access_group.init_access_group.version
  }
}

resource "ibm_iam_access_group_template_assignment" "iam_access_group_template_assignment_instance" {
  target           = var.account_id
  target_type      = "Account"
  template_id      = ibm_iam_access_group_template.initial_access_group_template.id
  template_version = ibm_iam_access_group_template.initial_access_group_template.version
}

resource "null_resource" "invite_user" {
  depends_on = [
    ibm_iam_access_group.init_access_group,
    ibm_iam_access_group_template.initial_access_group_template,
  ibm_iam_access_group_template_assignment.iam_access_group_template_assignment_instance]
  provisioner "local-exec" {
    command = "${path.module}/invite-user.sh"
    environment = {
      API_KEY         = var.account_iam_apikey
      CREW_INIT_GROUP = var.access_group_name
      USER_EMAILS     = join(" ", var.users_to_invite)
    }
  }
}
