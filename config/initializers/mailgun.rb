if Rails.production_way?
  ActionMailer::Base.smtp_settings = {
    :port           => ENV['MAILGUN_SMTP_PORT'],
    :address        => ENV['MAILGUN_SMTP_SERVER'],
    :user_name      => ENV['MAILGUN_SMTP_LOGIN'],
    :password       => ENV['MAILGUN_SMTP_PASSWORD'],
    :domain         => ENV['MAILGUN_SMTP_DOMAIN'],
    :authentication => :plain,
  }

  ActionMailer::Base.delivery_method = :smtp

  ActionMailer::Base.default :from => 'noreply@nobesistemas.com.br'
end
