terraform {
  required_version = ">= 1.3.0"

  # Ensure that there is always 1 example locked into the lowest provider version of the range defined in the main
  # module's version.tf (basic example), and 1 example that will always use the latest provider version (advanced example).
  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = ">= 1.65.0, < 2.0.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.13.0"
    }
    external = {
      source  = "hashicorp/external"
      version = "~> 2.3.2"
    }
  }
}
