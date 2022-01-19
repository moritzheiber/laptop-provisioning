module GsettingsHelper
  def self.check_setting(setting, expected_value)
    expected_value == `gsettings get #{setting}`.lines.first
  end
end

{
  'org.gnome.nm-applet disable-disconnected-notifications': 'true',
  'org.gnome.nm-applet disable-connected-notifications': 'true',
  'org.gnome.shell.extensions.dash-to-dock autohide': 'false',
  'org.gnome.shell.extensions.dash-to-dock dock-fixed': 'false',
  'org.gnome.shell.extensions.dash-to-dock intellihide': 'false',
  'org.gnome.shell.extensions.dash-to-dock dash-max-icon-size': '32',
  'org.gnome.shell.extensions.dash-to-dock preferred-monitor': '0',
  'org.gnome.desktop.input-sources per-window': 'false',
  'org.gnome.desktop.input-sources sources': '[(\'xkb\', \'us\')]',
  'org.gnome.desktop.input-sources xkb-options': '[\'compose:ralt\']',
  'org.gnome.desktop.peripherals.mouse natural-scroll': 'true',
  'org.gnome.desktop.peripherals.touchpad two-finger-scrolling-enabled': 'true',
  'org.gnome.desktop.privacy disable-microphone': 'false',
  'org.gnome.desktop.privacy report-technical-problems': 'false',
  'org.gnome.nautilus.preferences click-policy': 'single',
  'org.gnome.nautilus.preferences default-folder-viewer': 'icon-view',
  'org.gnome.nautilus.preferences search-filter-time-type': 'last_modified',
  'org.gnome.nautilus.preferences show-delete-permanently': 'true',
  'org.gnome.settings-daemon.plugins.media-keys custom-keybindings': '[\'/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/\']',
  'org.gnome.settings-daemon.plugins.media-keys logout': '@as []',
  'org.gnome.settings-daemon.plugins.media-keys terminal': '[\'<Super>Return\']',
  'org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding': '<Primary><Alt>Delete',
  'org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command': 'systemctl suspend',
  'org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name': 'Suspend',
  'org.gnome.shell.extensions.ding show-home': 'false'
}.each do |setting, value|
  execute "Setting #{setting} to #{value}" do
    command "DBUS_SESSION_BUS_ADDRESS=\"unix:path=/run/user/$(id -u)/bus\" gsettings set #{setting} \"#{value}\""
    not_if { GsettingsHelper.check_setting(setting, value) }
    user node[:login_user]
  end
end
