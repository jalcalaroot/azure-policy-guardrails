# Azure Policy Guardrails

[![OpenSSF Scorecard](https://api.scorecard.dev/projects/github.com/jalcalaroot/azure-policy-guardrails/badge)](https://scorecard.dev/viewer/?uri=github.com/jalcalaroot/azure-policy-guardrails)

Three small, practical **Azure Policy** examples written as Terraform, meant for a personal or lab subscription. They use Microsoft's built-in definitions, so there is no custom rule logic to maintain, and they are safe to roll out: everything starts in report-only mode.

## The policies

| # | Guardrail | Built-in definition | Default here |
|---|---|---|---|
| 1 | **Close regions**: resources can only be created in the listed regions | `Allowed locations` (`e56962a6-4747-49cd-b67b-bf8b01975c4c`) | `eastus`, effect Deny |
| 2 | **Ownership**: every resource group must carry a tag (default `Owner`) | `Require a tag on resource groups` (`96670d01-0a4d-4649-9c89-2d3abc0a5025`) | Report only (`DoNotEnforce`) |
| 3 | **Databases are never publicly reachable**: public network access must be disabled on Cosmos DB, SQL, MySQL, PostgreSQL, MariaDB and Redis | Custom initiative grouping 7 built-ins (see [docs/databases.md](docs/databases.md)) | Effect `Audit` |

Policy 3 answers "can a database ever be deployed so that it is reachable from the internet?" with the closest thing Azure offers today. Read [docs/databases.md](docs/databases.md) for what it covers and what it cannot.

## Usage

```bash
az login
export TF_VAR_subscription_id="<subscription-id>"   # never commit it

terraform init
terraform plan
terraform apply
```

Variables worth knowing (all in [`variables.tf`](variables.tf), example in [`examples/terraform.tfvars.example`](examples/terraform.tfvars.example)):

| Variable | Default | Notes |
|---|---|---|
| `allowed_locations` | `["eastus"]` | `global` resources are already excluded by the definition |
| `create_allowed_locations` | `true` | Set to `false` if the subscription already has an *Allowed locations* assignment |
| `required_tag_name` | `Owner` | |
| `enforce_required_tag` | `false` | `true` denies resource groups without the tag |
| `database_policy_effect` | `Audit` | `Audit`, `Deny` or `Disabled` |

## Safe rollout

1. Apply with the defaults (policy 1 enforces, 2 and 3 only report).
2. Wait for the compliance report (it can take a while) and fix what it flags.
3. Set `enforce_required_tag = true` and `database_policy_effect = "Deny"` when the report is clean.

Watch out for these when moving to `Deny`:

- A storage account for Terraform state that is public on purpose (for example reached by GitHub Actions over OIDC) will be flagged by public-access policies. This repo does not include one, but keep it in mind if you add it.
- Deployment flows that open public access temporarily (such as publishing code to a private Function App) are blocked by `Deny` on public network access.
- `Require a tag on resource groups` also blocks Terraform runs that create untagged resource groups.

## Cost

Azure Policy has no cost. Assignments and definitions are free; the compliance scans do not bill.

## Cleanup

`terraform destroy` removes the three assignments and the initiative. Nothing else is created.

## CI

GitHub Actions run `terraform fmt -check`, `terraform validate`, gitleaks and OpenSSF Scorecard. There is no deployment pipeline: policies are applied by hand.

## Disclaimer

Personal examples for learning, not a compliance baseline. Review every definition before assigning it to a subscription you care about.
