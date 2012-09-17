if Rails.env.production? || Rails.env.staging?
  Raven.configure do |config|
    config.dsn = ENV['SENTRY_DSN']
    config.environments = %w[ staging production ]
  end
end
