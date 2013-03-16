#!/usr/bin/env ruby
source 'http://rubygems.org'
source 'https://SEqawpNNEx65yrzYS9p8@gem.fury.io/me/'

ruby "1.9.3"

gem 'rails', '3.2.12'
gem 'puma', '1.6.3', :require => false

gem 'pg', '0.14.1'

gem 'activerecord-connections', '0.0.3'
gem 'activerecord-postgres-hstore', '0.6.0'

gem 'unico', '4.2.0'
gem 'unico-assets', '1.3.0'
gem 'devise', '2.2.3'
gem 'cancan', :git => 'git://github.com/ryanb/cancan.git', :branch => '2.0'

gem 'pdfkit', :git => 'git://github.com/comogo/pdfkit.git'
gem 'wkhtmltopdf-binary', '0.9.9.1'
gem 'simple_form', '2.1.0'
gem 'kaminari', '0.14.1'

gem 'squeel', '1.0.17'
gem 'carrierwave', '0.8.0'
gem 'awesome_nested_set', '2.1.3'

gem 'mail_validator', '0.2.0'
gem 'cnpj_validator', '0.3.1'
gem 'cpf_validator', '0.2.0'
gem 'mask_validator', '0.2.1'
gem 'validates_timeliness', '3.0.14'

gem 'inherited_resources', '1.3.1'
gem 'has_scope', '0.5.1'
gem 'responders', '0.9.3'
gem 'jbuilder', '0.4.0'

gem 'foreigner', '1.2.1'
gem 'i18n_alchemy', :git => 'git://github.com/carlosantoniodasilva/i18n_alchemy.git'

gem 'enumerate_it', '1.0.3'
gem 'decore', :git => 'git://github.com/sobrinho/decore.git'

group :assets do
  gem 'uglifier', '1.2.1'
end

group :production, :training, :staging do
  gem 'sentry-raven', '0.4.0'
  gem 'dalli', '2.6.2'
end

group :development, :test do
  gem "factory_girl-preload", "~> 2.0.2"
  gem "factory_girl_rails", "~> 4.2.1"
  gem 'pry', '0.9.10'
  gem 'rspec-rails', '2.12.0'
end

group :test do
  gem 'capybara', '1.1.2'
  gem 'machinist', '2.0'
  gem 'machinist-caching', '0.0.1'
  gem 'poltergeist', '0.7.0'
  gem 'shoulda-matchers', '1.4.2'
  gem 'simplecov', :require => false
end
