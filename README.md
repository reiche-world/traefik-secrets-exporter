# Traefik acme to secrets

Extracts certificates from `acme.json` and provides them as Kubernetes secrets via. CronJob.

## Testing

Test the extraction script via.
```shell
DRY_RUN=1 ./extract.sh test/acme.json test/map.json
```

Build the image
```shell
podman build -t traefik-secrets-exporter:latest .
```

Test the extraction within container:
```shell
podman run -it -v"$(pwd):$(pwd)" -eDRY_RUN=1 traefik-secrets-exporter:latest "$(pwd)/test/acme.json" "$(pwd)/test/map.json"
```

## Update documentation

```shell
helm-docs --skip-version-footer -t charts/README.gotmpl.md
```