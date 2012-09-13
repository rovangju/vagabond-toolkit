#!/bin/bash

source /etc/profile.d/aws-apitools-common.sh

FS="/srv"
VOL="vol-00000000"
VOLDESC="DATA ROOT"
SOAPKEY="/root/credentials/soap.string"


echo "Snapshotting Vol $VOLDESC - $VOL"

/root/scripts/ec2-consistent-snapshot \
--aws-credentials-file $SOAPKEY \
--region "us-east-1" \
--description "$VOLDESC" \
--freeze-filesystem $FS \
$VOL


echo "Pruning old..."
/root/scripts/ec2-prune-snapshots \
--aws-credentials-file $SOAPKEY \
--region "us-east-1" \
--weeks 4 \
--days 7 \
$VOL
