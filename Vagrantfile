initial_user = 'moe'
provisioning_script = <<SCRIPT
apt update -qq &&
id #{initial_user} || useradd -d /home/#{initial_user} -s /bin/bash -m -U -G sudo,adm,cdrom,dip #{initial_user}
SCRIPT

Vagrant.configure('2') do |config|
  config.vm.provider 'docker' do |d|
    d.image = 'moritzheiber/vagrant:bionic'
    d.has_ssh = true
  end

  config.vm.provision 'shell',
                      inline: provisioning_script,
                      privileged: true
  config.vm.provision 'shell',
                      inline: 'cd /vagrant && ./run',
                      privileged: true,
                      env: {
                        'LOG_LEVEL' => 'debug',
                        'DEBIAN_FRONTEND' => 'noninteractive'
                      }
end
