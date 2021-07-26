module Compras
  module Inputs
    class DecimalInput < SimpleForm::Inputs::Base
      def input
        @builder.text_field(attribute_name, input_html_options)
      end

      protected

      def input_html_classes
        super.unshift('string')
      end

      def input_html_options
        super.tap do |options|
          options[:type]             ||= :string
          options[:maxlength]        ||= maxlength
          options[:data]             ||= {}
          options[:data][:decimal]   ||= true
          options[:data][:precision] ||= precision
        end
      end

      def maxlength
        return unless column_with_precision_and_scale?

        points, missing = (column.precision - column.scale).divmod(3)

        if missing.zero?
          column.precision + points
        else
          column.precision + points + 1
        end
      end

      def precision
        return unless column_with_precision_and_scale?

        column.scale
      end

      private

      def column_with_precision_and_scale?
        column && column.precision && column.scale
      end
    end
  end
end
