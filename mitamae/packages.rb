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
  mpv
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
  pulseaudio-modules-bt
  heroku
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
  awscli
  neovim
  SecretStorage
  dbus-python
  flake8
  msgpack-python
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
  }
}.each do |name, vars|
  apt name do
    version vars[:version]
    source_url vars[:url]
  end
end

# Global rubygems
%w(
  bundler
  neovim
  ohai
  rubocop
  rubocop-rspec
  solargraph
).each do |g|
  gem_package g
end

rustup 'stable' do
  user node[:login_user]
end

cargo_prefix = "/home/#{node[:login_user]}/.cargo/bin"

%w(
  kx
  tokei
).each do |p|
  execute "#{cargo_prefix}/cargo install #{p}" do
    user node[:login_user]
    not_if "test -e #{cargo_prefix}/#{p}"
  end
end

# AppImages
directory "#{node[:user][node[:login_user]][:directory]}/AppImages" do
  mode '0755'
  owner node[:login_user]
  group node[:login_user]
  user node[:login_user]
end

[
  {
    name: 'nvim.appimage',
    url: "https://github.com/neovim/neovim/releases/download/v#{node[:neovim_version]}/nvim.appimage",
    checksum: node[:neovim_checksum]
  }
].each do |app_image|
  download app_image[:name] do
    url app_image[:url]
    destination "#{node[:user][node[:login_user]][:directory]}/AppImages/#{app_image[:name]}"
    mode '0755'
    user node[:login_user]
    checksum app_image[:checksum]
  end
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
    name: 'terraform-docs',
    url: "https://github.com/segmentio/terraform-docs/releases/download/v#{node[:terraform_docs_version]}/terraform-docs-v#{node[:terraform_docs_version]}-linux-amd64",
    checksum: node[:terraform_docs_checksum]
  },
  {
    name: 'aws-iam-authenticator',
    url: "https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v#{node[:aws_iam_authenticator_version]}/aws-iam-authenticator_#{node[:aws_iam_authenticator_version]}_linux_amd64",
    checksum: node[:aws_iam_authenticator_checksum]
  },
  {
    name: 'ra_lsp_server',
    url: "https://github.com/rust-analyzer/rust-analyzer/releases/download/#{node[:rust_analyzer_version]}/ra_lsp_server-linux",
    checksum: node[:rust_analyzer_checksum]
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

saml2aws_install node[:saml2aws_version] do
  checksum node[:saml2aws_checksum]
end

go_chromecast_install node[:go_chromecast_version] do
  source_url "https://github.com/vishen/go-chromecast/releases/download/v#{node[:go_chromecast_version]}/go-chromecast_#{node[:go_chromecast_version]}_Linux_x86_64.tar.gz"
  checksum node[:go_chromecast_checksum]
  destination '/usr/bin'
end

terraform_lsp_install node[:terraform_lsp_version] do
  source_url "https://github.com/juliosueiras/terraform-lsp/releases/download/v#{node[:terraform_lsp_version]}/terraform-lsp_#{node[:terraform_lsp_version]}_linux_amd64.tar.gz"
  checksum node[:terraform_lsp_checksum]
  destination '/usr/bin'
end

k9s_install node[:k9s_version] do
  source_url "https://github.com/derailed/k9s/releases/download/v#{node[:k9s_version]}/k9s_Linux_x86_64.tar.gz"
  checksum node[:k9s_checksum]
  destination '/usr/bin'
end

kx_install node[:kx_version] do
  checksum node[:kx_checksum]
end

gossm_install node[:gossm_version] do
  checksum node[:gossm_checksum]
end

apt 'gopass' do
  source_url "https://github.com/gopasspw/gopass/releases/download/v#{node[:gopass_version]}/gopass_#{node[:gopass_version]}_linux_amd64.deb"
  version node[:gopass_version]
end

apt 'i3status-rust' do
  source_url "https://github.com/greshake/i3status-rust/releases/download/v#{node[:i3_status_rs_version]}/i3status-rust_#{node[:i3_status_rs_version]}_amd64.deb"
  version node[:i3_status_rs_version]
end

{
  'vim' => {
    link: '/usr/bin/vim',
    path: "/home/#{node[:login_user]}/AppImages/nvim.appimage"
  },
  'pinentry' => {
    link: '/usr/bin/pinentry',
    path: '/usr/bin/pinentry-curses'
  }
}.each do |n, info|
  alternatives n do
    path info[:path]
    link info[:link]
    priority 50
  end
end
