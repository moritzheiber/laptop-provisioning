module RustToolHelper
  def self.package_installed?(command, version)
    !(Regexp.compile(version) =~ IO.popen("#{command} --version 2>&1").read.strip).nil?
  end
end

define :rust_tool_install, checksum: nil, version: nil, url: nil do
  name = params[:name]
  version = params[:version]
  url = params[:url]
  cs = params[:checksum]

  dest = "/tmp/rust_tool_#{name}_#{version}.tar.gz"
  installed = RustToolHelper.package_installed?(name, version)

  download url do
    destination dest
    checksum cs if cs
    not_if { installed }
  end

  execute "Extracting #{dest}" do
    command "tar xf #{dest} -C /usr/bin/"
    not_if { installed }
  end

  file dest do
    action :delete
  end
end
