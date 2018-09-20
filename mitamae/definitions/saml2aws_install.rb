module Saml2AwsHelper
  def self.package_installed?(version)
    backend = Specinfra::Backend::Exec.new(shell: '/bin/sh')
    !(Regexp.compile(version) =~ backend.run_command('saml2aws --version').stderr.strip).nil?
  end
end

define :saml2aws_install, checksum: nil do
  version = params[:name]
  dest = "/tmp/saml2aws_#{version}.tar.gz"
  cs = params[:checksum]
  installed = Saml2AwsHelper.package_installed?(version)

  download "https://github.com/Versent/saml2aws/releases/download/v#{version}/saml2aws_#{version}_linux_amd64.tar.gz" do
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
