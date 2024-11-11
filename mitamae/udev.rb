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

template '/etc/udev/rules.d/99-enable-write-access-logi-dock.rules' do
  mode '0644'
  content <<CONTENT
KERNEL=="hidraw*",SUBSYSTEM=="hidraw",ATTRS{idVendor}=="046d",ATTRS{idProduct}=="0af4",MODE="0666"
CONTENT
  notifies :restart, 'service[udev]', :immediately
end

service 'udev' do
  action :nothing
end
