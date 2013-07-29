if defined?(Raven)
  Raven.configure do |config|
    config.dsn = ENV['SENTRY_DSN'] if ENV['SENTRY_DSN'].present?
    config.environments = %w[ staging training production ]
  end
end
