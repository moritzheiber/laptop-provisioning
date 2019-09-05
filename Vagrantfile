Vagrant.configure('2') do |config|
  config.vm.provider 'docker' do |d|
    d.image = 'moritzheiber/vagrant:bionic'
    d.has_ssh = true
  end

  config.vm.provision 'shell',
    inline: 'apt update -qq',
    privileged: true
  config.vm.provision 'shell',
    inline: 'cd /vagrant && ./run',
    privileged: true,
    env: {
      'LOG_LEVEL' => 'debug',
      'DEBIAN_FRONTEND' => 'noninteractive'
    }
end
