define :rustup do
  download 'https://static.rust-lang.org/rustup/dist/x86_64-unknown-linux-gnu/rustup-init' do
    destination '/tmp/rustup-init'
    user node[:login_user]
    mode '0755'
    not_if "test -f #{node[:user][node[:login_user]][:directory]}/.cargo/bin/rustup"
  end

  execute '/tmp/rustup-init -y --no-modify-path' do
    user node[:login_user]
    not_if "test -f #{node[:user][node[:login_user]][:directory]}/.cargo/bin/rustup"
  end

  file '/tmp/rustup-init' do
    action :delete
  end
end
