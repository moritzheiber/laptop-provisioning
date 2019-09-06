define :add_user_to_group, group: nil do
  user = params[:name]
  group = params[:group]

  execute "usermod -a -G #{group} #{user}" do
    only_if { run_command("id #{user} | sed 's/ context=.*//g' | cut -f 4 -d '=' | grep -- #{group}", error: false).exit_status > 0 }
  end
end
