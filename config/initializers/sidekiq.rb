Sidekiq.configure_server do |config|
  config.redis = { :namespace => 'compras', :size => 10 }
end

Sidekiq.configure_client do |config|
  config.redis = { :namespace => 'compras', :size => 5 }
end
