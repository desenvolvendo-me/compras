# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.

# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
raise "You must set a secret token in ENV['SECRET_TOKEN']" if ENV['SECRET_TOKEN'].blank? && Rails.production_way?

if Rails.production_way?
  Compras::Application.config.secret_token = ENV['SECRET_TOKEN']
else
  Compras::Application.config.secret_token = 'c31bfa8977942d83d4a3a2104a5e7b0b4b160c1c77c86dcf88dfdfed75145c4aced365b38c458807ea37675ca4c923c9e53b713636bcf835be7b9a9a7b3a8030'
end
