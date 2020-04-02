#!/bin/bash

master_host_ip=$2
node_num=$1
echo master_host_ip: $master_host_ip
echo node_num: $node_num

install_docker () {
  which docker > /dev/null
  if [[ $? == 0 ]]; then
    echo 'docker has installed'
  else
    echo 'docker has not installed'
    pushd /vagrant/archives/deb

    sudo dpkg -i *.deb
    sudo usermod -aG docker vagrant

    popd

    pushd /vagrant/archives
    docker load -i docker-pause-3.1.tar
    sudo cp -v docker-daemon.json /etc/docker/daemon.json
    sudo systemctl restart docker
    popd
  fi
}

install_k3s () {
  which k3s > /dev/null
  if [[ $? == 0 ]]; then
    echo 'k3s has installed'
  else
    echo 'k3s has not installed'
    pushd /vagrant/archives

    cp -r k3s-install /tmp/
    if [[ $node_num == 1 ]]; then
      echo 'install k3s server'
      IPADDR=$(ip a show enp0s8 | grep "inet " | awk '{print $2}' | cut -d / -f1)
      INSTALL_K3S_EXEC="--node-ip=${IPADDR} --flannel-iface=enp0s8 --docker" bash install-k3s.sh
      NODE_TOKEN="/var/lib/rancher/k3s/server/node-token"
      sudo cp -v ${NODE_TOKEN} /vagrant/
    else
      echo 'install k3s agent'
      IPADDR=$(ip a show enp0s8 | grep "inet " | awk '{print $2}' | cut -d / -f1)
      INSTALL_K3S_EXEC="--node-ip=${IPADDR} --flannel-iface=enp0s8 --docker" K3S_URL=https://$master_host_ip:6443 K3S_TOKEN=$(cat /vagrant/node-token) bash install-k3s.sh
    fi

    popd
  fi
}


install_docker
install_k3s
