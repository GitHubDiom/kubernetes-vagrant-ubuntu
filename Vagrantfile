# -*- mode: ruby -*-
# vi: set ft=ruby :

$num_instances = 3
$instance_name_prefix = "serverless-node"
$vm_gui = false
$vm_memory = 1024 * 16

$vm_cpus = 8
$vb_cpuexecutioncap = 100
ip_prefix = '172.17.8.'
ssh_port_prefix='227'


Vagrant.configure(2) do |config|
  if Vagrant.has_plugin?("vagrant-proxyconf")
    # config.proxy.http     = "http://192.168.1.249:7890"
    # config.proxy.https    = "http://192.168.1.249:7890"
    # config.proxy.no_proxy = ""
  end
  (1..$num_instances).each do |i|
    config.vm.define vm_name = "%s-%02d" % [$instance_name_prefix, i] do |node|
      node.vm.box = 'ubuntu/bionic64'
      node.vm.box_version = "20210415.0.0"
      node.vm.box_check_update = false
      node.vm.hostname = vm_name
    #  node.vm.synced_folder '.', '/var/nfs/data/', type: 'nfs'

      ip = "#{ip_prefix}#{i+100}"
      # node.vm.network 'private_network', ip: ip,  virtualbox__intnet: true
      node.vm.network 'private_network', ip: ip
      ssh_port = "#{ssh_port_prefix}#{i}"
      node.vm.network :forwarded_port, guest: 22, host: ssh_port, id: 'ssh'
      node.vm.provider :virtualbox do |vb|
        vb.gui = $vm_gui
        vb.memory = $vm_memory
        vb.cpus = $vm_cpus
        vb.customize ["modifyvm", :id, "--cpuexecutioncap", "#{$vb_cpuexecutioncap}"]
      end

      node.vm.provision :shell, path: "install-docker.sh", args: [i, "#{ip_prefix}101"]
    end
  end
end
