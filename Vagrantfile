#!/usr/bin/env ruby
initial_user = 'moe'
provisioning_script = <<SCRIPT
apt update -qq &&
apt install -y wget &&
id #{initial_user} || useradd -d /home/#{initial_user} -s /bin/bash -m -U -G sudo,adm,cdrom,dip #{initial_user}
SCRIPT

Vagrant.configure('2') do |config|
  config.vm.provider 'docker' do |d|
    d.image = 'moritzheiber/vagrant:focal'
    d.has_ssh = true
  end

  config.vm.provision 'shell',
                      inline: provisioning_script,
                      privileged: true
  config.vm.provision 'file',
                      source: 'mocks/gsettings',
                      destination: '/tmp/gsettings'
  config.vm.provision 'shell',
                      inline: 'install -m0755 -o root -g root /tmp/gsettings /usr/local/bin/gsettings',
                      privileged: true
  config.vm.provision 'shell',
                      inline: 'cd /vagrant && ./run',
                      privileged: true,
                      env: {
                        'LOG_LEVEL' => 'debug',
                        'DEBIAN_FRONTEND' => 'noninteractive'
                      }
end
