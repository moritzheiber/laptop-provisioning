directory '/etc/udev/rules.d' do
  mode '0755'
  owner 'root'
  group 'root'
end

template '/etc/udev/rules.d/99-disabled-ir-camera.rules' do
  mode '0644'
  content <<CONTENT
ACTION!="add|change", GOTO="disable_ir_camera"
ATTRS{idVendor}=="04f2",ATTRS{idProduct}=="b615",ATTR{bConfigurationValue}="0"
LABEL="disable_ir_camera"
CONTENT
  notifies :restart, 'service[udev]', :immediately
end

service 'udev' do
  action :nothing
end
