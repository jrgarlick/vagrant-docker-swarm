#!/bin/sh

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source ${SCRIPT_DIR}/common.sh

# Setup Cloud Config
docker stack deploy -c ${STACKS_DIR}/spring_cloud_config/cloud-config.yml cloud-config
