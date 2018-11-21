download 'docker-compose' do
  url "https://github.com/docker/compose/releases/download/#{node[:docker_compose_version]}/docker-compose-Linux-x86_64"
  destination "#{ENV['HOME']}/.local/bin/docker-compose"
  mode '0755'
  checksum node[:docker_compose_checksum]
end

add_user_to_group node[:login_user] do
  group 'docker'
end

docker_creds_install node[:docker_credential_helper_version] do
  source_url "https://github.com/docker/docker-credential-helpers/releases/download/v#{node[:docker_credential_helper_version]}/docker-credential-secretservice-v#{node[:docker_credential_helper_version]}-amd64.tar.gz"
  checksum node[:docker_credential_helper_checksum]
end
