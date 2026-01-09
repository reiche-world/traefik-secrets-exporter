# traefik-secrets-exporter

![Version: 0.0.0](https://img.shields.io/badge/Version-0.0.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.0.0](https://img.shields.io/badge/AppVersion-0.0.0-informational?style=flat-square)

Extracts certificates from acme.json and provides them as Kubernetes secrets via. CronJob.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| cronjob.extract | list | `[{"fqdn":"www.example.com","namespace":"www"}]` | Extract map |
| cronjob.extract[0].fqdn | string | `"www.example.com"` | FQDN of certificate that matches domain.main in acme.json |
| cronjob.extract[0].namespace | string | `"www"` | Target namespace for the TLS secret |
| cronjob.schedule | string | `"0 1 * * 0"` | Cronjob schedule to use |
| fullnameOverride | string | `""` |  |
| image.pullPolicy | string | `"IfNotPresent"` | This sets the pull policy for images |
| image.registry | string | `"ghcr.io"` | Registry to use |
| image.repository | string | `"reiche-world/traefik-secrets-exporter"` | Image repository |
| image.tag | string | `""` | Overrides the image tag whose default is the chart appVersion |
| nameOverride | string | `""` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.automount | bool | `true` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `"traefik-secrets-exporter"` |  |
| traefik.acmeFilePath | string | `"/data/acme.json"` | Path to acme.json |
| traefik.namespace | string | `"kube-system"` | Namespace that runs Traefik |
| traefik.persistence.existingClaim | string | `"traefik"` | Traefik data persistence claim name |
