go_path = "/home/#{node[:login_user]}/Code/go-workspace"
go_root = "/usr/lib/go-#{node[:golang_version]}"
go_package_install_command = <<-EOS
  export GOPATH="#{go_path}"
  export GOROOT="#{go_root}"
  export PATH="#{go_root}/bin:${PATH}"
EOS

define :go_get, repository: nil do
  name = params[:name]
  repository = params[:repository] if params[:repository]

  execute "Installing golang package #{name}" do
    command("#{go_package_install_command} go get -u #{repository}")
    user node[:login_user]
    not_if "test -x #{go_path}/bin/#{name}"
  end unless repository.nil?
end
