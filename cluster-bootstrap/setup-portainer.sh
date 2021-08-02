#!/bin/sh

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source ${SCRIPT_DIR}/common.sh

# Setup Portainer
docker stack deploy -c ${STACKS_DIR}/portainer/portainer-agent-stack.yml portainer
