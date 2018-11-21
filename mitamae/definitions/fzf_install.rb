module FzfHelper
  def self.package_installed?(binary, version)
    !(Regexp.compile(version) =~ `#{binary} --version 2> /dev/null`.lines.first).nil?
  end
end

define :fzf_install,
       checksum: nil,
       destination: nil,
       source_url: nil do
  version = params[:name]
  source_url = params[:source_url]
  cs = params[:checksum]
  destination = params[:destination]
  install_dest = destination.split('/')[0...-1].join('/')

  tmp_dest = "/tmp/fzf_#{version}.tar.gz"
  installed = FzfHelper.package_installed?(destination, version)

  download source_url do
    destination tmp_dest
    checksum cs if cs
    not_if { installed }
  end
  execute "Extracting #{tmp_dest}" do
    command "tar xf #{tmp_dest} -C #{install_dest}/"
    user node[:login_user]
    not_if { installed }
  end

  file tmp_dest do
    action :delete
  end
end
