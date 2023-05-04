#!/usr/bin/env bash

set -eoux pipefail

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# In order to have a K8S environment to work,
# execute this script from the remote host.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

source scripts/set-env.sh

minikube stop
minikube delete

minikube start --driver=docker \
  --memory=8000 \
  --cpus=2 \
  --apiserver-ips="$REMOTE_HOST" \
  --listen-address="0.0.0.0"

minikube update-context
