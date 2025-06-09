resource "ibm_iam_policy_template" "init_service_id_user_api_key_creator_policy_template" {
  name        = "init-service-id-user-api-key-creator-policy"
  description = "Policy template for service ID and user API key creation."
  committed   = true

  policy {
    type  = "access"
    roles = ["Administrator", "Service ID creator", "User API key creator"]
    resource {
      attributes {
        key      = "serviceName"
        value    = "iam-identity"
        operator = "stringEquals"
      }
    }
  }
}

resource "ibm_iam_policy_template" "init_all_services_policy_template" {
  name        = "init-all-services-policy"
  description = "Policy template for all services."
  committed   = true

  policy {
    type  = "access"
    roles = ["Administrator", "Manager"]
    resource {
      attributes {
        key      = "serviceType"
        value    = "service" # This explicitly refers to "All IAM-enabled services" (user-provisioned services)
        operator = "stringEquals"
      }
    }
  }
}

resource "ibm_iam_policy_template" "init_all_platform_services_policy_template" {
  name        = "init-all-platform-services-policy"
  description = "Policy template for all platform services."
  committed   = true

  policy {
    type  = "access"
    roles = ["Administrator"]
    resource {
      attributes {
        key      = "serviceType"
        value    = "platform_service"
        operator = "stringEquals"
      }
    }
  }
}

resource "ibm_iam_policy_template" "init_resource_group_policy_template" {
  name        = "init-resource-group-policy"
  description = "Policy template for resource groups."
  committed   = true

  policy {
    type  = "access"
    roles = ["Administrator"]
    resource {
      attributes {
        key      = "resourceType"
        value    = "resource-group"
        operator = "stringEquals"
      }
    }
  }
}

resource "ibm_iam_policy_template" "init_secrets_manager_policy_template" {
  name        = "init-secrets-manager-policy"
  description = "Policy template for Secrets Manager."
  committed   = true

  policy {
    type  = "access"
    roles = ["Viewer", "Writer", "Reader", "SecretsReader"]
    resource {
      attributes {
        key      = "serviceName"
        value    = "secrets-manager"
        operator = "stringEquals"
      }
    }
  }
}

resource "ibm_iam_access_group_template" "initial_access_group_template" {
  name        = var.access_group_template_name
  description = var.access_group_template_description
  group {
    name        = var.access_group_name
    description = var.access_group_description
    action_controls {
      access {
        add = true
      }
    }
    members {
      action_controls {
        add    = true
        remove = true
      }
    }
  }

  policy_template_references {
    id      = split("/", ibm_iam_policy_template.init_service_id_user_api_key_creator_policy_template.id)[0]
    version = ibm_iam_policy_template.init_service_id_user_api_key_creator_policy_template.version
  }
  policy_template_references {
    id      = split("/", ibm_iam_policy_template.init_all_services_policy_template.id)[0]
    version = ibm_iam_policy_template.init_all_services_policy_template.version
  }
  policy_template_references {
    id      = split("/", ibm_iam_policy_template.init_all_platform_services_policy_template.id)[0]
    version = ibm_iam_policy_template.init_all_platform_services_policy_template.version
  }
  policy_template_references {
    id      = split("/", ibm_iam_policy_template.init_resource_group_policy_template.id)[0]
    version = ibm_iam_policy_template.init_resource_group_policy_template.version
  }
  policy_template_references {
    id      = split("/", ibm_iam_policy_template.init_secrets_manager_policy_template.id)[0]
    version = ibm_iam_policy_template.init_secrets_manager_policy_template.version
  }
  committed = true
}
