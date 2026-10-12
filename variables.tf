variable "subscription_id" {
  description = "Subscription where the policies are assigned. Pass it with TF_VAR_subscription_id; never commit it."
  type        = string
}

variable "create_allowed_locations" {
  description = "Create the Allowed locations assignment. Set to false if the subscription already has one."
  type        = bool
  default     = true
}

variable "allowed_locations" {
  description = "Regions where resources may be created. Resources with location 'global' are already excluded by the built-in definition."
  type        = list(string)
  default     = ["eastus"]
}

variable "required_tag_name" {
  description = "Tag that every resource group must carry."
  type        = string
  default     = "Owner"
}

variable "enforce_required_tag" {
  description = "false = the assignment only reports (DoNotEnforce); true = resource groups without the tag are denied."
  type        = bool
  default     = false
}

variable "database_policy_effect" {
  description = "Effect of the databases initiative. Start with Audit, move to Deny once the compliance report is clean."
  type        = string
  default     = "Audit"

  validation {
    condition     = contains(["Audit", "Deny", "Disabled"], var.database_policy_effect)
    error_message = "database_policy_effect must be Audit, Deny or Disabled."
  }
}
