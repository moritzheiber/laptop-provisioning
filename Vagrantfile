Vagrant.configure('2') do |config|
  config.vm.provider 'docker' do |d|
    d.image = 'moritzheiber/vagrant:bionic'
    d.has_ssh = true
  end

  config.vm.provision 'shell',
                      inline: 'echo "login_user: vagrant" > /tmp/overrides.yml'
  config.vm.provision 'shell',
                      inline: 'apt update -qq',
                      privileged: true
  config.vm.provision 'shell',
                      inline: 'cd /vagrant && ./run.sh',
                      privileged: false,
                      env: {
                        'OVERRIDES' => '--node-yaml /tmp/overrides.yml',
                        'LOG_LEVEL' => 'debug'
                      }
end
