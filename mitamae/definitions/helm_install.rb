module HelmHelper
  def self.package_installed?(binary, version)
    !(Regexp.compile("v#{version}") =~ `#{binary} version -c 2> /dev/null`.lines.first).nil?
  end
end

define :helm_install,
       checksum: nil,
       destination: nil,
       source_url: nil do
  version = params[:name]
  source_url = params[:source_url]
  cs = params[:checksum]
  destination = params[:destination]

  tmp_dest = "/tmp/helm_#{version}.tar.gz"
  installed = HelmHelper.package_installed?("#{destination}/helm", version)

  download source_url do
    destination tmp_dest
    checksum cs if cs
    not_if { installed }
  end
  execute "Extracting #{tmp_dest}" do
    command "tar xf #{tmp_dest} -C #{destination}/ --strip-components=1 linux-amd64/helm linux-amd64/tiller"
    not_if { installed }
  end

  file tmp_dest do
    action :delete
  end
end
