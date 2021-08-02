#!/bin/sh

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source ${SCRIPT_DIR}/common.sh

# Setup Swarm Cronjob
docker stack deploy -c ${STACKS_DIR}/swarm_cronjob/swarm_cronjob.yml cronjob
