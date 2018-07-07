module HashiHelper
  def self.package_installed?(name, version)
    !(/#{version}/ =~ %x(#{name} --version 2> /dev/null).gsub("\n", '')).nil?
  end
end

define :hashicorp_install, version: nil, checksum: nil, source_url: nil do
  name = params[:name]
  version = params[:version]
  source_url = params[:source_url]
  dest = "/tmp/#{name}.zip"
  cs = params[:checksum]
  installed = HashiHelper.package_installed?(name, version)

  download source_url do
    destination dest
    checksum cs if cs
    not_if { installed }
  end

  execute "Extracting #{dest} for #{name}" do
    command "unzip -d /usr/bin/ #{dest}"
    not_if { installed }
  end

  file dest do
    action :delete
  end
end
