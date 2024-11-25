service 'apport' do
  action :disable
end

avatar_path = '/usr/local/share/avatars'
avatar_file = "#{avatar_path}/avatar.png"

directory avatar_path do
  mode '0755'
end

remote_file avatar_file do
  source 'files/avatar.png'
  mode '0644'
end

execute 'update-avatar' do
  command "dbus-send --system --dest=org.freedesktop.Accounts --type=method_call --print-reply /org/freedesktop/Accounts/User#{node[:user][node[:login_user].to_s][:uid]} org.freedesktop.Accounts.User.SetIconFile string:\"#{avatar_file}\""
  only_if 'ps aux | grep -q "[d]bus-daemon"'
end

download 'vim-plug' do
  url "https://raw.githubusercontent.com/junegunn/vim-plug/#{node[:vim_plug_commit_hash]}/plug.vim"
  destination "/home/#{node[:login_user]}/.local/share/nvim/site/autoload/plug.vim"
  checksum node[:vim_plug_checksum]
  user node[:login_user]
end

%w{
  private
  1k5
}.each do |dir|
  directory "/home/#{node[:login_user]}/Code/#{dir}" do
    mode '0755'
    owner node[:login_user]
    group node[:login_user]
    user node[:login_user]
  end

  remote_file "/home/#{node[:login_user]}/Code/#{dir}/gitconfig" do
    source "files/#{dir}_gitconfig"
    mode '0644'
    owner node[:login_user]
    group node[:login_user]
  end
end

file "/home/#{node[:login_user]}/.npmrc" do
  owner node[:login_user]
  group node[:login_user]
  mode '0600'
  content <<-FILE
prefix=/home/#{node[:login_user]}/.local/npm
  FILE
end

wireplumber_dir = "/home/#{node[:login_user]}/.config/wireplumber/wireplumber.conf.d"

directory wireplumber_dir do
  owner node[:login_user]
  group node[:login_user]
  mode '0755'
  user node[:login_user]
end

remote_file "#{wireplumber_dir}/99-usb-audio.conf" do
  source 'files/99-usb-audio.conf'
  mode '0644'
  owner node[:login_user]
  group node[:login_user]
  subscribes :create, "directory[#{wireplumber_dir}]", :immediately
end

bluetooth_config_file = '/etc/bluetooth/main.conf'
file bluetooth_config_file do
  action :edit
  block do |content|
    content.gsub!(/^#FastConnectable.?=.?(true|false)/, 'FastConnectable=true')
  end
  only_if "grep -qP '#FastConnectable.?=.?(true|false)' #{bluetooth_config_file}"
  notifies :restart, 'service[bluetooth]', :immediately
end

service 'bluetooth' do
  action :nothing
end

execute 'enable fingerprint auth' do
  command 'pam-auth-update --enable fprintd'
  not_if 'grep -q fprintd /etc/pam.d/common-auth'
end

geoclue_confd_dir = '/etc/geoclue/conf.d'

directory geoclue_confd_dir do
  mode '0755'
  owner 'root'
  group 'root'
end

template "#{geoclue_confd_dir}/99-beacondb.conf" do
  mode '0644'
  content <<CONTENT
[wifi]
enabled = true
url = https://api.beacondb.net/v1/geolocate
CONTENT
  notifies :restart, 'service[geoclue]', :immediately
end

service 'geoclue' do
  action :nothing
end

# This is only relevant for systems with ZFS
# You would probably want to set this dynamically using node[]
# but I cannot be bothered right now
size_in_gb = 4
size_of_arc_cache = size_in_gb * 1024 * 1024 * 1024

template '/etc/modprobe.d/zfs.conf' do
  mode '0644'
  content <<CONTENT
options zfs zfs_arc_max=#{size_of_arc_cache}
CONTENT
end

# Shut up, wpa_supplicant
wpa_supplicant_override_dir = '/etc/systemd/system/wpa_supplicant.service.d'
directory wpa_supplicant_override_dir do
  owner 'root'
  group 'root'
  mode '0755'
end

remote_file "#{wpa_supplicant_override_dir}/override.conf" do
  source 'files/wpa_supplicant_override.conf'
  mode '0644'
  owner 'root'
  group 'root'
  notifies :restart, 'service[wpa_supplicant]', :immediately
end

service 'wpa_supplicant' do
  action :nothing
end
