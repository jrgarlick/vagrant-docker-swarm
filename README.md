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
