#!/usr/bin/env bash

set -i 
set -o pipefail

REGION=
RDSHOST=
RDSUSER=
TOKEN="$(aws rds generate-db-auth-token --hostname ${RDSHOST} --port 3306 --region ${REGION} --username ${RDSUSER})"
mysql -v --host=${RDSHOST} --port=3306 --ssl --user=${RDSUSER} --password=${TOKEN}

