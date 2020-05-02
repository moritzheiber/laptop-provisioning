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

# %w(
#   brightbox/ruby-ng
#   neovim-ppa/stable
#   numix/ppa
#   longsleep/golang-backports
#   eh5/pulseaudio-a2dp
#   nextcloud-devs/client
# ).each do |u|
#   apt_repository u do
#     ppa true
#   end
# end

%w(
  apt-fast/stable
  git-core/ppa
  yubico/stable
  ubuntu-mozilla-security/ppa
).each do |u|
  apt_repository u do
    ppa true
  end
end

# {
#   "https://download.docker.com/linux/ubuntu #{node[:ubuntu_release]} #{node[:docker_release_channel]}" => '9DC858229FC7DD38854AE2D88D81803C0EBFCD88',
#   "http://debian.sur5r.net/i3/ #{node[:ubuntu_release]} universe" => '',
#   "http://packages.cloud.google.com/apt cloud-sdk-#{node[:ubuntu_release]} main" => 'https://packages.cloud.google.com/apt/doc/apt-key.gpg',
#   "https://download.virtualbox.org/virtualbox/debian #{node[:ubuntu_release]} contrib" => 'https://www.virtualbox.org/download/oracle_vbox_2016.asc',
#   "https://packages.microsoft.com/repos/azure-cli/ #{node[:ubuntu_release]} main" => 'https://packages.microsoft.com/keys/microsoft.asc',
#   "https://tel.red/repos/ubuntu #{node[:ubuntu_release]} non-free" => '9454C19A66B920C83DDF696E07C8CCAFCE49F8C5',
#   "https://packagecloud.io/slacktechnologies/slack/ubuntu/ #{node[:ubuntu_release]} main" => 'https://packagecloud.io/slacktechnologies/slack/gpgkey'
# }.each do |url, key|
#   apt_repository "deb [arch=amd64] #{url}" do
#     gpg_key key unless key.empty?
#   end
# end

{
  "https://deb.nodesource.com/node_#{node[:nodejs_major_version]}.x #{node[:ubuntu_release]} main" => '9FD3B784BC1C6FC31A8A0A1C1655A0AB68576280',
  'https://updates.signal.org/desktop/apt xenial main' => 'https://updates.signal.org/desktop/apt/keys.asc',
  'https://apt.kubernetes.io/ kubernetes-xenial main' => 'https://packages.cloud.google.com/apt/doc/apt-key.gpg',
  'http://dl.google.com/linux/chrome/deb/ stable main' => 'https://dl.google.com/linux/linux_signing_key.pub',
  'https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/repos/debs/ vscodium main' => 'https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg',
  'https://riot.im/packages/debian/ default main' => 'https://riot.im/packages/debian/repo-key.asc'
}.each do |url, key|
  apt_repository "deb [arch=amd64] #{url}" do
    gpg_key key unless key.empty?
  end
end

remote_file '/etc/apt/preferences.d/yubico-stable-400' do
  source 'files/yubico-stable-400'
  mode '0644'
end
