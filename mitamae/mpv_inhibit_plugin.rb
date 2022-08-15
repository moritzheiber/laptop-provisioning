plugin_name = 'mpv_inhibit_gnome.so'
git_dir = '/tmp/mpv_inhibit_gnome'
dest = "/home/#{node[:login_user]}/.config/mpv/scripts"
plugin_file = "#{dest}/#{plugin_name}"

directory dest do
  user node[:login_user]
  owner node[:login_user]
  group node[:login_user]
end

git git_dir do
  repository 'https://github.com/Guldoman/mpv_inhibit_gnome.git'
  not_if "test -f #{plugin_file}"
  user node[:login_user]
  notifies :run, 'execute[make_gnome_plugin]', :immediately
end

execute 'make_gnome_plugin' do
  cwd git_dir
  user node[:login_user]
  action :nothing
  command 'make'
  notifies :run, 'execute[mpv_plugin_install]', :immediately
end

execute 'mpv_plugin_install' do
  command "install -m0755 -o #{node[:login_user]} -g #{node[:login_user]} #{git_dir}/bin/#{plugin_name} #{plugin_file}"
  action :nothing
  user node[:login_user]
end

directory 'git_directory' do
  action :delete
  path git_dir
end
