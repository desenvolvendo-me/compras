#!/usr/bin/env ruby
source 'http://rubygems.org'

gem 'rails', '3.2.5'

platform :jruby do
  gem 'jruby-openssl', '0.7.4'
  gem 'activerecord-jdbcpostgresql-adapter', '1.2.0'
end

platform :ruby do
  gem 'pg', '0.12.2'
  gem 'unicorn', '4.1.1', :require => false
end

gem 'activerecord-connections', '0.0.3'

gem 'unico', :git => 'git@github.com:nohupbrasil/unico.git'
gem 'devise', '2.0.4'
gem 'cancan', :git => 'git://github.com/ryanb/cancan.git', :branch => '2.0'

gem 'simple_form', '2.0.1'
gem 'will_paginate', '3.0.3'

gem 'squeel', '1.0.0'
gem 'carrierwave', '0.6.2'
gem 'awesome_nested_set', '2.1.3'

gem 'mail_validator', '0.2.0'
gem 'cnpj_validator', '0.3.1'
gem 'cpf_validator', '0.2.0'
gem 'mask_validator', '0.2.1'
gem 'validates_timeliness', '3.0.11'

gem 'inherited_resources', '1.3.0'
gem 'has_scope', '0.5.1'
gem 'responders', '0.6.4'
gem 'jbuilder', '0.4.0'

gem 'foreigner', '1.1.4'
gem 'i18n_alchemy', :git => 'git://github.com/carlosantoniodasilva/i18n_alchemy.git'

gem 'enumerate_it', '0.7.14'

group :assets do
  gem 'uglifier', '1.2.1'
end

group :production, :staging do
  gem 'airbrake', '3.0.9'
  gem 'newrelic_rpm', '3.3.1'
end

group :development, :test do
  gem 'rspec-rails', '2.10.1'
end

group :development do
  gem 'rails-footnotes', '>= 3.7.5.rc4'
end

group :test do
  gem 'shoulda-matchers', '1.1.0'
  gem 'machinist', '2.0'
  gem 'machinist-caching', '0.0.1'
  gem 'capybara', '1.1.2'
  gem 'poltergeist', :git => 'https://github.com/jonleighton/poltergeist.git'
end
