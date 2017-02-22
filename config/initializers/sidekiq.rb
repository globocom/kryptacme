Sidekiq.configure_client do |config|
  config.redis = { url: ENV['REDIS_URL'], password: ENV['REDIS_PASSWORD'] }
end

Sidekiq.configure_server do |config|
  config.redis = { url: ENV['REDIS_URL'], password: ENV['REDIS_PASSWORD'] }

  schedule_file = "config/schedule.yml"

  if File.exists?(schedule_file) && Sidekiq.server?
    Sidekiq::Cron::Job.load_from_hash! YAML.load_file(schedule_file)
  end
end  