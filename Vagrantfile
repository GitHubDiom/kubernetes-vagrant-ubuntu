# -*- mode: ruby -*-
# vi: set ft=ruby :

$num_instances = 3
$instance_name_prefix = "ubuntu"
$vm_gui = false
$vm_memory = 1024
$vm_cpus = 1
$vb_cpuexecutioncap = 100
ip_prefix = '172.17.8.'

Vagrant.configure(2) do |config|
  (1..$num_instances).each do |i|
    config.vm.define vm_name = "%s-%02d" % [$instance_name_prefix, i] do |node|
      node.vm.box = 'ubuntu/bionic64'
      node.vm.box_version = "20191125.0.0"
      node.vm.box_check_update = false
      node.vm.hostname = vm_name
      node.vm.synced_folder '.', '/vagrant', type: 'virtualbox'

      ip = "#{ip_prefix}#{i+100}"
      node.vm.network 'private_network', ip: ip,  virtualbox__intnet: true
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
