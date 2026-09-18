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

if [ -f "${V_ADMIN_DIR}/_env.sh" ]; then
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
HELM_CLI_NAME=helm-${OS_ARCH}-amd64.tar.gz
HELM_CLI_URL="https://mirror.openshift.com/pub/openshift-v4/clients/helm/${HELM_VERSION}/${HELM_CLI_NAME}"
HELM_CLI_FILE=${WORKDIR}/${HELM_CLI_NAME}
HELM_CLI_HOME=${WORKDIR}/helm-${HELM_VERSION}
mkdir -p ${WORKDIR}
mkdir -p ${HELM_CLI_HOME}

if [ -f ${HELM_CLI_FILE} ]; then
  warn "The ${HELM_CLI_FILE} file exists"
else
  msg "Downloading ${HELM_CLI_URL} on $WORKDIR"
  #curl -L https://mirror.openshift.com/pub/openshift-v4/clients/helm/latest/helm-linux-amd64 -o /usr/local/bin/helm
  # chmod +x /usr/local/bin/helm
  curl -Lk "${HELM_CLI_URL}" -o "$HELM_CLI_FILE"
fi

# Step 4: Extract the tar file
tar zxvf "${HELM_CLI_FILE}" -C ${HELM_CLI_HOME}

# Step 5: Create symbolic link
HELM_CLI_LOCAL=/usr/local/bin/helm
HELM_CLI=${HELM_CLI_HOME}/helm-${OS_ARCH}-amd64
create_sym_link ${HELM_CLI} ${HELM_CLI_LOCAL}

helm version

exit 0

# EOF
