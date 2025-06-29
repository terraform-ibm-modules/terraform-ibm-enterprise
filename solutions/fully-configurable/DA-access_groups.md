Configuring Access Groups

The `access_groups` input variable allows you to define and configure multiple access groups within the new created enterprise sub account. Access groups are used to manage user permissions efficiently by grouping users and assigning policies to the group rather than individual users.

- Variable name: `access_groups`.
- Type: A map of objects. Each key in the map represents a unique identifier for an access group configuration.
- Default value: An empty map (`{}`).

### Options for access_groups

Each entry in the access_groups map is an object with the following properties:

- `access_group_name` (required): The name of the access group to be created.
- `add_members` (optional): (Boolean) Specifies whether members should be added to this access group. Defaults to `false` as the members will be added to each during invitation based on `users_to_invite` variable.
 - `dynamic_rules` (optional): (Map) Configuration for dynamic membership rules based on identity provider attributes. Each key in this map can be a unique identifier for a dynamic rule.

   Options for dynamic_rules object:
   - `expiration` (required): The duration that a user is a member of the group before the access group membership is re-evaluated.
   - `identity_provider` (required): The identity provider that the rule applies to.
   - `conditions` (required): (List) A list of conditions that must be met for a user to be dynamically added to the group.

     Options for conditions object:
     - `claim` (required): The name of the claim from the identity provider.
     - `operator` (required): The operator to use for evaluating the claim (e.g., EQUALS, CONTAINS).
     - `value` (required): The value to compare against the claim.
- `policies` (optional): (Map) Configuration for access policies to be attached to the access group. Each key in this map can be a unique identifier for a policy.

  Options for policies object:
  - `roles` (required): (List of Strings) A list of IBM Cloud IAM roles to assign (e.g., Viewer, Editor, Administrator).
  - `account_management` (optional): (Boolean) Set to true if the policy grants access to account management services (e.g., managing users, billing). If false or not set, the policy applies to resource services.
  - `tags` (required): (Set of Strings) A set of tags that this policy is associated with.
  - `resources` (optional): (List) A list of resources to which the policy applies. If omitted, the policy applies to all resources.

    Options for resources object:
    - `region` (optional): The region of the resource.
    - `attributes` (optional): (Map) Map of resource attributes (e.g., instanceId, planId).
    - `service` (optional): The name of the service (e.g., kms, cloud-object-storage).
    - `resource_instance_id` (optional): The ID of a specific resource instance.
    - `resource_type` (optional): The type of resource (e.g., instance, bucket).
    - `resource` (optional): A specific resource within a service (e.g., a specific key in KMS).
    - `resource_group_id` (optional): The ID of the resource group the resource belongs to.
  - `resource_attributes` (optional): (List) A list of attributes that apply to the resources.

    Options for resource_attributes object:
    - `name` (required): The name of the attribute (e.g., serviceName).
    - `value` (required): The value of the attribute (e.g. iam-identity).
    - `operator` (optional): The operator to use for evaluating the attribute (e.g., stringEquals).

### Example Configuration for Access Groups

```hcl
{
  "developers-ag" = {
    access_group_name = "Developers"
    add_members       = false
    dynamic_rules = {
      "dev-sso-rule" = {
        expiration        = 24
        identity_provider = "IBMid"
        conditions = [
          {
            claim    = "group"
            operator = "EQUALS"
            value    = "devteam"
          }
        ]
      }
    }
    policies = {
      "viewer-policy" = {
        roles = ["Viewer"]
        tags  = ["goldeneye", "team-alpha"]
        resource_attributes = [{
            name      = "serviceName"
            value     = "iam-identity"
            operator  = "stringEquals"
        }]
      },
      "admin-policy" = {
        roles = ["Administrator"]
        tags  = ["goldeneye", "team-alpha"]
        resource_attributes = [{
            name      = "service_group_id"
            value     = "IAM"
            operator  = "stringEquals"
        }]
      }
    }
  }
}
```
