define :add_user_to_group, group: nil do
  groups = run_command("groups #{params[:name]}").stdout.split(' ').drop(2)
  groups = groups.push(params[:group]).flatten.uniq unless params[:group].nil?

  execute "usermod -G #{groups.join(',')} #{params[:name]}"
end
