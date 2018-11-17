remote_file '/etc/udev/rules.d/41-nitrokey.rules' do
  source 'files/41-nitrokey.rules'
  mode '0644'
  notifies :run, 'execute[service udev restart]', :immediately
end

remote_file '/usr/share/pam-configs/u2f' do
  source 'files/u2f'
  mode '0644'
  notifies :run, 'execute[pam-auth-update --enable u2f]'
end

execute 'pam-auth-update --enable u2f' do
  action :nothing
end

execute 'service udev restart' do
  action :nothing
end
