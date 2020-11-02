$redis = Redis.new

url = ENV["SIDEKIQ_REDIS_URL"]

if url
  Sidekiq.configure_server do |config|
    config.redis = { url: url, size: 12, network_timeout: 5 }
  end

  Sidekiq.configure_client do |config|
    config.redis = { url: url, size: 1, network_timeout: 5 }
  end
  $redis = Redis.new(:url => url)
end

Sidekiq::Extensions.enable_delay!
