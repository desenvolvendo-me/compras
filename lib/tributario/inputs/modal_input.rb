module Tributario
  module Inputs
    class ModalInput < SimpleForm::Inputs::Base
      def input
        modal_field + hidden_field
      end

      protected

      def modal_field
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
          options[:size]                  ||= SimpleForm.default_input_size
          options['data-modal-url']       ||= modal_url
          options['data-hidden-field-id'] ||= hidden_field_id if hidden_field_id
        end
      end

      def has_placeholder?
        placeholder_present?
      end

      def modal_url
        route = "modal_#{model_name.pluralize}_path"

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

      def template
        @builder.template
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
