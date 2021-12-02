apt_conf = <<APT_CONF
APT::Install-Recommends "false";
APT_CONF

file '/etc/apt/apt.conf.d/99custom' do
  content apt_conf
  mode '0644'
end

%w(
  apt-transport-https
  apt-utils
  ca-certificates
  software-properties-common
  curl
).each do |p|
  package p
end

# We need to install this without authentication
apt 'sur5r-keyring' do
  source_url "http://debian.sur5r.net/i3/pool/main/s/sur5r-keyring/sur5r-keyring_#{node[:i3_keyring_version]}_all.deb"
  version node[:i3_keyring_version]
end

%w(
  git-core/ppa
  ubuntu-mozilla-security/ppa
  apt-fast/stable
).each do |u|
  apt_repository u do
    ppa true
  end
end

# {
#   "http://packages.cloud.google.com/apt cloud-sdk-#{node[:ubuntu_release]} main" => 'https://packages.cloud.google.com/apt/doc/apt-key.gpg',
#   "https://download.virtualbox.org/virtualbox/debian #{node[:ubuntu_release]} contrib" => 'https://www.virtualbox.org/download/oracle_vbox_2016.asc',
#   "https://packages.microsoft.com/repos/azure-cli/ #{node[:ubuntu_release]} main" => 'https://packages.microsoft.com/keys/microsoft.asc',
# }.each do |url, key|
#   apt_repository "deb [arch=amd64] #{url}" do
#     gpg_key key unless key.empty?
#   end
# end

{
  "https://download.docker.com/linux/ubuntu #{node[:ubuntu_release]} #{node[:docker_release_channel]}" => 'https://download.docker.com/linux/ubuntu/gpg',
  "https://deb.nodesource.com/node_#{node[:nodejs_major_version]}.x #{node[:ubuntu_release]} main" => 'https://deb.nodesource.com/gpgkey/nodesource.gpg.key',
  'https://updates.signal.org/desktop/apt xenial main' => 'https://updates.signal.org/desktop/apt/keys.asc',
  'https://apt.kubernetes.io/ kubernetes-xenial main' => 'https://packages.cloud.google.com/apt/doc/apt-key.gpg',
  'http://dl.google.com/linux/chrome/deb/ stable main' => 'https://dl.google.com/linux/linux_signing_key.pub',
  'https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/debs/ vscodium main' => 'https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg',
  'https://packages.riot.im/debian/ default main' => 'https://packages.riot.im/debian/riot-im-archive-keyring.gpg',
  'https://packages.microsoft.com/repos/ms-teams stable main' => 'https://packages.microsoft.com/keys/microsoft.asc',
  'https://repo.jotta.us/debian unstable main' => 'https://repo.jotta.us/public.gpg',
  "https://apt.releases.hashicorp.com #{node[:ubuntu_release]} main" => 'https://apt.releases.hashicorp.com/gpg',
  'https://cli-assets.heroku.com/apt ./' => 'https://cli-assets.heroku.com/apt/release.key',
  'http://packages.cloud.google.com/apt cloud-sdk main' => 'https://packages.cloud.google.com/apt/doc/apt-key.gpg'
}.each do |url, key|
  apt_repository "deb [arch=amd64] #{url}" do
    gpg_key key unless key.empty?
  end
end

# Remove the automatically installed repositories
%w[
  /etc/apt/sources.list.d/teams.list
  /etc/apt/sources.list.d/slack.list
].each do |f|
  file f do
    action :delete
  end
end

remote_file '/etc/apt/preferences.d/yubico-stable-400' do
  source 'files/yubico-stable-400'
  mode '0644'
end

remote_file '/etc/apt/preferences.d/proposed-priority-400' do
  source 'files/proposed-priority-400'
  mode '0644'
end
