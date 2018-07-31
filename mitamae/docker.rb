docker_creds_version = '0.6.0'

download 'docker-compose' do
  url "https://github.com/docker/compose/releases/download/#{node[:docker_compose_version]}/docker-compose-Linux-x86_64"
  destination "#{ENV['HOME']}/.local/bin/docker-compose"
  mode '0755'
  checksum node[:docker_compose_checksum]
end

add_user_to_group node[:login_user] do
  group 'docker'
end

docker_creds_install docker_creds_version do
  source_url "https://github.com/docker/docker-credential-helpers/releases/download/v#{docker_creds_version}/docker-credential-secretservice-v#{docker_creds_version}-amd64.tar.gz"
  checksum 'c48739b286656239bc34a70fd2a5aaa2666839408c94dbc7df193586340ab199'
end
