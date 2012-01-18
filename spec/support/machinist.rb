require 'machinist/caching/active_record'

Dir[Rails.root.join("spec/blueprints/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.after(:each, :type => :controller) do
    Machinist::Caching::Shop.instance.reset!
  end

  config.after(:each, :type => :request) do
    Machinist::Caching::Shop.instance.reset!
  end
end
