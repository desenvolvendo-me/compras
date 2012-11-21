module Matchers
  extend RSpec::Matchers::DSL

  #
  # This matcher is to assert that an element is disabled to click
  #   * When the mouse is over the element should show a tip with the reason;
  #   * When click in the element, the current page can't be changed.
  #
  # Example:
  #
  #   expect(page).to have_disabled_element "Criar Receita",
  #     :reason => "Não pode ser criado uma nova receita."
  #
  matcher :have_disabled_element do |value, options|
    match do |page|
      element = page.first(:xpath, %(//*[text()="#{value}"] | //*[@value="#{value}"]))
      element.trigger(:mouseover)

      expect(page).to have_content options[:reason]

      url_before_click = current_url

      element.click

      expect(current_url).to eq(url_before_click)
    end

    failure_message_for_should do |page|
      "expected #{page.text.inspect} to have disabled element #{value.inspect}"
    end

    failure_message_for_should_not do |page|
      "expected #{page.text.inspect} not to have disabled element #{value.inspect}"
    end
  end

  matcher :have_disabled_field do |field|
    match do |page|
      page.find_field(field)[:disabled].should eq 'disabled'
    end

    failure_message_for_should do |page|
      "expected #{page.text.inspect} to have disabled field #{field.inspect}"
    end

    failure_message_for_should_not do |page|
      "expected #{page.text.inspect} not to have disabled field #{field.inspect}"
    end
  end

  matcher :have_readonly_field do |field|
    match do |page|
      page.find_field(field)[:readonly].should eq 'readonly'
    end

    failure_message_for_should do |page|
      "expected #{page.text.inspect} to have readonly field #{field.inspect}"
    end

    failure_message_for_should_not do |page|
      "expected #{page.text.inspect} not to have readonly field #{field.inspect}"
    end
  end

  matcher :have_disabled_button do |field|
    match do |page|
      page.find_button(field)[:disabled].should eq 'disabled'
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

  matcher :be_on_tab do |tab|
    match do |page|
      page.find('.ui-tabs .ui-tabs-active').should have_link tab
    end

    failure_message_for_should do |page|
      "expected #{page.text.inspect} to be on tab #{tab.inspect}"
    end

    failure_message_for_should_not do |page|
      "expected #{page.text.inspect} to not be on tab #{tab.inspect}"
    end
  end
end

RSpec.configure do |config|
  config.include Matchers, :type => :request
end
