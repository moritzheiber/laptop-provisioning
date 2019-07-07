module GoChromecastHelper
  def self.package_installed?(binary, version)
    !(Regexp.compile("v#{version}") =~ `#{binary} --version 2> /dev/null`.lines.first).nil?
  end
end

define :go_chromecast_install,
       checksum: nil,
       destination: nil,
       source_url: nil do
  version = params[:name]
  source_url = params[:source_url]
  cs = params[:checksum]
  destination = params[:destination]

  tmp_dest = "/tmp/go_chromecast_#{version}.tar.gz"
  installed = GoChromecastHelper.package_installed?("#{destination}/go-chromecast", version)

  download source_url do
    destination tmp_dest
    checksum cs if cs
    not_if { installed }
  end
  execute "Extracting #{tmp_dest}" do
    command "tar xf #{tmp_dest} -C #{destination}/ go-chromecast"
    not_if { installed }
  end

  file tmp_dest do
    action :delete
  end
end
