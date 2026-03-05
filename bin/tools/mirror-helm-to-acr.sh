#!/usr/bin/env bash

# Reads a list of bitnami charts from local file 'helm' that follows this format:
# <chart> <vers>
#
# e.g.:
# redis 20.3.0
# thanos 17.2.3
#
# It will then mirror the chart and version up into the ACR registry provided, e.g.:
#
# oci://foo.azurecr.io/helm/redis

set -e
set -o pipefail

: "${REG:=$1}"

[ ! ${REG} ] && echo "Need to pass ACR registry name" && exit 1

echo "Logging in to helm registry..."

USER_NAME="00000000-0000-0000-0000-000000000000"
PASSWORD=$(az acr login --name ${REG} --expose-token --output tsv --query accessToken)

helm registry login ${REG}.azurecr.io \
	--username="${USER_NAME}" \
	--password="${PASSWORD}"

echo "Processing list..."

while read i; do
	chart="${i/ */}"
	vers="${i/* /}"
	echo "Chart: ${chart}	Version: ${vers}"
	helm pull "${chart}" --version "${vers}"
	helm push "${chart##*/}-${vers}.tgz" oci://${REG}.azurecr.io/helm
done <helm
