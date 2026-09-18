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

WORKDIR="${WORKDIR:-$HOME/maven}"
OS_ARCH=$(uname)
# lowercase
OS_ARCH=${OS_ARCH,,}

# Step 3: Download
MVN_CLI_NAME=apache-maven-${MVN_VERSION}-bin.tar.gz
MVN_CLI_URL=https://dlcdn.apache.org/maven/maven-3/${MVN_VERSION}/binaries/${MVN_CLI_NAME}
MVN_CLI_FILE=$WORKDIR/${MVN_CLI_NAME}
MVN_CLI_HOME=$WORKDIR/apache-maven-${MVN_VERSION}

mkdir -p ${WORKDIR}
mkdir -p ${MVN_CLI_HOME}

if [ -f ${MVN_CLI_FILE} ]; then
  warn "The ${MVN_CLI_FILE} file exists"
else
  msg "Downloading ${MVN_CLI_URL} on $MVN_CLI_FILE"
  curl -k "${MVN_CLI_URL}" -o "$MVN_CLI_FILE"
fi

# Step 4: Extract the tar file
tar -zxvf "${MVN_CLI_FILE}" -C ${WORKDIR}
#rm -f "${MVN_CLI_FILE}"

# Step 5: Create symbolic link
MVN_CLI_LOCAL=/usr/local/bin/mvn
MVN_CLI=${MVN_CLI_HOME}/bin/mvn
create_sym_link ${MVN_CLI} ${MVN_CLI_LOCAL}
mvn -version

exit 0

# EOF
