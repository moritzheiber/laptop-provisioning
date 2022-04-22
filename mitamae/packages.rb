# Installing apt-fast first
package 'apt-fast'

# apt packages
apt_packages = %w(
  ruby
  ruby-dev
  build-essential
  git
  urlscan
  mutt
  gnupg2
  transmission-gtk
  unzip
  dkms
  libdbus-glib-1-dev
  whois
  htop
  i965-va-driver
  libvdpau-va-gl1
  jq
  wireguard
  unrar
  w3m
  gimp
  pinentry-curses
  libsecret-1-dev
  nodejs
  mosh
  signal-desktop
  xclip
  silversearcher-ag
  shellcheck
  python3-pip
  python3-dev
  ttf-mscorefonts-installer
  fonts-font-awesome
  fonts-powerline
  libpam-u2f
  neovim
  amazon-ecr-credential-helper
  libssl-dev
  codium
  docker-ce
  vault
  packer
  terraform
  vagrant
  element-desktop
  heroku
  terraform-ls
  gh
  jotta-cli
  gstreamer1.0-plugins-bad
  totem
  heif-gdk-pixbuf
  heif-thumbnailer
)

execute "VERBOSE_OUTPUT=y DEBIAN_FRONTEND=noninteractive apt-fast install -y --no-install-recommends #{apt_packages.join(' ')}" do
  not_if "apt list --installed | grep -q #{apt_packages.first}"
end

apt_packages.each do |p|
  package p do
    options '--no-install-recommends'
  end
end

package 'google-chrome-stable' do
  notifies :delete, 'file[remove_chrome_repository]', :immediately
end

file 'remove_chrome_repository' do
  path '/etc/apt/sources.list.d/google-chrome.list'
  action :nothing
end

# Install golang separately to we can keep track of the version
package 'golang-go'

# Remove a couple of apt packages
%w(
  thunderbird
  pidgin
  apport-gtk
).each do |p|
  package p do
    action [:remove]
  end
end

# Python3 pip packages installed locally
%w(
  keyring
  neovim
  SecretStorage
  dbus-python
  flake8
  msgpack
  python-language-server
  wheel
  tzupdate
  streamlink
  solo-python
).each do |python_p|
  pip python_p do
    pip_binary '/usr/bin/pip3'
    action [:upgrade]
    options '--user'
    user node[:login_user]
  end
end

# Install the libsecret helper
execute 'make' do
  cwd '/usr/share/doc/git/contrib/credential/libsecret'
  not_if 'test -f /usr/share/doc/git/contrib/credential/libsecret/git-credential-libsecret'
end

{
  #  'mattermost-desktop' => "https://releases.mattermost.com/desktop/#{node[:mattermost_version]}/mattermost-desktop-#{node[:mattermost_version]}-linux-amd64.deb",
  'ripgrep' => {
    url: "https://github.com/BurntSushi/ripgrep/releases/download/#{node[:ripgrep_version]}/ripgrep_#{node[:ripgrep_version]}_amd64.deb",
    version: node[:ripgrep_version]
  },
  'delta' => {
    url: "https://github.com/dandavison/delta/releases/download/#{node[:delta_version]}/git-delta_#{node[:delta_version]}_amd64.deb",
    version: node[:delta_version]
  },
  'gopass' => {
    url: "https://github.com/gopasspw/gopass/releases/download/v#{node[:gopass_version]}/gopass_#{node[:gopass_version]}_linux_amd64.deb",
    version: node[:gopass_version]
  }
}.each do |name, vars|
  apt name do
    version vars[:version]
    source_url vars[:url]
  end
end

# Rubygems
%w(
  bundler
  neovim
  ohai
  rubocop
  rubocop-performance
  rubocop-rspec
  solargraph
).each do |g|
  gem_package g do
    user node[:login_user]
    options ['--user']
  end
end

rustup 'stable' do
  user node[:login_user]
end

[
  {
    name: 'powerline-go',
    url: "https://github.com/justjanne/powerline-go/releases/download/v#{node[:powerline_go_version]}/powerline-go-linux-amd64",
    checksum: node[:powerline_go_checksum]
  },
  {
    name: 'minikube',
    url: "https://github.com/kubernetes/minikube/releases/download/v#{node[:minikube_version]}/minikube-linux-amd64",
    checksum: node[:minikube_checksum]
  },
  {
    name: 'aws-iam-authenticator',
    url: "https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v#{node[:aws_iam_authenticator_version]}/aws-iam-authenticator_#{node[:aws_iam_authenticator_version]}_linux_amd64",
    checksum: node[:aws_iam_authenticator_checksum]
  },
  {
    name: "goss",
    url: "https://github.com/aelsabbahy/goss/releases/download/v#{node[:goss_version]}/goss-linux-amd64",
    checksum: node[:goss_checksum]
  },
  {
    name: "dgoss",
    url: "https://github.com/aelsabbahy/goss/releases/download/v#{node[:goss_version]}/dgoss",
    checksum: node[:dgoss_checksum]
  }
].each do |cli|
  download cli[:name] do
    url cli[:url]
    destination "#{node[:user][node[:login_user]][:directory]}/.local/bin/#{cli[:name]}"
    mode '0755'
    user node[:login_user]
    checksum cli[:checksum]
  end
end

fzf_install node[:fzf_version] do
  source_url "https://github.com/junegunn/fzf-bin/releases/download/#{node[:fzf_version]}/fzf-#{node[:fzf_version]}-linux_amd64.tgz"
  checksum node[:fzf_checksum]
  destination "#{node[:user][node[:login_user]][:directory]}/.local/bin/fzf"
end

helm_install node[:helm_version] do
  source_url "https://get.helm.sh/helm-v#{node[:helm_version]}-linux-amd64.tar.gz"
  checksum node[:helm_checksum]
  destination '/usr/bin'
end

go_chromecast_install node[:go_chromecast_version] do
  source_url "https://github.com/vishen/go-chromecast/releases/download/v#{node[:go_chromecast_version]}/go-chromecast_#{node[:go_chromecast_version]}_Linux_x86_64.tar.gz"
  checksum node[:go_chromecast_checksum]
  destination '/usr/bin'
end

k9s_install node[:k9s_version] do
  source_url "https://github.com/derailed/k9s/releases/download/v#{node[:k9s_version]}/k9s_Linux_x86_64.tar.gz"
  checksum node[:k9s_checksum]
  destination '/usr/bin'
end

terraform_docs_install node[:terraform_docs_version] do
  checksum node[:terraform_docs_checksum]
end

starship_install node[:starship_version] do
  checksum node[:starship_checksum]
end

{
  'kx' => {
    version: node[:kx_version],
    checkum: node[:kx_checksum],
    url: "https://github.com/onatm/kx/releases/download/v#{node[:kx_version]}/kx-v#{node[:kx_version]}-linux-amd64.tar.gz"
  },
  'tokei' => {
    version: node[:tokei_version],
    checksum: node[:tokei_checksum],
    url: "https://github.com/XAMPPRocky/tokei/releases/download/v#{node[:tokei_version]}/tokei-x86_64-unknown-linux-gnu.tar.gz"
  }
}.each do |name, data|
  rust_tool_install name do
    checksum data[:checksum]
    version data[:version]
    url data[:url]
  end
end

gossm_install node[:gossm_version] do
  checksum node[:gossm_checksum]
end

{
  'pinentry' => {
    link: '/usr/bin/pinentry',
    path: '/usr/bin/pinentry-curses'
  },
  'python' => {
    link: '/usr/bin/python',
    path: '/usr/bin/python3'
  }
}.each do |n, info|
  alternatives n do
    path info[:path]
    link info[:link]
    priority 50
  end
end

aws_cli_install node[:aws_cli_version] do
  user node[:login_user]
  destination "#{node[:user][node[:login_user]][:directory]}/.local/bin/aws"
  source_url "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-#{node[:aws_cli_version]}.zip"
end
