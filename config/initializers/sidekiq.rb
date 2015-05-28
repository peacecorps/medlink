# Currently capped at 10 Redis connections
#   and have 2 web workers
Sidekiq.configure_client do |config|
  config.redis = { size: 1 }
end
Sidekiq.configure_server do |config|
  config.redis = { size: 8 }
end
