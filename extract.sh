#!/usr/bin/env sh

set -e

ACME_FILE=$1
MAP_FILE=$2

jq -c '.[] | {fqdn, namespace}' ${MAP_FILE} | while read -r line; do
    fqdn=$(echo "${line}" | jq -r '.fqdn')
    namespace=$(echo "${line}" | jq -r '.namespace')
    cert_file="${fqdn}.crt"
    key_file="${fqdn}.key"
    secret_file="${fqdn}.yaml"
    secret_name="${fqdn}-tls"

    echo "Extract ${fqdn} to Secret ${namespace}.${secret_name}"

    jq -r --arg d "${fqdn}" '.[].Certificates[] | select(.domain.main==$d) | .certificate' "${ACME_FILE}" > "${cert_file}.b64"
    jq -r --arg d "${fqdn}" '.[].Certificates[] | select(.domain.main==$d) | .key' "${ACME_FILE}" > "${key_file}.b64"

    base64 -d "${cert_file}.b64" > "${cert_file}"
    base64 -d "${key_file}.b64" > "${key_file}"

    kubectl create secret tls "${secret_name}" \
        --namespace "${namespace}" \
        --cert="${cert_file}" \
        --key="${key_file}" \
        --dry-run=client -o yaml > "${secret_file}"

    if [ -z "${DRY_RUN}" ]; then
      kubectl apply -f "${secret_file}"
      rm "${cert_file}" "${cert_file}.b64" "${key_file}" "${key_file}.b64" "${secret_file}"
    fi

done
