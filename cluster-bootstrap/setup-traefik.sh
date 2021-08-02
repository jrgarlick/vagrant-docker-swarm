#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source ${SCRIPT_DIR}/common.sh

# Setup Traefik
export NODE_ID=$(docker info -f '{{.Swarm.NodeID}}')
export EMAIL=jrgarlick@gmail.com
export DOMAIN=${SWARM_DOMAIN}
export USERNAME=admin
export PASSWORD=changethis
export HASHED_PASSWORD=$(openssl passwd -apr1 $PASSWORD)

docker network create --driver=overlay traefik-public
#docker node update --label-add traefik-public.traefik-public-certificates=true $NODE_ID
docker stack deploy -c ${STACKS_DIR}/traefik/traefik.yml traefik
