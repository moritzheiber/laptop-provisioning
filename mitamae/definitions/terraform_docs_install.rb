module TerraformDocsHelper
  def self.package_installed?(command = 'terraform-docs', version)
    !(Regexp.compile(version) =~ IO.popen("#{command} --version 2>&1").read.strip).nil?
  end
end

define :terraform_docs_install, checksum: nil do
  version = params[:name]
  dest = "/tmp/terraform_docs_#{version}.tar.gz"
  cs = params[:checksum]
  installed = TerraformDocsHelper.package_installed?(version)

  download "https://github.com/terraform-docs/terraform-docs/releases/download/v#{version}/terraform-docs-v#{version}-linux-amd64.tar.gz" do
    destination dest
    checksum cs if cs
    not_if { installed }
  end

  execute "Extracting #{dest}" do
    command "tar xf #{dest} -C /usr/bin/ terraform-docs"
    not_if { installed }
  end

  file dest do
    action :delete
  end
end
