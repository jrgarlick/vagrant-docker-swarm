#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

docker network create --driver=overlay traefik-public

export NODE_ID=$(docker info -f '{{.Swarm.NodeID}}')

docker node update --label-add traefik-public.traefik-public-certificates=true $NODE_ID

export EMAIL=jrgarlick@gmail.com
export DOMAIN=dev.garlick.zone

export USERNAME=admin
export PASSWORD=changethis

export HASHED_PASSWORD=$(openssl passwd -apr1 $PASSWORD)

docker stack deploy -c ${SCRIPT_DIR}/traefik.yml traefik