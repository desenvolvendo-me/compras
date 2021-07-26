module Compras
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
          options[:type] ||= :string
          options[:data] ||= {}
          if mask
            options[:data][:mask] ||= mask
          else
            options[:data][:datepicker] ||= true
          end
        end
      end

      def mask
        options[:mask]
      end
    end
  end
end
