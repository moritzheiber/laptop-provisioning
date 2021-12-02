module GsettingsHelper
  def self.check_setting(setting, expected_value)
    !(Regexp.compile(expected_value) =~ `gsettings get #{setting}`.lines.first).nil?
  end
end

{
  'org.gnome.nm-applet disable-disconnected-notifications': 'true',
  'org.gnome.nm-applet disable-connected-notifications': 'true'
}.each do |setting, value|
  execute "Setting #{setting} to #{value}" do
    command "gsettings set #{setting} #{value}"
    not_if { GsettingsHelper.check_setting(setting, value) }
    user node[:login_user]
  end
end
