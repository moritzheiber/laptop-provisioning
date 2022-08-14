include_recipe 'definitions/add_user_to_group'
include_recipe 'definitions/go_get'
include_recipe 'definitions/rustup'
include_recipe 'definitions/docker_creds_install'
include_recipe 'definitions/fzf_install'
include_recipe 'definitions/helm_install'
include_recipe 'definitions/go_chromecast_install'
include_recipe 'definitions/k9s_install'
include_recipe 'definitions/rust_tool_install'
include_recipe 'definitions/gossm_install'
include_recipe 'definitions/terraform_docs_install'
include_recipe 'definitions/aws_cli_install'
include_recipe 'definitions/starship_install'
include_recipe 'definitions/mcfly_install'

include_recipe 'repos'
include_recipe 'packages'
include_recipe 'docker'
include_recipe 'hashicorp'
include_recipe 'configuration'
include_recipe 'udev'
include_recipe 'gsettings'
include_recipe 'mpv_inhibit_plugin'
