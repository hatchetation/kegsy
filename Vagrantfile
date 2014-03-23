# -*- mode: ruby -*-
# vi: set ft=ruby :

$script = <<SCRIPT
  sudo apt-get update
sudo apt-get install build-essential libmysqlclient16 mysql-common zlib1g-dev libmysqlclient-dev ruby libxml2-dev libxslt-dev heirloom-mailx mysql-server
SCRIPT

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "base"

  # Closest we can get for now.
  config.vm.box_url = "http://dl.dropbox.com/u/40989391/vagrant-boxes/debian-squeeze-i386.box"
  config.vm.network "forwarded_port", guest: 9292, host: 8080
  config.vm.provision :shell, :inline => $script
end
