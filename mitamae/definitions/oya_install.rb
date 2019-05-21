module OyaHelper
  def self.package_installed?(binary, version)
    !(Regexp.compile(version) =~ `#{binary} --version 2> /dev/null`.lines.first).nil?
  end
end

define :oya_install,
       checksum: nil,
       destination: nil,
       source_url: nil do
  version = params[:name]
  source_url = params[:source_url]
  cs = params[:checksum]
  destination = params[:destination]

  tmp_dest = "/tmp/oya_#{version}.gz"
  installed = OyaHelper.package_installed?(destination, version)

  download source_url do
    destination tmp_dest
    checksum cs if cs
    not_if { installed }
  end
  execute "Extracting #{tmp_dest}" do
    command "gunzip -c #{tmp_dest} > #{destination}"
    user node[:login_user]
    not_if { installed }
  end

  execute 'Making binary executable' do
    command "chmod +x #{destination}"
    user node[:login_user]
    not_if { installed }
  end

  file tmp_dest do
    action :delete
  end
end
