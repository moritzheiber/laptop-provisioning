apt 'vagrant' do
  # We need to specify the epoch here
  # For a reference look at deb-version(5)
  version "1:#{node[:vagrant_version]}"
  source_url "https://releases.hashicorp.com/vagrant/#{node[:vagrant_version]}/vagrant_#{node[:vagrant_version]}_x86_64.deb"
end

{
  'packer' => {
    version: node[:packer_version],
    checksum: node[:packer_checksum]
  },
  'terraform' => {
    version: node[:terraform_version],
    checksum: node[:terraform_checksum]
  },
  'vault' => {
    version: node[:vault_version],
    checksum: node[:vault_checksum]
  }
}.each do |tool, info|
  hashicorp_install tool do
    version info[:version]
    checksum info[:checksum]
    source_url "https://releases.hashicorp.com/#{tool}/#{info[:version]}/#{tool}_#{info[:version]}_linux_amd64.zip"
  end
end

directory "/home/#{node[:login_user]}/.terraform.d/plugin-cache" do
  user node[:login_user]
  mode "755"
end

template "/home/#{node[:login_user]}/.terraformrc" do
  content <<RC
plugin_cache_dir = "$HOME/.terraform.d/plugin-cache"
RC
  mode "600"
  user node[:login_user]
end
