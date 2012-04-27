require 'capybara/rspec'

module Capybara
  class Session
    # Ignore current scopes of capybara.
    #
    # Example:
    #
    #   within '.records' do
    #     within '.record' do
    #       ignoring_scopes do
    #         page.should have_content 'Something outside .records .record'
    #       end
    #     end
    #   end
    def ignoring_scopes
      previous_scopes = scopes.slice!(1..-1)

      yield
    ensure
      scopes.push(*previous_scopes)
    end
  end

  module DSL
    def ignoring_scopes(&block)
      page.ignoring_scopes(&block)
    end
  end
end

module Capybara
  module Node
    class Base
      # Finds a link by id or text and clicks it. Also looks at image alt text inside the link.
      #
      # You can confirm a javascript dialog using the confirm option:
      #
      #   click_link 'Destroy', :confirm => true
      def click_link(locator, options = {})
        confirm = options.delete(:confirm)

        if confirm
          driver.execute_script 'this._confirm = this.confirm'
          driver.execute_script 'this.confirm = function () { return true }'
        end

        super(locator)

        if confirm
          driver.execute_script 'this.confirm = this._confirm'
        end
      end

      # Finds a button by id or text and clicks it
      #
      # You can confirm a javascript dialog using the confirmation message:
      #
      #   click_button 'Update', :confirm => 'Save changes?'
      def click_button(locator, options = {})
        confirm = options.delete(:confirm)

        if confirm
          driver.execute_script 'this._confirm = this.confirm'
          driver.execute_script "this.confirm = function (message) { return message == #{confirm.to_json} }"
        end

        super(locator)

        if confirm
          driver.execute_script 'this.confirm = this._confirm'
        end
      end
    end
  end
end

Capybara.configure do |config|
  config.default_driver = ENV['WEBKIT'] ? :webkit : :selenium
  config.ignore_hidden_elements = true
end
