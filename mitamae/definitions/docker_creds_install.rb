module DockerCredsHelper
  def self.package_installed?(version)
    !(/#{version}/ =~ `docker-credential-secretservice version 2> /dev/null`.gsub("\n", '')).nil?
  end
end

define :docker_creds_install, checksum: nil, source_url: nil do
  version = params[:name]
  source_url = params[:source_url]
  dest = "/tmp/docker_creds_#{version}.tar.gz"
  cs = params[:checksum]
  installed = DockerCredsHelper.package_installed?(version)

  download source_url do
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
