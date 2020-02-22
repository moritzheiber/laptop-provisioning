module K9sHelper
  def self.package_installed?(binary, version)
    !(Regexp.compile(version) =~ `#{binary} version 2> /dev/null`).nil?
  end
end

define :k9s_install,
       checksum: nil,
       destination: nil,
       source_url: nil do
  version = params[:name]
  source_url = params[:source_url]
  cs = params[:checksum]
  destination = params[:destination]

  tmp_dest = "/tmp/k9s_#{version}.tar.gz"
  installed = K9sHelper.package_installed?("#{destination}/k9s", version)

  download source_url do
    destination tmp_dest
    checksum cs if cs
    not_if { installed }
  end
  execute "Extracting #{tmp_dest}" do
    command "tar xf #{tmp_dest} -C #{destination}/ k9s"
    not_if { installed }
  end

  file tmp_dest do
    action :delete
  end
end
