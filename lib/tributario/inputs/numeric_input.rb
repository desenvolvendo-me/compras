module Tributario
  module Inputs
    class NumericInput < SimpleForm::Inputs::NumericInput
      protected

      include Tributario::Inputs::MaskedInput

      private

      def add_size!
        input_html_options[:size] ||= nil unless has_mask?
      end

      def input_html_options
        super.tap do |options|
          options[:data]              ||= {}
          options[:data][:numeric]    ||= true
        end
      end
    end
  end
end
