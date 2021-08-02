#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source ${SCRIPT_DIR}/common.sh


#${SCRIPT_DIR}/setup-logging.sh

#${SCRIPT_DIR}/setup-monitoring.sh

${SCRIPT_DIR}/setup-traefik.sh

${SCRIPT_DIR}/setup-cronjob.sh

${SCRIPT_DIR}/setup-cloud-config.sh

${SCRIPT_DIR}/setup-portainer.sh

echo "Waiting 60 seconds for the cluster to quiesce..."
sleep 60
${SCRIPT_DIR}/setup-jenkins.sh

