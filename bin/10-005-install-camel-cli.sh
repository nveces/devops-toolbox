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

WORKDIR="${WORKDIR:-$HOME/jbang}"
OS_ARCH=$(uname)
# lowercase
OS_ARCH=${OS_ARCH,,}

# Step 3: Download
JBANG_NAME=jbang-${JBANG_VERSION}.zip
JBANG_URL=https://github.com/jbangdev/jbang/releases/download/v${JBANG_VERSION}/${JBANG_NAME}
JBANG_FILE=$WORKDIR/${JBANG_NAME}
JBANG_HOME=$WORKDIR/jbang-${JBANG_VERSION}

mkdir -p ${WORKDIR}
mkdir -p ${JBANG_HOME}

if [ -f ${JBANG_FILE} ]; then
  warn "The ${JBANG_FILE} file exists"
else
  msg "Downloading ${JBANG_URL} on $JBANG_FILE"
  curl -Lkv "${JBANG_URL}" -o "$JBANG_FILE"
fi

# Step 4: Extract the tar file
if [ -d ${JBANG_HOME} ]; then
  warn "The ${JBANG_HOME} directory exists"
else
  msg "Extract the ${JBANG_FILE} on ${WORKDIR}"
  unzip "${JBANG_FILE}" -d ${WORKDIR}
  #rm -f "${MVN_CLI_FILE}"
fi

# # Step 5: Create symbolic link
JBANG_CLI_LOCAL=/usr/local/bin/jbang
JBANG_CLI=${JBANG_HOME}/bin/jbang
create_sym_link ${JBANG_CLI} ${JBANG_CLI_LOCAL}
# jbang --version jbang -V
jbang version

jbang app uninstall --verbose camel
msg "Adding https://github.com/redhat-camel/jbang-catalog/ to trusted list"
jbang trust add https://github.com/redhat-camel/jbang-catalog/
msg "Installing Camel ..."
# --insecure - Enable insecure trust of all SSL certificates
# --verbose              jbang will be verbose on what it does.
jbang app install camel@redhat-camel/jbang-catalog/${CAMEL_VERSION}
#
source ~/.bashrc
camel version

exit 0

# EOF
