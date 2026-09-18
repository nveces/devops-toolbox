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

# 1. Get Architecture
ARCH_RAW=$(uname -m)
case $ARCH_RAW in
    x86_64)  ARCH="amd64" ;;
    i386|i686) ARCH="386" ;;
    aarch64|arm64) ARCH="arm64" ;;
    *) echo "Architecture not supported: $ARCH_RAW"; exit 1 ;;
esac


# Step 3: Download
VAULT_CLI_NAME=vault_${VAULT_VERSION}_${OS_ARCH}_${ARCH}.zip
VAULT_CLI_URL="https://releases.hashicorp.com/vault/${VAULT_VERSION}/${VAULT_CLI_NAME}"
VAULT_CLI_FILE=$WORKDIR/$VAULT_CLI_NAME
VAULT_CLI_HOME=$WORKDIR/vault-cli-${VAULT_VERSION}
mkdir -p ${WORKDIR}
mkdir -p ${VAULT_CLI_HOME}

if [ -f ${VAULT_CLI_FILE} ]; then
  warn "The ${VAULT_CLI_FILE} file exists"
else
  #curl -sLO https://releases.hashicorp.com/vault/1.15.4/vault_${OS_ARCH}_x86_64.zip
  msg "Downloading ${VAULT_CLI_URL} on $WORKDIR"
  curl -kL "${VAULT_CLI_URL}" -o "$VAULT_CLI_FILE"
fi

# Step 4: Extract the tar file
unzip "${VAULT_CLI_FILE}" -d ${VAULT_CLI_HOME}
#rm -f "${VAULT_CLI_FILE}"

# Step 5: Create symbolic link
VAULT_CLI_LOCAL=/usr/local/bin/vault
VAULT_CLI=${VAULT_CLI_HOME}/vault
create_sym_link ${VAULT_CLI} ${VAULT_CLI_LOCAL}

vault version

exit 0

# EOF


#!/bin/bash
# Script para instalar Vault CLI en Linux
