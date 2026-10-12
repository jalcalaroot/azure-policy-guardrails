locals {
  scope = "/subscriptions/${var.subscription_id}"

  # Built-in definition IDs (global, identical in every tenant).
  builtin = "/providers/Microsoft.Authorization/policyDefinitions"

  # One built-in policy per database service: all share the same rule
  # (public network access must be disabled) and the same `effect` parameter.
  database_policies = {
    cosmosdb       = { id = "797b37f7-06b8-444c-b1ad-fc62867f335a", service = "Azure Cosmos DB" }
    sql_server     = { id = "1b8ca024-1d5c-4dec-8995-b1a932b41780", service = "Azure SQL Database (logical server)" }
    sql_managed    = { id = "9dfea752-dd46-4766-aed1-c355fa93fb91", service = "Azure SQL Managed Instance" }
    mysql_flexible = { id = "c9299215-ae47-4f50-9c54-8a392f68a052", service = "MySQL flexible server" }
    postgres_flex  = { id = "5e1de0e3-42cb-4ebc-a86d-61d0c619ca48", service = "PostgreSQL flexible server" }
    mariadb        = { id = "fdccbe47-f3e3-4213-ad5d-ea459b2fa077", service = "MariaDB server" }
    redis          = { id = "470baccb-7e51-4549-8b1a-3e5be069f663", service = "Azure Cache for Redis" }
  }
}
