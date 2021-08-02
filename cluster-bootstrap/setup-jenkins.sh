#!/bin/sh

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source ${SCRIPT_DIR}/common.sh

# Setup Jenkins
docker stack deploy -c ${STACKS_DIR}/jenkins/jenkins.yml jenkins
