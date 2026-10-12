# azure-policy-guardrails - contexto del proyecto

Repo público con 3 guardrails de Azure Policy en Terraform, creado el 2026-10-12 a partir de una conversación sobre qué políticas aplicar en la suscripción de laboratorio.

## Decisiones

- **Solo built-ins**: no hay lógica de reglas propia que mantener. Los IDs se leyeron del catálogo con `az policy definition list`.
- **Política 1 (regiones)**: la suscripción ya tenía una asignación manual de *Allowed locations* (solo `eastus`, creada 2026-09-06). Por eso `create_allowed_locations` existe: poner `false` evita duplicarla.
- **Política 2 (etiqueta Owner)**: la definición es siempre `deny`; el modo "solo reportar" se logra con `enforce = false` en la asignación (`DoNotEnforce`).
- **Política 3 (bases de datos)**: no existe un built-in único para "cualquier base de datos"; se agrupan 7 built-ins por servicio en una iniciativa custom. Ninguna política puede evaluar la exposición de la **subnet** (evalúa un recurso a la vez), solo `publicNetworkAccess` de la base de datos. Ver `docs/databases.md`.
- **Todo arranca en Audit/DoNotEnforce**: ver "Safe rollout" en el README.

## Estado

- `terraform validate` y `fmt` limpios; `plan` de solo lectura contra la suscripción de laboratorio: 4 recursos a crear (iniciativa con 7 referencias y 3 asignaciones), sin errores.
- **No se ha aplicado nada.** La validación del servidor (que Azure acepte los parámetros) solo ocurre al hacer `apply`.
- Hallazgos de la revisión previa de la suscripción: 2 asignaciones existentes (*Allowed locations* y la iniciativa *ASC Default* de Defender for Cloud, 216 políticas), 0 definiciones custom, 0 exenciones.
