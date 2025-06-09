output "template_id" {
  description = "The template ID of the access group template."
  value       = ibm_iam_access_group_template.initial_access_group_template.id
}

output "template_version" {
  description = "The template version of the access group template."
  value       = ibm_iam_access_group_template.initial_access_group_template.version
}

output "template_access_group_name" {
  description = "The access group name under the template to assign to sub accounts."
  value       = ibm_iam_access_group_template.initial_access_group_template.group[0].name
}
