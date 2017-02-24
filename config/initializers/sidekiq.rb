def params_redis
  tmp_config = {
      password: ENV['REDIS_PASSWORD']
  }
  unless ENV['REDIS_SENTINEL'].nil? && ENV['REDIS_MASTER_NAME'].nil?
    list_sentinels = []
    host_port_sentinel = ENV['REDIS_SENTINEL'].split(',')
    host_port_sentinel.each do |host_sentinel|
      sentinel = host_sentinel.split(':')
      list_sentinels << {host: sentinel[0], port: sentinel[1].to_i}
    end
    tmp_config.merge!({
                          url: "redis://#{ENV['REDIS_MASTER_NAME']}",
                          sentinels: list_sentinels
                      })
  end
  unless ENV['REDIS_URL'].nil?
    tmp_config.merge!({url: ENV['REDIS_URL']})
  end
  return tmp_config
end

Sidekiq.configure_client do |config|
  config.redis = params_redis
end

Sidekiq.configure_server do |config|
  config.redis = params_redis

  schedule_file = "config/schedule.yml"
  if File.exists?(schedule_file) && Sidekiq.server?
    Sidekiq::Cron::Job.load_from_hash! YAML.load_file(schedule_file)
  end
end

