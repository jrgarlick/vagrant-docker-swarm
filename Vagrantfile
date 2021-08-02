# -*- mode: ruby -*-
# vi: set ft=ruby :

$install_docker_script = <<SCRIPT
echo "Installing dependencies ..."
sudo apt-get update
echo Installing Docker...
curl -sSL https://get.docker.com/ | sh
sudo usermod -aG docker vagrant
SCRIPT

BOX_NAME = "ubuntu/xenial64"
MANAGER_MEMORY = "512"
CPUS = 2
MANAGERS = 1
MANAGER_IP = "172.20.20.1"
WORKER_MEMORY = "4096"
WORKER_CPUS = 4
WORKERS = 2
WORKER_IP = "172.20.20.10"
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    #Common setup
    config.vm.box = BOX_NAME
    config.vm.synced_folder ".", "/vagrant"
    config.vm.provision "shell",inline: $install_docker_script, privileged: true
    # config.vm.provider "virtualbox" do |vb|
    #   vb.cpus = CPUS
    # end
    #Setup Manager Nodes
    (1..MANAGERS).each do |i|
        config.vm.provider "virtualbox" do |vb|
          vb.memory = MANAGER_MEMORY
          vb.cpus = CPUS
        end
        config.vm.define "manager0#{i}" do |manager|
          manager.vm.network :private_network, ip: "#{MANAGER_IP}#{i}"
          manager.vm.hostname = "manager0#{i}"
          if i == 1
            #Only configure port to host for Manager01
            manager.vm.network :forwarded_port, guest: 80, host: 80
            manager.vm.network :forwarded_port, guest: 443, host: 443
            manager.vm.network :forwarded_port, guest: 8080, host: 8080
            manager.vm.network :forwarded_port, guest: 5000, host: 5000
            manager.vm.network :forwarded_port, guest: 9000, host: 9000
            manager.vm.provision "shell",inline: "cp /vagrant/cluster-bootstrap/swarm-network.sh /etc/profile.d/", privileged: true
            manager.vm.provision "shell",inline: "cp /vagrant/cluster-bootstrap/daemon.json /etc/docker/", privileged: true
            manager.vm.provision "shell",inline: "docker swarm init --listen-addr 172.20.20.11:2377 --advertise-addr 172.20.20.11:2377 | grep 'docker swarm join --token' > /vagrant/.vagrant/join-worker.sh", privileged: true
            manager.vm.provision "shell",inline: "docker swarm join-token manager | grep 'docker swarm join' > /vagrant/.vagrant/join-manager.sh", privileged: true
            # manager.vm.provision "shell",inline: "docker stack deploy -c /vagrant/stacks/portainer-agent-stack.yml portainer"
          end
          if i > 1
            manager.vm.provision "shell",inline:"/bin/bash /vagrant/.vagrant/join-manager.sh"
          end
          # manager.vm.provision "shell",inline:"docker node update --availability drain manager0#{i}"
        end
    end
    #Setup Woker Nodes
    (1..WORKERS).each do |i|
      config.vm.provider "virtualbox" do |vb|
        vb.memory = WORKER_MEMORY
        vb.cpus = WORKER_CPUS
      end
      config.vm.define "worker0#{i}" do |worker|
            worker.vm.network :private_network, ip: "#{WORKER_IP}#{i}"
            worker.vm.hostname = "worker0#{i}"
            worker.vm.provision "shell",inline: "cp /vagrant/scripts/swarm-network.sh /etc/profile.d/", privileged: true
            worker.vm.provision "shell",inline: "cp /vagrant/cluster-bootstrap/daemon.json /etc/docker/", privileged: true
            worker.vm.provision "shell",inline:"/bin/bash /vagrant/.vagrant/join-worker.sh"
            # worker.trigger.before :destroy do |trigger|
            #   trigger.warn = "Draining worker node 'worker0#{i}"
            #   trigger.run = {inline: "vagrant ssh manager01 -c 'docker node update --availability drain worker0#{i}'"}
            # end
            # worker.trigger.after :destroy do |trigger|
            #   trigger.warn = "Removing worker node 'worker0#{i}"
            #   trigger.run = {inline: "vagrant ssh manager01 -c 'docker node rm worker0#{i}'"}
            # end
        end
    end
end
