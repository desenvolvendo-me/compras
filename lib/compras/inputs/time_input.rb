module Compras
  module Inputs
    class TimeInput < SimpleForm::Inputs::Base
      def input
        @builder.text_field(attribute_name, input_html_options)
      end

      protected

      def input_html_classes
        super.unshift("string")
      end

      def input_html_options
        super.tap do |options|
          options[:type]        ||= :string
          options[:value]       ||= formated_value
          options[:data]        ||= {}
          options[:data][:mask] ||= '99:99'
        end
      end

      def formated_value
        value = @builder.object.send(attribute_name)
        I18n.l(value, :format => :hour) if value
      end
    end
  end
end
