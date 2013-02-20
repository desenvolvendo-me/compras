module Compras
  module Inputs
    class AutoCompleteInput < SimpleForm::Inputs::Base
      def input
        auto_complete_field + hidden_field
      end

      protected

      def auto_complete_field
        @builder.text_field(label_target, input_html_options)
      end

      def hidden_field
        @builder.hidden_field(hidden_field_name) if hidden_field_name
      end

      def label_target
        reflection ? reflection.name : attribute_name
      end

      def input_html_classes
        super.unshift("string")
      end

      def input_html_options
        super.tap do |options|
          options['data-auto-complete']     = true
          options['data-source']          ||= source_path
          options['data-hidden-field-id'] ||= hidden_field_id if hidden_field_id
          options['data-hidden-field-value-attribute'] ||= hidden_field_value_attribute
        end
      end

      def source_path
        options[:source_path] || find_source_url
      end

      def find_source_url
        route = "#{model_name.pluralize}_path"

        unless template.respond_to?(route)
          raise "Missing route for #{model_name.gsub(/_/, " ")} modal (#{route})"
        end

        template.send(route)
      end

      def model_name
        name = reflection ? reflection.klass.model_name : attribute_name
        name.to_s.underscore
      end

      def hidden_field_name
        options.fetch(:hidden_field, attribute_name)
      end

      def hidden_field_id
        [sanitized_object_name, index, hidden_field_name].compact.join('_') if hidden_field_name
      end

      def hidden_field_value_attribute
        'id'
      end

      def index
        @builder.options[:index]
      end

      def sanitized_object_name
        object_name.gsub(/\]\[|[^-a-zA-Z0-9:.]/, "_").sub(/_$/, "")
      end
    end
  end
end
