service 'apport' do
  action :disable
end

display_conf = <<EOS
[SeatDefaults]
display-setup-script=xrandr --output eDP-1 --primary --mode 1920x1080
EOS

file '/etc/lightdm/lightdm.conf.d/display.conf' do
  content display_conf
  mode '0644'
end

avatar_path = '/etc/lightdm/avatar.png'
file avatar_path  do
  content 'files/avatar.png'
  mode '0644'
end

execute 'update-avatar' do
  command "dbus-send --system --dest=org.freedesktop.Accounts --type=method_call --print-reply /org/freedesktop/Accounts/User#{Etc.getpwnam(node[:login_user]).uid} org.freedesktop.Accounts.User.SetIconFile string:\"#{avatar_path}\""
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
  url 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  destination "/home/#{node[:login_user]}/.local/share/nvim/site/autoload/plug.vim"
  checksum node[:vim_plug_checksum]
  user node[:login_user]
end
