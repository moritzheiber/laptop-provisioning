template '/etc/udev/rules.d/99-security-keys.rules' do
  mode '0644'
  content <<CONTENT
<% @devices.each do |device| %>
KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0664", GROUP="plugdev", ATTRS{idVendor}=="<%= device[:vendor] %>", ATTRS{idProduct}=="<%= device[:product] %>"<% end %>
CONTENT
  variables(
    devices: [
      { vendor: '2581', product: 'f1d0' },
      { vendor: '20a0', product: '4287' },
      { vendor: '0483', product: 'a2ca' }
    ]
  )
  # Nitrokey
  # Nitrokey
  # Solokey
  notifies :run, 'execute[udevadm control --reload-rules]', :immediately
end

remote_file '/usr/share/pam-configs/u2f' do
  source 'files/u2f'
  mode '0644'
  notifies :run, 'execute[pam-auth-update --enable u2f]'
end

execute 'pam-auth-update --enable u2f' do
  action :nothing
end

execute 'udevadm control --reload-rules' do
  action :nothing
end
