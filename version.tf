terraform {
  required_version = ">= 1.3.0"

  # Each required provider's version should be a flexible range to future proof the module's usage with upcoming minor and patch versions.
  required_providers {
    # The below tflint-ignore is required because although the below provider is not directly required by the root level module,
    # it is required by consuming submodules, and if not set here, the top level module calling this module will not be
    # able to set alternative alias for the provider.

    # tflint-ignore: terraform_unused_required_providers
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = ">= 1.54.0, < 2.0.0"
    }
  }
}
