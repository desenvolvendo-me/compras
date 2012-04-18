module Tributario
  module Inputs
    class StringInput < SimpleForm::Inputs::StringInput
      protected

      include Tributario::Inputs::MaskedInput

      private

      # SimpleForm do not use maxium length from validation
      def add_size!
        input_html_options[:size] ||= [maximum_length_from_validation, limit, SimpleForm.default_input_size].compact.min unless has_mask?
      end

      # SimpleForm do not add maxlength if html5 is disabled which not make any sense
      def add_maxlength!
        input_html_options[:maxlength] ||= maximum_length_from_validation || limit
      end
    end
  end
end
