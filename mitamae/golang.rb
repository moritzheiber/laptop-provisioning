%w(
  github.com/schachmat/wego
  github.com/dutchcoders/geodig
  github.com/campoy/embedmd
  github.com/sourcegraph/go-langserver
  golang.org/x/lint/golint
).each do |repo|
  name = repo.split('/').last

  go_get name do
    repository repo
    user node[:login_user]
  end
end
