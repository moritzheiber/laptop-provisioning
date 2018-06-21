module Apt
  TWO_HOURS = 60*60*2
  APT_LAST_UPDATED_FILE = '/var/lib/apt/periodic/update-success-stamp'

  def self.cache_outdated(hours_ago=TWO_HOURS)
    # We are dealing with mruby here
    (Time.now - File::Stat.new(APT_LAST_UPDATED_FILE).mtime) > hours_ago
  end
end

define :update_apt_cache do
  if Apt.cache_outdated
    execute 'apt update -qq'
  end
end

