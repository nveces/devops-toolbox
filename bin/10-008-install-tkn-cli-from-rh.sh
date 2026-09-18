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

WORKDIR="${WORKDIR:-$HOME/tkn}"
OS_ARCH=$(uname)
# lowercase
OS_ARCH=${OS_ARCH,,}

# Step 3: Download
TKN_VERSION="1.18.0"
TKN_CLI_NAME="tkn-${OS_ARCH}-amd64.tar.gz"
TKN_CLI_URL="https://mirror.openshift.com/pub/openshift-v4/clients/pipelines/${TKN_VERSION}/${TKN_CLI_NAME}"
TKN_CLI_FILE=$WORKDIR/${TKN_CLI_NAME}
TKN_CLI_HOME=$WORKDIR/tkn-cli-${ARGOCD_VERSION}
mkdir -p ${WORKDIR}
mkdir -p ${TKN_CLI_HOME}

if [ -f ${TKN_CLI_FILE} ]; then
  warn "The ${TKN_CLI_FILE} file exists"
else
  # Download the matching binary
  msg "Downloading ${TKN_CLI_FILE} on $WORKDIR"
  curl -L "${TKN_CLI_URL}" -o "${TKN_CLI_FILE}"
fi

# Step 4: Extract the tar file
tar zxvf "${TKN_CLI_FILE}" -C ${TKN_CLI_HOME}
#rm -f "${TKN_CLI_FILE}"


COMMANDS=("opc" "tkn" "tkn-pac")

for cmd in "${COMMANDS[@]}"; do
  # Step 5: Create symbolic link
  TOOL_CLI_LOCAL=/usr/local/bin/${cmd}
  TOOL_CLI=${TKN_CLI_HOME}/${cmd}
  create_sym_link ${TOOL_CLI} ${TOOL_CLI_LOCAL}
  ${cmd} version --request-timeout=5s
done

msg "Successfull"

exit 0

# EOF
