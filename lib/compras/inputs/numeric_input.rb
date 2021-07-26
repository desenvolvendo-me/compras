module Compras
  module Inputs
    class NumericInput < SimpleForm::Inputs::NumericInput
      protected

      include Compras::Inputs::MaskedInput

      private

      def input_html_options
        super.tap do |options|
          options[:data]              ||= {}
          options[:data][:numeric]    ||= true
        end
      end
    end
  end
end
