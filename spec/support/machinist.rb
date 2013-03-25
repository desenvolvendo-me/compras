require 'machinist/caching/active_record'

RSpec.configure do |config|
  config.after(:each, :type => :controller) do
    Machinist::Caching::Shop.instance.reset!
  end

  config.after(:each, :type => :request) do
    Machinist::Caching::Shop.instance.reset!
  end
end
