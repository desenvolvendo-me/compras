module Matchers
  extend RSpec::Matchers::DSL

  matcher :have_disabled_field do |field|
    match do |page|
      page.find_field(field)[:disabled].should eq 'true'
    end

    failure_message_for_should do |page|
      "expected #{page.text.inspect} to have disabled field #{field.inspect}"
    end

    failure_message_for_should_not do |page|
      "expected #{page.text.inspect} not to have disabled field #{field.inspect}"
    end
  end

  matcher :have_disabled_button do |field|
    match do |page|
      page.find_button(field)[:disabled].should eq 'true'
    end

    failure_message_for_should do |page|
      "expected #{page.text.inspect} to have disabled button #{field.inspect}"
    end

    failure_message_for_should_not do |page|
      "expected #{page.text.inspect} not to have disabled button #{field.inspect}"
    end
  end

  matcher :have_notice do |notice|
    match do |page|
      page.should have_css(".notice", :text => notice)
    end

    failure_message_for_should do |page|
      "expected #{page.text.inspect} to have notice #{notice.inspect}"
    end

    failure_message_for_should_not do |page|
      "expected #{page.text.inspect} not to have notice #{notice.inspect}"
    end
  end

  matcher :have_alert do |alert|
    match do |page|
      page.should have_css(".alert", :text => alert)
    end

    failure_message_for_should do |page|
      "expected #{page.text.inspect} to have alert #{alert.inspect}"
    end

    failure_message_for_should_not do |page|
      "expected #{page.text.inspect} not to have alert #{alert.inspect}"
    end
  end
end

RSpec.configure do |config|
  config.include Matchers, :type => :request
end
