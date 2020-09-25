directory "/home/#{node[:login_user]}/.terraform.d/plugin-cache" do
  owner node[:login_user]
  group node[:login_user]
  mode '755'
end

template "/home/#{node[:login_user]}/.terraformrc" do
  content <<RC
plugin_cache_dir = "$HOME/.terraform.d/plugin-cache"
RC
  owner node[:login_user]
  group node[:login_user]
  mode '600'
end
