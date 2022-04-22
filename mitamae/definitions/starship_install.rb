module StarshipHelper
  def self.package_installed?(command = 'starship', version)
    !(Regexp.compile(version) =~ IO.popen("#{command} --version").read.strip).nil?
  end
end

define :starship_install, checksum: nil do
  version = params[:name]
  dest = "/tmp/starship-#{version}.tar.gz"
  cs = params[:checksum]
  installed = StarshipHelper.package_installed?(version)

  download "https://github.com/starship/starship/releases/download/v#{node[:starship_version]}/starship-x86_64-unknown-linux-musl.tar.gz" do
    destination dest
    checksum cs if cs
    not_if { installed }
  end

  execute "Extracting #{dest}" do
    command "tar xf #{dest} -C /usr/bin/ starship"
    not_if { installed }
  end

  file dest do
    action :delete
  end
end
