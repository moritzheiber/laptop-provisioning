apt_conf = <<APT_CONF
APT::Install-Recommends "false";
APT::Get::Always-Include-Phased-Updates "true";
APT_CONF

file '/etc/apt/apt.conf.d/99custom' do
  content apt_conf
  mode '0644'
end
