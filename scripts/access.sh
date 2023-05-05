#!/usr/bin/env bash

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Open up ports from the remote host
# and access applications on your local machine
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

set -eou pipefail

export KUBECONFIG="terraform/kube/config"

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Kibana
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

KIBANA_PORT=5601

kill -9 "$(lsof -t -i:$KIBANA_PORT)" || true
sleep 2s
kubectl port-forward --namespace elastic service/kibana $KIBANA_PORT:$KIBANA_PORT &> /dev/null &

elasticsearch_username=$(cd terraform && terraform output -raw elasticsearch_username)
elasticsearch_password=$(cd terraform && terraform output -raw elasticsearch_password)

echo
echo "Kibana: http://127.0.0.1:${KIBANA_PORT}/"
echo "${elasticsearch_username}/${elasticsearch_password}"
echo

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# NiFi
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

NIFI_PORT=8443

kill -9 "$(lsof -t -i:$NIFI_PORT)" || true
sleep 2s
kubectl port-forward --namespace nifi service/nifi $NIFI_PORT:$NIFI_PORT &> /dev/null &

echo
echo "NiFi: https://127.0.0.1:${NIFI_PORT}/nifi/"
echo "admin/p@ssword"
echo
