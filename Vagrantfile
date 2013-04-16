#-*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  module_path = ["puppet/modules", "puppet/vendor_modules"]

  config.vm.box = "ubuntu-precise-32"
  config.vm.box_url = "http://files.vagrantup.com/precise32.box"
  config.vm.share_folder "angular-momentum", "angular-momentum", "."
  config.vm.network :hostonly, "172.16.0.41"
  config.vm.provision :puppet, :module_path => module_path do |puppet|
    puppet.manifests_path = "puppet"
    puppet.manifest_file  = "angular-momentum.pp"
  end
  config.vm.host_name = "angular-momentum"
end
