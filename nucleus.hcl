variables {
  ubuntu_version = "26.04"
  ubuntu_suite   = "resolute"
  username       = "mheiber"
}

ubuntu_version = ubuntu_version
ubuntu_suite   = ubuntu_suite
gsettings_user = username

ppa = [
  "git-core/ppa",
  "mozillateam/ppa",
  "solaar-unifying/stable",
  "kobuk-team/intel-graphics",
  #  "maveonair/helix-editor"
]

remote_file "mcfly" {
  url      = "https://github.com/cantino/mcfly/releases/download/v0.9.3/mcfly-v0.9.3-x86_64-unknown-linux-musl.tar.gz"
  checksum = "be0d3c1e0253189a5d834767231c2a4d206f077f4184699ac7069482ed9c6453"
  artifact = "mcfly"
  target   = "/usr/bin/mcfly"
  mode     = "0755"
  check    = ["bash", "-c", "mcfly --version | grep -q 0.9.3"]
}

remote_file "starship" {
  url      = "https://github.com/starship/starship/releases/download/v1.23.0/starship-x86_64-unknown-linux-gnu.tar.gz"
  checksum = "cef41df04378c6f692913c5d9c1032d3b9a4369a1d2f3296c8300ed8838c2197"
  artifact = "starship"
  target   = "/usr/bin/starship"
  mode     = "0755"
  check    = ["bash", "-c", "starship --version | grep -q 1.23.0"]
}

file "firefox-global-policies" {
  source = "files/firefox_policies.js"
  target = "/etc/firefox/policies/policies.json"
  mode   = "0644"
}

file "microsoft-repo-preferences" {
  regexp  = "repo_reenable_on_distupgrade=\"true\""
  content = "repo_reenable_on_distupgrade=\"false\""
  target  = "/etc/default/slack"
}

file "google-chrome-repo-preferences" {
  regexp  = "repo_reenable_on_distupgrade=\"true\""
  content = "repo_reenable_on_distupgrade=\"false\""
  target  = "/etc/default/google-chrome"
}

file "microsoft-edge-repo-preferences" {
  regexp  = "repo_reenable_on_distupgrade=\"true\""
  content = "repo_reenable_on_distupgrade=\"false\""
  target  = "/etc/default/microsoft-edge"
}

file "streamdeck-access" {
  source = "files/streamdeck_rules_udev"
  target = "/etc/udev/rules.d/60-streamdeck.rules"
  mode   = "0644"
}

# file "docker-daemon-config" {
#   source = "files/docker-daemon.json"
#   target = "/etc/docker/daemon.json"
#   mode   = "0644"
# }

file "proposed-priority" {
  content = <<-EOT
Package: *
Pin: release a=${ubuntu_suite}-proposed
Pin-Priority: 400
EOT
  target  = "/etc/apt/preferences.d/proposed-priority-400"
  mode    = "0644"
}

file "mozilla-ppa" {
  content = <<-EOT
Package: firefox thunderbird
Pin: release o=LP-PPA-mozillateam
Pin-Priority: 1001
EOT
  target  = "/etc/apt/preferences.d/mozillateam-priority-1001"
  mode    = "0644"
}

file "mozilla-security" {
  content = <<-EOT
Package: firefox thunderbird
Pin: release o=LP-PPA-ubuntu-mozilla-security
Pin-Priority: 1001
EOT
  target  = "/etc/apt/preferences.d/ubuntu-mozilla-security-priority-1001"
  mode    = "0644"
}

file "mozilla-no-snap" {
  content = <<-EOT
Package: firefox* thunderbird*
Pin: release o=Ubuntu*
Pin-Priority: -1
EOT
  target  = "/etc/apt/preferences.d/mozilla-no-snap"
  mode    = "0644"
}

file "no-install-recommends" {
  content = <<-EOT
APT::Install-Recommends "false";
APT::Get::Always-Include-Phased-Updates "true";
EOT
  target  = "/etc/apt/apt.conf.d/99custom"
  mode    = "0644"
}

file "user-avatar" {
  source = "files/avatar.png"
  target = "/usr/local/share/avatars/avatar.png"
  mode   = "0644"
}

file "npmrc" {
  content = <<-EOT
prefix=/home/${username}/.local/npm
EOT
  target  = "/home/${username}/.npmrc"
  owner   = username
  group   = username
  mode    = "0600"
}

file "wireplumber-usb-audio" {
  source = "files/99-usb-audio.conf"
  target = "/home/${username}/.config/wireplumber/wireplumber.conf.d/99-usb-audio.conf"
  owner  = username
  group  = username
  mode   = "0644"
}

package "ruby" {}
package "ruby-dev" {}
package "build-essential" {}
package "git" {}
package "urlscan" {}
package "mutt" {}
package "gnupg" {}
package "unzip" {}
package "dkms" {}
package "libdbus-glib-1-dev" {}
package "whois" {}
package "htop" {}
package "i965-va-driver" {}
package "libvdpau-va-gl1" {}
package "jq" {}
package "wireguard" {}
package "unrar" {}
package "w3m" {}
package "gimp" {}
package "pinentry-curses" {}
package "libsecret-1-dev" {}
package "mosh" {}
package "signal-desktop" {}
package "wl-clipboard" {}
package "silversearcher-ag" {}
package "shellcheck" {}
package "python3-pip" {}
package "python3-dev" {}
package "ttf-mscorefonts-installer" {}
package "fonts-font-awesome" {}
package "fonts-powerline" {}
package "libpam-u2f" {}
package "neovim" {}
package "libssl-dev" {}
package "code" {}
package "docker-ce" {}
package "gh" {}
package "gstreamer1.0-plugins-bad" {}
package "totem" {}
package "heif-gdk-pixbuf" {}
package "heif-thumbnailer" {}
package "xdg-desktop-portal-gnome" {}
package "ripgrep" {}
package "git-delta" {}
package "firefox" {}
package "solaar" {}
package "intel-media-va-driver-non-free" {}
package "net-tools" {}

package "golang-go" {
  state = "uninstalled"
}

package "thunderbird" {
  state = "uninstalled"
}

package "pidgin" {
  state = "uninstalled"
}

package "apport-gtk" {
  state = "uninstalled"
}

repository "docker" {
  uris          = ["https://download.docker.com/linux/ubuntu"]
  signed_by     = ["https://download.docker.com/linux/ubuntu/gpg"]
  suites        = ["${ubuntu_suite}"]
  components    = ["stable"]
  architectures = ["amd64"]
}

repository "signal" {
  uris          = ["https://updates.signal.org/desktop/apt"]
  suites        = ["xenial"]
  signed_by     = ["https://updates.signal.org/desktop/apt/keys.asc"]
  components    = ["main"]
  architectures = ["amd64"]
}

repository "hashicorp" {
  uris          = ["https://apt.releases.hashicorp.com"]
  suites        = ["jammy"]
  signed_by     = ["https://apt.releases.hashicorp.com/gpg"]
  components    = ["main"]
  architectures = ["amd64"]
}

repository "gh" {
  uris          = ["https://cli.github.com/packages"]
  suites        = ["stable"]
  signed_by     = ["https://cli.github.com/packages/githubcli-archive-keyring.gpg"]
  components    = ["main"]
  architectures = ["amd64"]
}

repository "microsoft-edge-vscode" {
  uris = [
    "https://packages.microsoft.com/repos/code",
    "https://packages.microsoft.com/repos/edge"
  ]
  suites        = ["stable"]
  signed_by     = ["https://packages.microsoft.com/keys/microsoft.asc"]
  components    = ["main"]
  architectures = ["amd64"]
}

repository "node" {
  uris          = ["https://deb.nodesource.com/node_24.x"]
  suites        = ["nodistro"]
  signed_by     = ["https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key"]
  components    = ["main"]
  architectures = ["amd64"]
}

repository "chrome" {
  uris          = ["https://dl.google.com/linux/chrome/deb/"]
  suites        = ["stable"]
  signed_by     = ["https://dl.google.com/linux/linux_signing_key.pub"]
  components    = ["main"]
  architectures = ["amd64"]
}

gsetting "enabled" {
  schema = "org.gnome.system.location"
  value  = "true"
}

gsetting "automatic-timezone" {
  schema = "org.gnome.desktop.datetime"
  value  = "true"
}

gsetting "clock-format" {
  schema = "org.gnome.desktop.interface"
  value  = "'24h'"
}

gsetting "clock-show-date" {
  schema = "org.gnome.desktop.interface"
  value  = "true"
}

gsetting "clock-show-weekday" {
  schema = "org.gnome.desktop.interface"
  value  = "true"
}

gsetting "color-scheme" {
  schema = "org.gnome.desktop.interface"
  value  = "'prefer-dark'"
}

gsetting "enable-hot-corners" {
  schema = "org.gnome.desktop.interface"
  value  = "false"
}

gsetting "show-battery-percentage" {
  schema = "org.gnome.desktop.interface"
  value  = "true"
}

gsetting "night-light-enabled" {
  schema = "org.gnome.settings-daemon.plugins.color"
  value  = "true"
}

gsetting "night-light-schedule-automatic" {
  schema = "org.gnome.settings-daemon.plugins.color"
  value  = "true"
}

gsetting "autohide" {
  schema = "org.gnome.shell.extensions.dash-to-dock"
  value  = "false"
}

gsetting "dock-fixed" {
  schema = "org.gnome.shell.extensions.dash-to-dock"
  value  = "false"
}

gsetting "intellihide" {
  schema = "org.gnome.shell.extensions.dash-to-dock"
  value  = "false"
}

gsetting "dash-max-icon-size" {
  schema = "org.gnome.shell.extensions.dash-to-dock"
  value  = "32"
}

gsetting "preferred-monitor" {
  schema = "org.gnome.shell.extensions.dash-to-dock"
  value  = "0"
}

gsetting "per-window" {
  schema = "org.gnome.desktop.input-sources"
  value  = "false"
}

gsetting "sources" {
  schema = "org.gnome.desktop.input-sources"
  value  = "[('xkb', 'us')]"
}

gsetting "xkb-options" {
  schema = "org.gnome.desktop.input-sources"
  value  = "['compose:ralt']"
}

gsetting "natural-scroll" {
  schema = "org.gnome.desktop.peripherals.mouse"
  value  = "true"
}

gsetting "two-finger-scrolling-enabled" {
  schema = "org.gnome.desktop.peripherals.touchpad"
  value  = "true"
}

gsetting "disable-microphone" {
  schema = "org.gnome.desktop.privacy"
  value  = "false"
}

gsetting "report-technical-problems" {
  schema = "org.gnome.desktop.privacy"
  value  = "false"
}

gsetting "click-policy" {
  schema = "org.gnome.nautilus.preferences"
  value  = "'single'"
}

gsetting "default-folder-viewer" {
  schema = "org.gnome.nautilus.preferences"
  value  = "'icon-view'"
}

gsetting "search-filter-time-type" {
  schema = "org.gnome.nautilus.preferences"
  value  = "'last_modified'"
}

gsetting "show-delete-permanently" {
  schema = "org.gnome.nautilus.preferences"
  value  = "true"
}

gsetting "custom-keybindings" {
  schema = "org.gnome.settings-daemon.plugins.media-keys"
  value  = "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']"
}

gsetting "logout" {
  schema = "org.gnome.settings-daemon.plugins.media-keys"
  value  = "@as []"
}

gsetting "terminal" {
  schema = "org.gnome.settings-daemon.plugins.media-keys"
  value  = "['<Super>Return']"
}

gsetting "binding" {
  schema = "org.gnome.settings-daemon.plugins.media-keys.custom-keybinding"
  path   = "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
  value  = "'<Primary><Alt>Delete'"
}

gsetting "command" {
  schema = "org.gnome.settings-daemon.plugins.media-keys.custom-keybinding"
  path   = "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
  value  = "'systemctl suspend'"
}

gsetting "name" {
  schema = "org.gnome.settings-daemon.plugins.media-keys.custom-keybinding"
  path   = "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
  value  = "'Suspend'"
}

gsetting "show-home" {
  schema = "org.gnome.shell.extensions.ding"
  value  = "false"
}

gsetting "enable-tiling-popup" {
  schema = "org.gnome.shell.extensions.tiling-assistant"
  value  = "false"
}

gsetting "maximize" {
  schema = "org.gnome.desktop.wm.keybindings"
  value  = "['<Alt>Down']"
}
