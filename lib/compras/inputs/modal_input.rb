module Compras
  module Inputs
    class ModalInput < SimpleForm::Inputs::Base
      def input
        modal_field + hidden_field + modal_info_html
      end

      protected

      include Compras::ModalInfo

      def modal_field
        if fake?
          name = "#{sanitized_object_name}[#{label_target}]"
          template.text_field_tag(name, nil, input_html_options)
        else
          @builder.text_field(label_target, input_html_options)
        end
      end

      def hidden_field
        if fake?
          name = "#{sanitized_object_name}[#{hidden_field_name_option}]"
          template.hidden_field_tag(name, nil)
        else
          @builder.hidden_field(hidden_field_name) if hidden_field_name
        end
      end

      def label_target
        reflection ? reflection.name : attribute_name
      end

      def input_html_classes
        super.unshift("string")
      end

      def input_html_options
        super.tap do |options|
          options['data-modal-url']       ||= modal_url
          options['data-hidden-field-id'] ||= hidden_field_id if hidden_field_id
        end
      end

      def fake?
        options.fetch(:fake, false)
      end

      def has_placeholder?
        placeholder_present?
      end

      def modal_url
        options[:modal_url] || find_modal_url
      end

      def find_modal_url
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

      def hidden_field_name_option
        options.fetch(:hidden_field, "#{attribute_name}_id")
      end

      def hidden_field_name
        options.fetch(:hidden_field, attribute_name)
      end

      def hidden_field_id
        option = fake? ? hidden_field_name_option : hidden_field_name

        [sanitized_object_name, index, option].compact.join('_') if option
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
