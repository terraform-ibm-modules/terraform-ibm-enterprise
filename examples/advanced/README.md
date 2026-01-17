# Advanced example

<!-- BEGIN SCHEMATICS DEPLOY HOOK -->
<a href="https://cloud.ibm.com/schematics/workspaces/create?workspace_name=enterprise-advanced-example&repository=https://github.com/terraform-ibm-modules/terraform-ibm-enterprise/tree/main/examples/advanced"><img src="https://img.shields.io/badge/Deploy%20with IBM%20Cloud%20Schematics-0f62fe?logo=ibm&logoColor=white&labelColor=0f62fe" alt="Deploy with IBM Cloud Schematics" style="height: 16px; vertical-align: text-bottom;"></a>
<!-- END SCHEMATICS DEPLOY HOOK -->


This is a complete example to create enterprise child account with owner IAM policies. This example will create below resources -

Create new enterprise child account-groups.
Create new enterprise child accounts, if `add_owner_iam_policies` field is set in account inputs, account will have  owner IAM policies.
Create new trusted profile template for the enterprise.
Assign the trusted profile template to the new sub accounts that needs to invite users.
Create new access group template to be assigned to sub accounts that provide new invited users the initial access.
Runs a script to login to each sub account and invite users using their email IDs.
Create a new Secrets Manager instance if one is not passed in and configure it with a private cert engine.
Create a new arbitary secret with the value set as iam_apikey value.

<!-- BEGIN SCHEMATICS DEPLOY TIP HOOK -->
:information_source: Ctrl/Cmd+Click or right-click on the Schematics deploy button to open in a new tab
<!-- END SCHEMATICS DEPLOY TIP HOOK -->
