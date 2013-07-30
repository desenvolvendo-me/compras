#!/usr/bin/env ruby
source 'http://rubygems.org'
source 'https://SEqawpNNEx65yrzYS9p8@gem.fury.io/me/'

ruby "2.0.0"

gem 'rails', '3.2.14'
gem 'unicorn'
gem 'sidekiq'

gem 'pg'

gem 'activerecord-connections', '0.0.3'
gem 'activerecord-postgres-hstore', '0.6.0'

gem 'unico', '6.2.2'
gem 'unico-assets'
gem 'unico-api'
gem 'devise', '2.2.4'
gem 'cancan', :git => 'git://github.com/ryanb/cancan.git', :branch => '2.0'
gem 'quaestio', '0.1.1'
gem 'active_relatus', '0.1.1'

gem 'pdfkit', :git => 'git://github.com/comogo/pdfkit.git'
gem 'wkhtmltopdf-binary', '0.9.9.1'
gem 'simple_form', '2.1.0'
gem 'kaminari', '0.14.1'

gem 'squeel'
gem 'carrierwave', '0.8.0'
gem 'awesome_nested_set', '2.1.3'

gem 'mail_validator', '0.2.0'
gem 'cnpj_validator', '0.3.1'
gem 'cpf_validator', '0.2.0'
gem 'mask_validator', '0.2.1'
gem 'validates_timeliness', '3.0.14'
gem 'typecaster', '0.0.2', :git => 'git://github.com/ricardohsd/typecaster'
gem 'rubyzip', '0.9.9'

gem 'inherited_resources', '1.4.0'
gem 'has_scope', '0.5.1'
gem 'responders', '0.9.3'
gem 'jbuilder'

gem 'foreigner'
gem 'i18n_alchemy', :git => 'git://github.com/carlosantoniodasilva/i18n_alchemy.git'

gem 'enumerate_it', '1.0.3'
gem 'decore', :git => 'git://github.com/sobrinho/decore.git'

gem 'strong_parameters', '0.2.1'

group :assets do
  gem 'uglifier'
end

group :production, :training, :staging do
  gem 'dalli', '2.6.4'
end

gem 'sentry-raven', '0.4.8'

group :development, :test do
  gem "factory_girl-preload", :git => 'git://github.com/MarceloCajueiro/factory_girl-preload.git'
  gem "factory_girl_rails", "~> 4.2.1"
  gem 'postgres-copy', '~> 0.5.8'
  gem 'pry'
  gem 'pry-remote'
  gem 'rspec-rails', '2.12.0'
end

group :test do
  gem 'capybara', '2.1.0'
  gem 'machinist', '2.0'
  gem 'machinist-caching', '0.0.1'
  gem 'poltergeist', '1.3.0'
  gem 'selenium-webdriver', '~> 2.33.0'
  gem 'shoulda-matchers', '2.2.0'
  gem 'simplecov', :require => false
end
