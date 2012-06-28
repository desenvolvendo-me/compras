module Compras
  module Inputs
    class StringInput < SimpleForm::Inputs::StringInput
      private

      # SimpleForm do not add maxlength if html5 is disabled which not make any sense
      def add_maxlength!
        input_html_options[:maxlength] ||= maximum_length_from_validation || limit
      end
    end
  end
end
