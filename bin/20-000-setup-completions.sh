#!/bin/bash
#
# ============================================================
#
#
#
#
# Created-------: 20260401
# ============================================================
# Description---: # Add autocompleted to /etc/bash_completion.d/
#
# echo 'source <(oc completion bash)'     >> ~/.bashrc
# echo 'source <(helm completion bash)'   >> ~/.bashrc
#
# Vault uses different method:
# complete -C /usr/local/bin/vault vault
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

COMMANDS=("oc" "helm" "tkn" "argocd")

j=0

for cmd in "${COMMANDS[@]}"; do
    if command -v $cmd &> /dev/null; then
        prefix=$(printf "5%02d" ${j})
        completion_file=${prefix}-${cmd}
        msg "⚙️  Generating: $completion_file. Autocompleted for: $cmd"
        $cmd completion bash | sudo tee /etc/bash_completion.d/$completion_file > /dev/null
        #let "j+=1"
        ((j++))
    else
        warn "⚠️  $cmd doesn't exits, likely is not in the PATH, review it..."
    fi
done

prefix=$(printf "5%02d" ${j})
completion_file=${prefix}-jbang
jbang completion -s=bash | sudo tee /etc/bash_completion.d/$completion_file > /dev/null
((j++))

prefix=$(printf "5%02d" ${j})
completion_file=${prefix}-camel-cli
camel completion | sudo tee /etc/bash_completion.d/$completion_file > /dev/null
((j++))

prefix=$(printf "5%02d" ${j})
completion_file=${prefix}-openspec
openspec completion generate bash | sudo tee /etc/bash_completion.d/$completion_file > /dev/null
((j++))

prefix=$(printf "5%02d" ${j})
completion_file=${prefix}-nvm
echo "source /home/nveces/.nvm/bash_completion" | sudo tee /etc/bash_completion.d/$completion_file > /dev/null
((j++))


msg "✅  Autocompleted  configurado en el sistema."

msg "⚠️  Reload your terminal"
source ~/.bashrc

exit 0

# EOF