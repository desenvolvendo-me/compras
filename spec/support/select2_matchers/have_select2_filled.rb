module Capybara
  module RSpecMatchers
    class HaveSelect2Filled < Matcher
      attr_reader :matching_value

      def initialize(*args)
        @locator = args.first
        @matching_value = args.last[:with]
      end

      def matches?(actual)
        actual.has_field? @locator

        field = actual.find_field @locator

        @select2_choice = actual.find("##{field[:id]}").find(:xpath, ".//../following-sibling::input")

        @select2_choice[:value] == @matching_value
      end

      def does_not_match?(actual)
        actual.has_field? @locator

        field = actual.find_field @locator

        @select2_choice = actual.find("##{field[:id]}").find(:xpath, ".//../following-sibling::input")

        @select2_choice[:value] != @matching_value
      end

      def failure_message_for_should
        "expected #{matching_value.inspect} to be equals to #{@select2_choice[:value]}"
      end

      def failure_message_for_should_not
        "expected #{matching_value.inspect} to not be equals to #{@select2_choice[:value]}"
      end

      def description
        "select2 input that has value #{format(content)}"
      end
    end
  end
end
