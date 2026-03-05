#!/usr/bin/env bash

# Inputs:
# ${1} - image list
# ${2} - ACR name
#
# e.g.: ./<script.sh images.txt foo
#
# Script reads a list of container images from file passed in and copies them into the ACR registry.
#
# The file is just a list of full image coordinates, e.g.:
#
# docker.io/bitnamilegacy/mongodb:6.0.10-debian-11-r8
# docker.io/bitnamilegacy/redis:7.4.1
#
# These will be pushed to your registry, 'foo':
#
# foo.azurecr.io/bitnamilegacy/redis:7.4.1
#

set -e
set -o pipefail
set -x

: "${IMGFILE:=$1}"
: "${REG:=$2}"


[ ! ${IMGFILE} ] && echo "Need to pass image list file" && exit 1
[ ! ${REG} ] && echo "Need to pass ACR registry name" && exit 1


for imgSrc in $(cat ${IMGFILE}); do
	echo "Copying ${imgSrc}"
	imgPath=${imgSrc#*\/}
	imgTarget="${REG}.azurecr.io/${imgPath}"
	echo "Target ${imgTarget}"

	skopeo copy "docker://${imgSrc}" "docker://${imgTarget}" --multi-arch all

done
