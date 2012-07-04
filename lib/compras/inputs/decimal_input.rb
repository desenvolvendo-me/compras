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
          options[:type]           ||= :string
          options[:maxlength]      ||= maxlength
          options[:data]           ||= {}
          options[:data][:decimal] ||= true
          options[:data][:scale]   ||= scale
        end
      end

      def maxlength
        points, missing = (precision - scale).divmod(3)

        if missing.zero?
          precision + points
        else
          precision + points + 1
        end
      end

      def precision
        precision = options[:precision] || column.try(:precision)

        if precision.blank?
          raise ArgumentError, "Missing :precision for #{attribute_name.inspect} input"
        end

        precision
      end

      def scale
        scale = options[:scale] || column.try(:scale)

        if scale.blank?
          raise ArgumentError, "Missing :scale for #{attribute_name.inspect} input"
        end

        scale
      end
    end
  end
end
