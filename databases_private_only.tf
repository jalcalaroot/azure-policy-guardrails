# Policy 3 - Databases are never publicly reachable.
# There is no single built-in for "any database", so a custom initiative groups
# the per-service built-ins that all enforce the same rule: public network
# access disabled (private endpoint or VNet injection only).
resource "azurerm_policy_set_definition" "databases_private_only" {
  name         = "guardrails-databases-private-only"
  display_name = "Guardrails: databases must not allow public network access"
  description  = "Groups the built-in policies that require public network access to be disabled on database services."
  policy_type  = "Custom"

  metadata = jsonencode({ category = "Guardrails" })

  parameters = jsonencode({
    effect = {
      type          = "String"
      allowedValues = ["Audit", "Deny", "Disabled"]
      defaultValue  = "Audit"
      metadata      = { displayName = "Effect" }
    }
  })

  dynamic "policy_definition_reference" {
    for_each = local.database_policies

    content {
      policy_definition_id = "${local.builtin}/${policy_definition_reference.value.id}"
      reference_id         = policy_definition_reference.key
      parameter_values     = jsonencode({ effect = { value = "[parameters('effect')]" } })
    }
  }
}

resource "azurerm_subscription_policy_assignment" "databases_private_only" {
  name                 = "guardrails-databases-private-only"
  display_name         = "Guardrails: databases private only"
  subscription_id      = local.scope
  policy_definition_id = azurerm_policy_set_definition.databases_private_only.id

  parameters = jsonencode({
    effect = { value = var.database_policy_effect }
  })
}
