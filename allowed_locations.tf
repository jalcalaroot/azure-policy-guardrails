# Policy 1 - Close regions. Built-in "Allowed locations" (effect Deny).
# Limits the blast radius of a mistake and avoids charges in forgotten regions.
resource "azurerm_subscription_policy_assignment" "allowed_locations" {
  count = var.create_allowed_locations ? 1 : 0

  name                 = "guardrails-allowed-locations"
  display_name         = "Guardrails: allowed locations"
  subscription_id      = local.scope
  policy_definition_id = "${local.builtin}/e56962a6-4747-49cd-b67b-bf8b01975c4c"

  parameters = jsonencode({
    listOfAllowedLocations = { value = var.allowed_locations }
  })
}
