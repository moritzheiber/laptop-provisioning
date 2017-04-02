Vagrant.configure('2') do |config|
  config.vm.box = 'boxcutter/ubuntu1610'
  config.vm.network 'private_network', type: 'dhcp'
  config.vm.provision 'shell',
                      inline: 'cd /vagrant && ./bootstrap.sh',
                      privileged: false
end
