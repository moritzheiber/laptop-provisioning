# template '/etc/udev/rules.d/99-security-keys.rules' do
#   mode '0644'
#   content <<CONTENT
# ACTION!="add|change", GOTO="u2f_custom_end"
# <% @devices.each do |device| %>
# KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0664", GROUP="plugdev", TAG+="uaccess", ATTRS{idVendor}=="<%= device[:vendor] %>", ATTRS{idProduct}=="<%= device[:product] %>"
# SUBSYSTEM=="tty", ATTRS{idVendor}=="<%= device[:vendor] %>", ATTRS{idProduct}=="<%= device[:product] %>", TAG+="uaccess"<% end %>
# LABEL="u2f_custom_end"
# CONTENT
#   variables(
#     devices: [
#       # Yubikeys
#       { vendor: '1050', product: '0113|0114|0115|0116|0120|0121|0200|0402|0403|0406|0407|0410' },
#       # Nitrokeys
#       { vendor: '20a0', product: '4287|42b1|42b3' },
#       # Solokeys
#       { vendor: '0483', product: 'a2ca' }
#     ]
#   )
#   notifies :run, 'execute[service udev restart]', :immediately
# end
#
# remote_file '/usr/share/pam-configs/u2f' do
#   source 'files/u2f'
#   mode '0644'
#   notifies :run, 'execute[pam-auth-update --enable u2f]'
# end
#
# execute 'pam-auth-update --enable u2f' do
#   action :nothing
# end

template '/etc/udev/rules.d/99-disabled-ir-camera.rules' do
  mode '0644'
  content <<CONTENT
ACTION!="add|change", GOTO="disable_ir_camera"
ATTRS{idVendor}=="04f2",ATTRS{idProduct}=="b615",ATTR{bConfigurationValue}="0"
LABEL="disable_ir_camera"
CONTENT
  notifies :run, 'execute[service udev restart]', :immediately
end

execute 'service udev restart' do
  action :nothing
end
