output "database_initiative_id" {
  description = "Resource ID of the custom initiative."
  value       = azurerm_policy_set_definition.databases_private_only.id
}

output "assignment_ids" {
  description = "Resource IDs of the policy assignments."
  value = {
    allowed_locations      = try(azurerm_subscription_policy_assignment.allowed_locations[0].id, null)
    require_owner_tag      = azurerm_subscription_policy_assignment.require_owner_tag.id
    databases_private_only = azurerm_subscription_policy_assignment.databases_private_only.id
  }
}
