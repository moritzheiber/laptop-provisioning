%w(
  apt-transport-https
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
  brightbox/ruby-ng
  gencfsm/ppa
  neovim-ppa/stable
  numix/ppa
  gophers/archive
  git-core/ppa
  masterminds/glide
  yubico/stable
).each do |u|
  apt_repository u do
    ppa true
  end
end

{
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu #{node[:ubuntu_release]} #{node[:docker_release_channel]}" => '9DC858229FC7DD38854AE2D88D81803C0EBFCD88',
  "deb http://debian.sur5r.net/i3/ #{node[:ubuntu_release]} universe" => '',
  "deb https://riot.im/packages/debian/ #{node[:ubuntu_release]} main" => '6FEB6F83D48B93547E7DFEDEE019645248E8F4A1',
  'deb https://dl.yarnpkg.com/debian/ stable main' => 'https://dl.yarnpkg.com/debian/pubkey.gpg',
  "deb https://deb.nodesource.com/node_8.x #{node[:ubuntu_release]} main" => '9FD3B784BC1C6FC31A8A0A1C1655A0AB68576280',
  "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ #{node[:ubuntu_release]} main" => 'BC528686B50D79E339D3721CEB3E94ADBE1229CF',
  'deb [arch=amd64] https://updates.signal.org/desktop/apt xenial main' => 'DBA36B5181D0C816F630E889D980A17457F6FB06',
  'deb [arch=amd64] https://cli-assets.heroku.com/apt ./' => '150C6249147592DE6D91981CC927EBE00F1B0520',
  "deb [arch=amd64] https://dl.bintray.com/gopasspw/gopass #{node[:ubuntu_release]} main" => 'https://api.bintray.com/orgs/gopasspw/keys/gpg/public.key',
  'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' => 'https://dl.google.com/linux/linux_signing_key.pub'
}.each do |u, k|
  apt_repository u do
    gpg_key k unless k.empty?
  end
end

remote_file '/etc/apt/preferences.d/yubico-stable-400' do
  source 'files/yubico-stable-400'
  mode '0644'
end
