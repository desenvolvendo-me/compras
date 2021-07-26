Sidekiq.configure_server do |config|
  config.redis = { :namespace => "compras-#{Rails.env}", :size => 10 }
end

Sidekiq.configure_client do |config|
  config.redis = { :namespace => "compras-#{Rails.env}", :size => 5 }
end
