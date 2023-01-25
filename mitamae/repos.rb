%w(
  apt-transport-https
  apt-utils
  ca-certificates
  software-properties-common
  curl
).each do |p|
  package p
end

%w(
  git-core/ppa
  mozillateam/ppa
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
  'https://repo.jotta.us/debian debian main' => 'https://repo.jotta.us/public.asc',
  "https://apt.releases.hashicorp.com #{node[:ubuntu_release]} main" => 'https://apt.releases.hashicorp.com/gpg',
  'http://packages.cloud.google.com/apt cloud-sdk main' => 'https://packages.cloud.google.com/apt/doc/apt-key.gpg',
  'https://cli.github.com/packages stable main' => 'https://cli.github.com/packages/githubcli-archive-keyring.gpg'
}.each do |url, key|
  apt_repository "deb [arch=amd64] #{url}" do
    gpg_key key unless key.empty?
  end
end

# Remove the automatically installed repositories
%w[
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

file '/etc/apt/preferences.d/proposed-priority-400' do
  mode '0644'
  content <<-FILE
Package: *
Pin: release a=#{node[:ubuntu_release]}-proposed
Pin-Priority: 400
FILE
end

%w[
  ubuntu-mozilla-security
  mozillateam
].each do |ppa|
  file "/etc/apt/preferences.d/#{ppa}-priority-1001" do
    mode '0644'
    content <<-FILE
Package: firefox
Pin: release o=LP-PPA-#{ppa}
Pin-Priority: 1001
FILE
  end
end


file "/etc/apt/preferences.d/firefox-no-snap" do
  mode '0644'
  content <<-FILE
Package: firefox*
Pin: release o=Ubuntu*
Pin-Priority: -1
FILE
end
