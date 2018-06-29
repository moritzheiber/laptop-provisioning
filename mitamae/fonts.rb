fonts_dir = "/home/#{node[:login_user]}/.fonts"
fontconfig_dir = "/home/#{node[:login_user]}/.config/fontconfig/conf.d"

[fonts_dir, fontconfig_dir].each do |dir|
  directory dir do
    user node[:login_user]
  end
end

download 'powerline-font' do
  url 'https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf'
  destination "#{fonts_dir}/PowerlineSymbols.otf"
  checksum '4a2496a009b1649878ce067a7ec2aed9f79656c90136971e1dba00766515f7a1'
  user node[:login_user]
  notifies :run, 'execute[update-font-cache]'
end

download 'font-configuration' do
  url 'https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf'
  destination "#{fontconfig_dir}/10-powerline-symbols.conf"
  checksum '079f6d44d34feebdc2ae7aee791090d6bfb1fec8a0359439368aa2efc5a0c0f7'
  user node[:login_user]
end

execute 'update-font-cache' do
  command "fc-cache -vf #{fonts_dir}"
  action :nothing
  user node[:login_user]
end
