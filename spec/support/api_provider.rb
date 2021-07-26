RSpec::Matchers.define :provide do |expected|
  match do |actual|
    actual.class.provided_data.include?(expected) && actual.respond_to?(expected)
  end

  failure_message_for_should do |actual|
    "expected that #{actual.class} to provide and respond_to #{expected}"
  end

  failure_message_for_should_not do |actual|
    "expected that #{actual.class} to not provide or respond_to #{expected}"
  end

  description do
    "ensure that #{expected} is provided by th api"
  end
end
