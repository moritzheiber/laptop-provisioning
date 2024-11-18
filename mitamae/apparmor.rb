apparmor_content = <<~APPARMOR
/sys/class/ r,
/sys/bus/ r,
/sys/class/hidraw/ r,
/run/udev/data/c24{1,7,9}:* r,
/sys/devices/**/hidraw/hidraw*/uevent r,
/dev/hidraw* rw,

@{PROC}/[0-9]*/oom_score_adj rw,
@{PROC}/[0-9]*/cgroup r,
APPARMOR

firefox_apparmor_file = '/etc/apparmor.d/local/usr.bin.firefox'

file firefox_apparmor_file do
  action :edit
  block do |content|
    content << apparmor_content
  end
  not_if "grep -qFx '#{apparmor_content.lines.first.strip}' #{firefox_apparmor_file}"
  notifies :restart, 'service[apparmor]', :immediately
end

service 'apparmor' do
  action :nothing
end
