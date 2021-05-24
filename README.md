# Docker Swarm Vagrant

Simple project to standup a Docker Swarm cluster

Found the link here: https://jazz-twk.medium.com/learn-docker-swarm-with-vagrant-47dd52b57bcc

## Init `manager01`

```
docker swarm init --listen-addr 172.20.20.11:2377 --advertise-addr 172.20.20.11:2377
```

Take note of the output, there should be command specified that will let you add worker nodes


Get token to join manager:
```
docker swarm join-token manager
```

## Init `manager02`

Run a command like this:
```
docker swarm join --token SWMTKN-1-4yi710ldjxghquve97fgfh6551vsi7xvlzihbs6ag8tgil9w1a-eqx1i4qfnye7ucjwbvbn6glrw 172.20.20.11:2377
```

## Add workers

On every Worker node, run the command from above to join


## Deploying only on Worker Nodes

```
    deploy:
      placement:
        constraints: [node.role == worker]
```

# Traefik Load Balancer

The Traefik Load Balancer handles all ingress traffic and provides a way to dynamically manage services within the cluster. 

## `docker-compose.yml` Configuration Options

Inside your `docker-compose.yml` file, add the following to each service that needs a dynamic name:

```
services:
  <service-name>:
    deploy:
      labels:
        - traefik.enable=true
        - traefik.docker.network=traefik-public
        - traefik.constraint-label=traefik-public
        - traefik.http.routers.redmine-http.rule=Host(`redmine.stack.docker.internal`)
        - traefik.http.routers.redmine-http.entrypoints=http
        - traefik.http.routers.redmine-http.middlewares=https-redirect
        - traefik.http.routers.redmine-https.rule=Host(`redmine.stack.docker.internal`)
        - traefik.http.routers.redmine-https.entrypoints=https
        - traefik.http.routers.redmine-https.tls=true
        - traefik.http.routers.redmine-https.tls.certresolver=le
        - traefik.http.services.redmine.loadbalancer.server.port=3000
```

## Sticky Sessions

Traefik supports sticky sessions (which most of our Java apps will need). Add another line to your Traefik config:

```
        - http.services.<service-name>.loadBalancer.sticky.cookie={}
```

## Credentials

So aparently, the Credential Management in Docker Swarm sucks. In order to deploy a container from a private registry, you need to do this:

```
    stage('Deploy Container') {
        steps {
            withCredentials([usernamePassword(credentialsId: 'local-registry-creds', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                sh '''
                    docker login -u $USERNAME -p $PASSWORD https://jgtestrepo.jfrog.io/
                    docker -H tcp://172.20.20.11:2375 stack deploy -c docker-compose.yml --with-registry-auth hello-world
                '''
            }
        }
    }
```