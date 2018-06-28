%w(
  apt-transport-https
  ca-certificates
  software-properties-common
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
  neovim-ppa/unstable
  numix/ppa
  gophers/archive
  git-core/ppa
).each do |r|
  ppa r
end
