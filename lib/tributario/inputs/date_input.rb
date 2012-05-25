module Tributario
  module Inputs
    class DateInput < SimpleForm::Inputs::Base
      def input
        @builder.text_field(attribute_name, input_html_options)
      end

      protected

      def input_html_classes
        super.unshift("string")
      end

      def input_html_options
        super.tap do |options|
          options[:type]              ||= :string
          options[:data]              ||= {}
          options[:data][:datepicker] ||= true
        end
      end
    end
  end
end
