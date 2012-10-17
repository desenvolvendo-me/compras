ActionMailer::Base.smtp_settings = {
  :port           => ENV['MAILGUN_SMTP_PORT'],
  :address        => ENV['MAILGUN_SMTP_SERVER'],
  :user_name      => ENV['MAILGUN_SMTP_LOGIN'],
  :password       => ENV['MAILGUN_SMTP_PASSWORD'],
  :domain         => ENV['MAILGUN_SMTP_DOMAIN'],
  :authentication => :plain,
}

if Rails.env.production? || Rails.env.staging?
  ActionMailer::Base.delivery_method = :smtp
end
