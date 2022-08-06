module McflyHelper
  def self.package_installed?(command = 'mcfly', version)
    !(Regexp.compile(version) =~ IO.popen("#{command} --version").read.strip).nil?
  end
end

define :mcfly_install, checksum: nil do
  version = params[:name]
  dest = "/tmp/mcfly-#{version}.tar.gz"
  cs = params[:checksum]
  installed = McflyHelper.package_installed?(version)

  download "https://github.com/cantino/mcfly/releases/download/v#{node[:mcfly_version]}/mcfly-v#{node[:mcfly_version]}-x86_64-unknown-linux-musl.tar.gz" do
    destination dest
    checksum cs if cs
    not_if { installed }
  end

  execute "Extracting #{dest}" do
    command "tar xf #{dest} -C /usr/bin/ mcfly"
    not_if { installed }
  end

  file dest do
    action :delete
  end
end
