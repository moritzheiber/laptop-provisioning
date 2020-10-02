module GossmHelper
  def self.package_installed?(command = 'gossm', version)
    !(Regexp.compile(version) =~ IO.popen("#{command} --version 2>&1").read.strip).nil?
  end
end

define :gossm_install, checksum: nil do
  version = params[:name]
  dest = "/tmp/gossm_#{version}.tar.gz"
  cs = params[:checksum]
  installed = GossmHelper.package_installed?(version)

  download "https://github.com/gjbae1212/gossm/releases/download/v#{version}/gossm_#{version}_Linux_x86_64.tar.gz" do
    destination dest
    checksum cs if cs
    not_if { installed }
  end

  execute "Extracting #{dest}" do
    command "tar xf #{dest} -C /usr/bin/ gossm"
    not_if { installed }
  end

  file dest do
    action :delete
  end
end
