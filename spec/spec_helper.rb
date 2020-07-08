# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'

require_relative './support/simplecov.rb'

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.include Warden::Test::Helpers, :type => :feature
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  # config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # If true, take screenshots when an exceptions happens in request spec
  # Follow the available configurations with default values
  #
  # config.screenshot_folder = 'tmp/errors'
  # config.screenshot_full = true
  # config.clear_screenshots_before_run =  true
  # config.screenshot_on_errors = ENV['SCREENSHOT']

  # mark test like intermittent
  config.filter_run_excluding :intermittent => true

  config.treat_symbols_as_metadata_keys_with_true_values = true

  unless Date.current.monday?
    config.filter_run_excluding only_monday: true
  end

  config.include FactoryGirl::Preload::Helpers

  config.before(:suite) do
    FactoryGirl::Preload.clean
    FactoryGirl::Preload.run

    Dir[Rails.root.join("spec/blueprints/**/*.rb")].each {|f| require f}

    # Forces all threads to share the same connection. This works on
    # Capybara because it starts the web server in a thread.
    ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection
    Customer.create!(:name => "Test", :domain => "test.host", :database => Customer.connection_config)
  end

  config.before(:each, type: :feature) do
    Timecop.travel(Time.local(2013, 9, 05, 10, 00, 00))
  end

  config.before(:each, :reset_ids) do
    FactoryGirl::Preload.clean
    FactoryGirl::Preload.run
  end

  config.before(:each) do
    FactoryGirl::Preload.reload_factories
  end
end
