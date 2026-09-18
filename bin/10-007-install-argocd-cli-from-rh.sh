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

WORKDIR="${WORKDIR:-$HOME/argocd}"
OS_ARCH=$(uname)
# lowercase
OS_ARCH=${OS_ARCH,,}

# Step 3: Download
ARGOCD_VERSION="1.19.0-48"
ARGOCD_CLI_NAME=argocd-${OS_ARCH}-amd64.tar.gz
ARGOCD_CLI_URL="https://developers.redhat.com/content-gateway/file/pub/openshift-v4/clients/openshift-gitops/${ARGOCD_VERSION}/${ARGOCD_CLI_NAME}"
ARGOCD_CLI_FILE=$WORKDIR/${ARGOCD_CLI_NAME}
ARGOCD_CLI_HOME=$WORKDIR/argocd-cli-${ARGOCD_VERSION}
mkdir -p ${WORKDIR}
mkdir -p ${ARGOCD_CLI_HOME}

if [ -f ${ARGOCD_CLI_FILE} ]; then
  warn "The ${ARGOCD_CLI_FILE} file exists"
else
  # Download the matching binary
  msg "Downloading ${ARGOCD_CLI_FILE} on $WORKDIR"
  curl -L "${ARGOCD_CLI_URL}" -o "${ARGOCD_CLI_FILE}"
#  curl -sSL -o argocd-linux-$ARGOCD_ARCH "https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-$ARGOCD_ARCH"
# sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
# rm argocd-linux-amd64
fi

# Step 4: Extract the tar file
tar zxvf "${ARGOCD_CLI_FILE}" -C ${ARGOCD_CLI_HOME}
#rm -f "${ARGOCD_CLI_FILE}"


# Step 5: Create symbolic link
ARGOCD_CLI_LOCAL=/usr/local/bin/argocd
ARGOCD_CLI=${ARGOCD_CLI_HOME}/argocd
create_sym_link ${ARGOCD_CLI} ${ARGOCD_CLI_LOCAL}
argocd version

msg "Successfull"

exit 0

# EOF
