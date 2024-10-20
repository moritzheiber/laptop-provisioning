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

wireplumber_dir = "/home/#{node[:login_user]}/.config/wireplumber/main.lua.d"

directory wireplumber_dir do
  owner node[:login_user]
  group node[:login_user]
  mode '0755'
  user node[:login_user]
end

remote_file "#{wireplumber_dir}/51-focusrite.lua" do
  source 'files/51-focusrite.lua'
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
