#!/usr/bin/env sh

set -e

ACME_FILE=$1
MAP_FILE=$2

base64_version=$(base64 --version 2>&1 || true)

case ${base64_version} in
  *"FreeBSD"*) base64_freebsd=1 ;;
esac

base64_decode() {
  file="$1"
  if [ -n "${base64_freebsd}" ]; then
    base64 -d -i "${file}.b64" -o "${file}"
  else
    base64 -d "${file}.b64" > "${file}"
  fi
}

jq -c '.[] | {fqdn, namespace, secretName}' ${MAP_FILE} | while read -r line; do
    fqdn=$(echo "${line}" | jq -r '.fqdn')
    namespace=$(echo "${line}" | jq -r '.namespace')
    secret_name="$(echo "${line}" | jq -r '.secretName')"
    if [ ${secret_name} == "null" ]; then
      secret_name="${fqdn}-tls"
    fi
    cert_file="${fqdn}.crt"
    key_file="${fqdn}.key"
    secret_file="${fqdn}.yaml"

    jq -r --arg d "${fqdn}" '.[].Certificates[] | select(.domain.main==$d) | .certificate' "${ACME_FILE}" > "${cert_file}.b64"

    if [ ! -s "${cert_file}.b64" ]; then
      echo "Warning: ${ACME_FILE}:${fqdn} not found"
      continue
    else
      echo "Extract ${ACME_FILE}:${fqdn} to ${namespace}/secret/${secret_name}"
    fi

    jq -r --arg d "${fqdn}" '.[].Certificates[] | select(.domain.main==$d) | .key' "${ACME_FILE}" > "${key_file}.b64"
    base64_decode "${cert_file}"
    base64_decode "${key_file}"

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
