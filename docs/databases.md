# Databases that are never publicly reachable

The question: *is there a policy that stops any database from being deployed so that it is reachable from the internet?*

## Short answer

There is **no single built-in policy for "any database"**. Azure offers one built-in per service, all with the same rule: **public network access must be disabled**, so the database is only reachable through a Private Endpoint or VNet injection. This repo groups them in one initiative so they are assigned, reported and switched from `Audit` to `Deny` together.

## What the initiative covers

| Service | Built-in definition | ID |
|---|---|---|
| Azure Cosmos DB | Azure Cosmos DB should disable public network access | `797b37f7-06b8-444c-b1ad-fc62867f335a` |
| Azure SQL Database (logical server) | Public network access on Azure SQL Database should be disabled | `1b8ca024-1d5c-4dec-8995-b1a932b41780` |
| Azure SQL Managed Instance | Azure SQL Managed Instances should disable public network access | `9dfea752-dd46-4766-aed1-c355fa93fb91` |
| MySQL flexible server | Public network access should be disabled for MySQL flexible servers | `c9299215-ae47-4f50-9c54-8a392f68a052` |
| PostgreSQL flexible server | Public network access should be disabled for PostgreSQL flexible servers | `5e1de0e3-42cb-4ebc-a86d-61d0c619ca48` |
| MariaDB server | Public network access should be disabled for MariaDB servers | `fdccbe47-f3e3-4213-ad5d-ea459b2fa077` |
| Azure Cache for Redis | Azure Cache for Redis should disable public network access | `470baccb-7e51-4549-8b1a-3e5be069f663` |

All seven accept the effects `Audit`, `Deny` and `Disabled` and default to `Audit`. These IDs were read from the built-in catalogue with `az policy definition list` on 2026-10-12.

## What it cannot do

The original wish was "never deploy a database in a subnet that has internet access". A policy cannot express that:

- A policy evaluates **one resource at a time**. It can read the properties of the database, but it cannot follow the link to the subnet and then to the network security group attached to that subnet.
- So the guardrail works on the **database itself** (`publicNetworkAccess`), not on the **subnet's exposure**.
- The two are not the same thing. A database with public access disabled is not reachable from the internet, but the policy does not check whether other resources in its subnet are.

What to combine with it if the subnet matters:

- Policies on subnets and network security groups from the Microsoft cloud security benchmark (for example subnets must be associated with a network security group). They are part of the *ASC Default* initiative that Defender for Cloud assigns.
- Network design: Private Endpoints in a dedicated subnet, no public IPs, and no `Internet` source in inbound rules.

## Services not covered

- Azure Synapse workspaces and other data services have their own built-ins (for example `38d8df46-cf4e-4073-8e03-48c24b29de0d` for Synapse). Add them to `local.database_policies` if you use them.
- Database engines you run yourself on virtual machines are not databases to Azure Policy: they are VMs.

## Fixing what already exists

`Audit` and `Deny` do not change existing resources. The built-in `Modify` variants do (for example `Configure CosmosDB accounts to disable public network access`, `da69ba51-aaf1-41e5-8651-607cd0b37088`), but they need a managed identity on the assignment and a remediation task. They are intentionally left out of this repo.
