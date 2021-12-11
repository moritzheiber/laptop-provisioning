initial_user = 'mheiber'
provisioning_script = <<SCRIPT
apt update -qq &&
apt install -y wget gpg-agent &&
install -m0700 -o root -g root -d /root/.gnupg &&
id #{initial_user} || useradd -d /home/#{initial_user} -s /bin/bash -m -U -G sudo,adm,cdrom,dip #{initial_user}
SCRIPT

Vagrant.configure('2') do |config|
  config.vm.provider 'docker' do |d|
    d.image = 'ghcr.io/moritzheiber/vagrant:impish'
    d.has_ssh = true
  end

  config.vm.provision 'shell',
                      inline: provisioning_script,
                      privileged: true
  config.vm.provision 'file',
                      source: 'mocks/systemctl',
                      destination: '/tmp/systemctl'
  config.vm.provision 'shell',
                      inline: 'install -m0755 -o root -g root /tmp/systemctl /usr/local/sbin/systemctl',
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
