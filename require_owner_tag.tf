# Policy 2 - Ownership. Built-in "Require a tag on resource groups".
# The definition always denies; `enforce = false` turns the assignment into a
# report-only one (DoNotEnforce) so it can be rolled out safely first.
resource "azurerm_subscription_policy_assignment" "require_owner_tag" {
  name                 = "guardrails-require-tag-on-rg"
  display_name         = "Guardrails: resource groups must have the ${var.required_tag_name} tag"
  subscription_id      = local.scope
  policy_definition_id = "${local.builtin}/96670d01-0a4d-4649-9c89-2d3abc0a5025"
  enforce              = var.enforce_required_tag

  parameters = jsonencode({
    tagName = { value = var.required_tag_name }
  })
}
