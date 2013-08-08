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

Capybara.configure do |config|
  config.default_driver = ENV['SELENIUM'] ? :selenium : :webkit
  config.ignore_hidden_elements = true
  config.match = :prefer_exact
end

Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app, :browser => :chrome)
end
