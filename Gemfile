#!/usr/bin/env ruby
source 'https://rubygems.org'

ruby '2.3.8'

gem 'rails', '4.0.13'
gem 'sidekiq', '4.2.7'
gem 'pg', '0.19.0'

gem 'activerecord-connections', '0.0.3'
gem 'activerecord-postgres-hstore', "~> 0.7.6"

source 'http://foo:BringMeSomeBeerNow@devops.nobesistemas.com.br:9292/' do
  gem 'unico', '7.7.4'
  gem 'unico-assets', '2.0.7'
  gem 'unico-api', '2.2.4'
end

gem 'protected_attributes', '1.0.9'

##Não suporta a rails 4
# gem 'quaestio', '0.1.1'
gem 'active_relatus', '0.2.1'

gem 'devise', '3.1.1'
gem 'cancan', :git => 'git://github.com/ryanb/cancan.git', :branch => '2.0'

gem 'wkhtmltopdf-binary', '0.9.9.1'
gem 'simple_form', '~> 3.3'
gem 'kaminari', '~> 0.15.1'

gem 'squeel'
gem 'carrierwave', '~> 0.11'
gem 'awesome_nested_set', '~> 3.0'

gem 'cnpj_validator', '0.3.1'
gem 'cpf_validator', '0.2.0'
gem 'mask_validator', '0.2.1'
gem 'mail_validator', '0.2.0'
gem 'validates_timeliness', '~> 4.0'
gem 'typecaster', github: 'ricardohsd/typecaster'
gem 'rubyzip', '1.2.0'

gem 'inherited_resources', '~> 1.5.1'
gem 'has_scope', '= 0.6.0'
gem 'responders', '~> 1.0'
gem 'jbuilder'

gem 'i18n_alchemy', '0.2.1'

gem 'foreigner', '~> 1.7'

gem 'enumerate_it', '~> 1.2'
gem 'decore', github: 'matiasleidemer/decore'

# gem 'strong_parameters', '0.2.3' # quebra
gem 'rubocop', '0.80.1'
gem 'paper_trail'

gem 'sass-rails'
gem 'uglifier'

gem 'rake', '< 11.0'

group :production, :training, :staging do
  gem 'dalli', '2.6.4'
  gem 'newrelic_rpm'
  gem 'sentry-raven'
end

group :development, :test do
  gem "factory_girl-preload", :git => 'git://github.com/MarceloCajueiro/factory_girl-preload.git'
  gem "factory_girl_rails", "~> 4.2.1"
  gem 'postgres-copy', '~> 1.0'
  gem 'pry'
  gem 'pry-remote'
  gem 'rspec-rails', '= 2.14.2'
  gem "better_errors"
  gem "binding_of_caller"
  gem 'minitest', '>= 2.12'
  gem 'minitest-reporters', '0.14.24'
  gem 'test-unit'
  gem 'rack-mini-profiler', '0.9.3'
  gem 'syntax', '~> 1.2'
end

group :test do
  gem 'capybara', '2.6.2'
  gem 'capybara-webkit', '~> 1.8.0'
  gem 'machinist', '2.0'
  gem 'machinist-caching', '0.0.1'
  gem 'selenium-webdriver', '~> 3.0.3'
  gem 'shoulda-matchers', '2.2.0'
  gem 'simplecov', '0.17.1', :require => false
  gem 'vcr', '=2.5.0'
  gem 'fakeweb'
  gem 'timecop'
end
