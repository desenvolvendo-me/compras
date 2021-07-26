module Compras
  module Inputs
    # Código veio daqui: https://github.com/plataformatec/simple_form/wiki/Create-a-fake-input-that-does-NOT-read-attributes
    class FakeInput < SimpleForm::Inputs::StringInput
      # This method only create a basic input without reading any value from object
      def input
        input_html_classes.unshift("string")
        name = "#{sanitized_object_name}[#{attribute_name}]"
        template.text_field_tag(name, nil, input_html_options)
      end

      protected

      include Compras::Inputs::MaskedInput

      def sanitized_object_name
        object_name.gsub(/\]\[|[^-a-zA-Z0-9:.]/, "_").sub(/_$/, "")
      end
    end
  end
end
