# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "ubuntu/trusty64"

  # Set provider (Virtualbox), memory and CPUs
  config.vm.provider "virtualbox" do |v|
    v.memory = 512
    v.cpus = 2
  end

  # Create a forwarded port mapping
  config.vm.network :forwarded_port, guest: 80, host: 8080
  config.vm.network :forwarded_port, guest: 8000, host: 8001
  config.vm.network :forwarded_port, guest: 3306, host: 8889
  
  # Share additional folders to the guest VM.
  config.vm.synced_folder "sites", "/var/www"
   
  # Enable provisioning with a shell script.
  # SWAP
  config.vm.provision "shell", 
  path: "provision/increase-swap.sh",
  privileged: true

  # Superuser
  config.vm.provision "shell", 
	path: "provision/provision-su.sh",
	privileged: true
	
  # Vagrant user
  config.vm.provision "shell", 
	path: "provision/provision-vagrant.sh",
	privileged: false
	
end
