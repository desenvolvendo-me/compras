if defined?(Raven)
  Raven.configure do |config|
    config.dsn = ENV['SENTRY_DSN']
    config.environments = %w[ staging training production ]
  end
end
