# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|

  config.vm.box = "precise32"
  config.vm.box_url = "http://files.vagrantup.com/precise32.box"
  config.vm.network :hostonly, "192.168.33.10"
  config.vm.forward_port 80, 8080

  config.vm.customize [ "modifyvm", :id, "--memory", 1024 ]
  config.vm.share_folder("v-web", "/vagrant/www", "./www", :nfs => true)
  config.vm.share_folder("v-db", "/vagrant/db", "./db", :nfs => true)

  # Set the Timezone to something useful
  config.vm.provision :shell, :inline => "echo \"Europe/Paris\" | sudo tee /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata"

  # Update the server
  #config.vm.provision :shell, :inline => "apt-get update --fix-missing"

  # Enable Puppet
  config.vm.provision :puppet do |puppet|
      puppet.facter = { 
        "fqdn" => "vagrant-lamp-stack",
        "hostname" => "www",
		"docroot" => "/var/www/ezpublish"
      }
      puppet.manifests_path = "puppet/manifests"
      puppet.manifest_file = "init.pp"
      puppet.module_path = "puppet/modules"
  end

end
