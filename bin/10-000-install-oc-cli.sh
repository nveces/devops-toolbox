#!/bin/bash
#
# ============================================================
#
#
#
#
# Created-------: 20260401
# ============================================================
# Description---:
#
#
# ============================================================
# Pre Steps---:
# chmod 774 *.sh
#
#
# EOH

#set -euo pipefail
set -uo pipefail

# Step 1: Set current DIR and default variables:
V_ADMIN_DIR=$(dirname $0)

source ${V_ADMIN_DIR}/00-functions.sh

if [ -f ${V_ADMIN_DIR}/_env.sh ]; then
  source ${V_ADMIN_DIR}/_env.sh
fi

# Step 2: Check prerequisites
# if (( EUID != 0 )); then
#   err "Please, run this command with sudo" 1>&2
#   exit 1
# else
#   msg "I'm sudo"
# fi

if ((BASH_VERSINFO[0] < 4)); then
  err "This script requires Bash 4.0 or higher. Please upgrade your Bash version and try again."
  exit 1
fi

WORKDIR="${WORKDIR:-$HOME/ocp}"
OS_ARCH=$(uname)
# lowercase
OS_ARCH=${OS_ARCH,,}

# Step 3: Download
OC_CLI_NAME=openshift-client-${OS_ARCH}-${OCP_VERSION}.tar.gz
OC_CLI_URL="https://mirror.openshift.com/pub/openshift-v4/clients/ocp/${OCP_VERSION}/${OC_CLI_NAME}"
OC_CLI_FILE=$WORKDIR/$OC_CLI_NAME
OC_CLI_HOME=$WORKDIR/oc-cli-${OCP_VERSION}
mkdir -p ${WORKDIR}
mkdir -p ${OC_CLI_HOME}

if [ -f ${OC_CLI_FILE} ]; then
  warn "The ${OC_CLI_FILE} file exists"
else
  msg "Downloading ${OC_CLI_URL} on $WORKDIR"
  curl -k "${OC_CLI_URL}" -o "$OC_CLI_FILE"
fi

# Step 4: Extract the tar file
tar zxvf "${OC_CLI_FILE}" -C ${OC_CLI_HOME}
#rm -f "${OC_CLI_FILE}"

# Step 5: Create symbolic link
OC_CLI_LOCAL=/usr/local/bin/oc
OC_CLI=${OC_CLI_HOME}/oc
create_sym_link ${OC_CLI} ${OC_CLI_LOCAL}
oc version --request-timeout=5s

KUBECTL_LOCAL=/usr/local/bin/kubectl
KUBECTL_CLI=${OC_CLI_HOME}/kubectl
create_sym_link ${KUBECTL_CLI} ${KUBECTL_LOCAL}
kubectl version

exit 0

# EOF
