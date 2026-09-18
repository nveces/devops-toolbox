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
# https://skupper.io/docs/
# curl -fL https://github.com/skupperproject/skupper/releases/download/1.4.3/skupper-cli-1.4.3-linux-amd64.tgz | tar -xzf -
# chmod +x /usr/local/bin/skupper
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
SKP_CLI_NAME=skupper-cli-${SKUPPER_VERSION}-${OS_ARCH}-amd64.tgz

SKP_CLI_URL="https://github.com/skupperproject/skupper/releases/download/${SKUPPER_VERSION}/${SKP_CLI_NAME}"
SKP_CLI_FILE=${WORKDIR}/${SKP_CLI_NAME}
SKP_CLI_HOME=${WORKDIR}/skupper-${SKUPPER_VERSION}
mkdir -p ${WORKDIR}
mkdir -p ${SKP_CLI_HOME}

if [ -f ${SKP_CLI_FILE} ]; then
  warn "The ${SKP_CLI_FILE} file exists"
else
  msg "Downloading ${SKP_CLI_URL} on $WORKDIR"
  curl -Lk "${SKP_CLI_URL}" -o "$SKP_CLI_FILE"
fi

# Step 4: Extract the tar file
tar zxvf "${SKP_CLI_FILE}" -C ${SKP_CLI_HOME}

# Step 5: Create symbolic link
SKP_CLI_LOCAL=/usr/local/bin/skupper
SKP_CLI=${SKP_CLI_HOME}/skupper
create_sym_link ${SKP_CLI} ${SKP_CLI_LOCAL}

skupper version

exit 0

# EOF
