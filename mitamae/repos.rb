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
  apt-fast/stable
  brightbox/ruby-ng
  neovim-ppa/stable
  numix/ppa
  longsleep/golang-backports
  git-core/ppa
  yubico/stable
  eh5/pulseaudio-a2dp
  ubuntu-mozilla-security/ppa
  nextcloud-devs/client
).each do |u|
  apt_repository u do
    ppa true
  end
end

{
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu #{node[:ubuntu_release]} #{node[:docker_release_channel]}" => '9DC858229FC7DD38854AE2D88D81803C0EBFCD88',
  "deb http://debian.sur5r.net/i3/ #{node[:ubuntu_release]} universe" => '',
  "deb https://riot.im/packages/debian/ #{node[:ubuntu_release]} main" => 'https://riot.im/packages/debian/repo-key.asc',
  'deb https://dl.yarnpkg.com/debian/ stable main' => 'https://dl.yarnpkg.com/debian/pubkey.gpg',
  "deb https://deb.nodesource.com/node_#{node[:nodejs_major_version]}.x #{node[:ubuntu_release]} main" => '9FD3B784BC1C6FC31A8A0A1C1655A0AB68576280',
  'deb [arch=amd64] https://updates.signal.org/desktop/apt xenial main' => 'https://updates.signal.org/desktop/apt/keys.asc',
  'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' => 'https://dl.google.com/linux/linux_signing_key.pub',
  'deb [arch=amd64] https://apt.kubernetes.io/ kubernetes-xenial main' => 'https://packages.cloud.google.com/apt/doc/apt-key.gpg',
  "deb [arch=amd64] http://packages.cloud.google.com/apt cloud-sdk-#{node[:ubuntu_release]} main" => 'https://packages.cloud.google.com/apt/doc/apt-key.gpg',
  'deb https://packagecloud.io/slacktechnologies/slack/debian/ jessie main' => 'https://packagecloud.io/slacktechnologies/slack/gpgkey',
  "deb [arch=amd64] https://packagecloud.io/segment/aws-okta/ubuntu/ #{node[:ubuntu_release]} main" => 'https://packagecloud.io/segment/aws-okta/gpgkey',
  'deb [arch=amd64] https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/repos/debs/ vscodium main' => 'https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg',
  "deb [arch=amd64] https://download.virtualbox.org/virtualbox/debian #{node[:ubuntu_release]} contrib" => 'https://www.virtualbox.org/download/oracle_vbox.asc'
}.each do |u, k|
  apt_repository u do
    gpg_key k unless k.empty?
  end
end

apt_repository "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ #{node[:ubuntu_release]} main" do
  keyserver 'packages.microsoft.com'
  gpg_key 'BC528686B50D79E339D3721CEB3E94ADBE1229CF'
end

remote_file '/etc/apt/preferences.d/yubico-stable-400' do
  source 'files/yubico-stable-400'
  mode '0644'
end
