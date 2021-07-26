module Compras
  module Inputs
    class FakeSelectInput < SimpleForm::Inputs::CollectionSelectInput
      def input(wrapper_options = nil)
        label_method, value_method = detect_collection_methods

        merged_input_options = merge_wrapper_options(input_html_options, wrapper_options).merge(input_options.slice(:multiple, :include_blank, :disabled, :prompt))

        template.select_tag(
            "#{sanitized_object_name}[#{attribute_name}]",
            template.options_from_collection_for_select(collection, value_method, label_method, selected: input_options[:selected], disabled: input_options[:disabled]),
            merged_input_options
        )
      end

      def merge_wrapper_options(options, wrapper_options)
        if wrapper_options
          options.merge(wrapper_options) do |_, oldval, newval|
            if Array === oldval
              oldval + Array(newval)
            end
          end
        else
          options
        end
      end

      protected

      def sanitized_object_name
        object_name.gsub(/\]\[|[^-a-zA-Z0-9:.]/, "_").sub(/_$/, "")
      end
    end
  end
end