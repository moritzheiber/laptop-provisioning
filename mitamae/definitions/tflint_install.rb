module TflintCliHelper
  def self.package_installed?(binary, version)
    !(Regexp.compile(version) =~ `#{binary} --version 2> /dev/null`.lines.first).nil?
  end
end

define :tflint_install,
       checksum: nil,
       destination: nil,
       source_url: nil do
  version = params[:name]
  source_url = params[:source_url]
  cs = params[:checksum]
  destination = params[:destination]
  install_dest = destination.split('/')[0...-1].join('/')
  installed = TflintCliHelper.package_installed?(destination, version)
  tmp_file = "/tmp/tflint_#{version}.zip"

  download source_url do
    destination tmp_file
    checksum cs if cs
    not_if { installed }
  end

  execute 'Unzip tflint' do
    command "unzip -uo #{tmp_file} tflint -d #{install_dest}/"
    not_if { installed }
  end

  file tmp_file do
    action :delete
  end
end
