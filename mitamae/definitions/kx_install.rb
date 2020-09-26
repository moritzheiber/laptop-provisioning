module KxHelper
  def self.package_installed?(command = 'kx', version)
    !(Regexp.compile(version) =~ IO.popen("#{command} --version 2>&1").read.strip).nil?
  end
end

define :kx_install, checksum: nil do
  version = params[:name]
  dest = "/tmp/kx_#{version}.tar.gz"
  cs = params[:checksum]
  installed = KxHelper.package_installed?(version)

  download "https://github.com/onatm/kx/releases/download/v#{version}/kx-v#{version}-linux-amd64.tar.gz" do
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
