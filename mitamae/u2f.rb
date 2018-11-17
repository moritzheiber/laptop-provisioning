remote_file '/usr/share/pam-configs/u2f' do
  source 'files/u2f'
  mode '0644'
  notifies :run, 'execute[pam-auth-update --enable u2f]'
end

execute 'pam-auth-update --enable u2f' do
  action :nothing
end
