module Tributario
  module Inputs
    class NumericInput < SimpleForm::Inputs::NumericInput
      protected

      include Tributario::Inputs::MaskedInput

      private

      def add_size!
        input_html_options[:size] ||= nil unless has_mask?
      end
    end
  end
end
