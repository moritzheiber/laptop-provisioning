module TerraformLspHelper
  def self.package_installed?(binary)
    File::Stat.new(binary).executable?
  rescue Errno::ENOENT => _
    false
  end
end

define :terraform_lsp_install,
       checksum: nil,
       destination: nil,
       source_url: nil do
  version = params[:name]
  source_url = params[:source_url]
  cs = params[:checksum]
  destination = params[:destination]

  tmp_dest = "/tmp/terraform_lsp_#{version}.tar.gz"
  installed = TerraformLspHelper.package_installed?("#{destination}/terraform-lsp")

  download source_url do
    destination tmp_dest
    checksum cs if cs
    not_if { installed }
  end
  execute "Extracting #{tmp_dest}" do
    command "tar xf #{tmp_dest} -C #{destination}/ terraform-lsp"
    not_if { installed }
  end

  file tmp_dest do
    action :delete
  end
end
