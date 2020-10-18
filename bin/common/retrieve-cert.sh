#!/bin/sh
#
# usage: retrieve-cert.sh remote.host.name [port]
#
REMHOST=$1
REMPORT=${2:-443}

if [ ! $1 ]; then
	echo "usage: retrieve-cert.sh remote.host.name [port]"
	exit 1
fi

echo |\
openssl s_client -showcerts -servername ${REMHOST} -connect ${REMHOST}:${REMPORT} 2>&1 |\
openssl x509 -text |\
sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p'
