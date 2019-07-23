service 'apport' do
  action :disable
end

display_conf = <<DISPLAY
[SeatDefaults]
display-setup-script=xrandr --output eDP-1 --primary --mode 1920x1080
DISPLAY

directory '/etc/lightdm/lightdm.conf.d'

file '/etc/lightdm/lightdm.conf.d/display.conf' do
  content display_conf
  mode '0644'
end

avatar_path = '/etc/lightdm/avatar.png'
remote_file avatar_path  do
  source 'files/avatar.png'
  mode '0644'
end

execute 'update-avatar' do
  command "dbus-send --system --dest=org.freedesktop.Accounts --type=method_call --print-reply /org/freedesktop/Accounts/User#{Etc.getpwnam(node[:login_user]).uid} org.freedesktop.Accounts.User.SetIconFile string:\"#{avatar_path}\""
  only_if 'ps aux | grep -q "[d]bus-daemon"'
end

xsession_file = '/etc/X11/Xsession.options'
file xsession_file do
  action :edit
  block do |content|
    content.gsub!(/^use-ssh-agent/, 'no-use-ssh-agent')
  end
  not_if "grep -q 'no-use-ssh-agent' #{xsession_file}"
end

download 'vim-plug' do
  url "https://raw.githubusercontent.com/junegunn/vim-plug/#{node[:vim_plug_commit_hash]}/plug.vim"
  destination "/home/#{node[:login_user]}/.local/share/nvim/site/autoload/plug.vim"
  checksum node[:vim_plug_checksum]
  user node[:login_user]
end

directory "/home/#{node[:login_user]}/Code/thoughtworks" do
  mode '0755'
  user node[:login_user]
end

remote_file "/home/#{node[:login_user]}/Code/thoughtworks/gitconfig" do
  source 'files/tw_gitconfig'
  mode '0644'
  user node[:login_user]
end
