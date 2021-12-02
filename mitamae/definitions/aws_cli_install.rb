module AwsCliHelper
  def self.package_installed?(binary, version)
    !(Regexp.compile(version) =~ `#{binary} --version 2> /dev/null`.lines.first).nil?
  end
end

define :aws_cli_install,
       checksum: nil,
       destination: nil,
       source_url: nil do
  version = params[:name]
  source_url = params[:source_url]
  cs = params[:checksum]
  destination = params[:destination]
  install_dest = destination.split('/')[0...-1].join('/')
  installed = AwsCliHelper.package_installed?(destination, version)

  tmp_directory = "/tmp/awscliv2_#{version}"
  tmp_dest = "#{tmp_directory}.zip"

  download source_url do
    destination tmp_dest
    checksum cs if cs
    not_if { installed }
  end

  directory tmp_directory do
    action :create
    user node[:login_user]
    not_if { installed }
  end

  execute 'Unzip AWS CLI v2' do
    command "unzip #{tmp_dest} -d #{tmp_directory}/"
    user node[:login_user]
    not_if { installed }
  end

  execute 'Install AWS CLI v2' do
    command "#{tmp_directory}/aws/install -u --install-dir #{install_dest}/aws-cli --bin-dir ~/.local/bin"
    user node[:login_user]
    not_if { installed }
  end

  directory tmp_directory do
    action :delete
  end

  file tmp_dest do
    action :delete
  end
end
