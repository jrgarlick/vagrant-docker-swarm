## Todos:
- We could put the certificates in as secrets instead of files!!!

## Socket Proxy

There are some security implications that should be considered when exposing the docker socket to Traefik directly on the docker hosts. You can [read more about it here.](https://chriswiegman.com/2019/11/protecting-your-docker-socket-with-traefik-2/). This is what I did:

```
  # Add this service to add socket proxy
  socket-proxy:
    image: tecnativa/docker-socket-proxy
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    environment:
      SERVICES: 1
      TASKS: 1
      NETWORKS: 1
    networks:
      - mgmt
    deploy:
      placement:
        constraints:
          - node.role == manager

# Add this network too
networks:
  - mgmt
```