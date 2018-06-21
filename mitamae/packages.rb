# We need to install this without authentication
package 'sur5r-keyring' do
  options '--allow-unauthenticated'
end

# apt packages
%w(
  ruby2.5
  ruby2.5-dev
  build-essential
  git
  i3
  i3status
  suckless-tools
  redshift-gtk
  geoclue-2.0
  gnome-encfs-manager
  gnome-terminal
  autossh
  compton
  unclutter
  urlscan
  mutt
  docker-ce
  riot-web
  numix-gtk-theme
  numix-icon-theme
  feh
  gnupg
  transmission-gtk
  neovim
  unzip
  dkms
  virtualbox-5.2
  pass
  libdbus-glib-1-dev
  whois
  htop
  mpv
  i965-va-driver
  vdpau-va-driver
  golang-1.10
  curl
  jq
  network-manager-openvpn-gnome
  network-manager-openconnect-gnome
  unrar
  w3m
  yarn
  gimp
  pinentry-curses
  libsecret-1-dev
  azure-cli
  exuberant-ctags
  nodejs
  keepassx
  mosh
  signal-desktop
  xclip
  silversearcher-ag
  pulseaudio-module-bluetooth
  shellcheck
  hugo
  gopass
  python3-pip
).each do |p|
  package p
end

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

# Python2 pip packages installed locally
%w(
  keyring
  awscli
  streamlink
  neovim
  secretstorage
  dbus-python
  flake8
  msgpack-python
  python-language-server
).each do |python_p|
  pip python_p do
    pip_binary "/usr/bin/pip2"
    action [:upgrade]
    options '--user'
    user 'moe'
  end
end

# Python3 pip packages installed locally
%w(
  neovim
).each do |python_p|
  pip python_p do
    pip_binary "/usr/bin/pip3"
    action [:upgrade]
    options '--user'
    user 'moe'
  end
end

# Install the libsecret helper
execute 'make' do
  cwd '/usr/share/doc/git/contrib/credential/libsecret'
  not_if 'test -f /usr/share/doc/git/contrib/credential/libsecret/git-credential-libsecret'
end

apt 'google-chrome-stable' do
  source_url 'https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb'
end
