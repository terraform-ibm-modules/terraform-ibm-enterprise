# Configuring Users to Invite

The `users_to_invite` input variable allows you to invite users to an enterprise account and assign them to existing access group(s).

- Variable name: `users_to_invite`.
- Type: A list of objects.
- Default value: An empty list (`[]`).

### Options for users_to_invite

- `email` (required): The email ID of the user to be invited.
- `exisiting_access_groups` (optional): (List) A list of names of existing access groups to which the user will be assigned. If empty list is passed then user will only be invited to the sub account and will not be assigned to any access group.

### Example Configuration for Users to Invite

```hcl
[
  {
    email                   = "user1@example.com"
    exisiting_access_groups = ["Developers", "Auditors"]
  },
  {
    email                   = "user2@example.com"
    exisiting_access_groups = ["Support Team"]
  }
]
```
