module Compras
  module Inputs
    class AutoCompleteInput < SimpleForm::Inputs::Base
      def input
        auto_complete_field + hidden_field
      end

      protected

      def auto_complete_field
        if fake?
          name = "#{sanitized_object_name}[#{label_target}]"
          template.text_field_tag(name, nil, input_html_options)
        else
          @builder.text_field(label_target, input_html_options)
        end
      end

      def hidden_field
        if fake?
          template.hidden_field(object_name, hidden_field_name_option) if hidden_field_name_option
        else
          @builder.hidden_field(hidden_field_name_option) if hidden_field_name_option
        end
      end

      def label_target
        reflection ? reflection.name : attribute_name
      end

      def input_html_classes
        super.unshift("string")
      end

      def hidden_input_html_options
        {
          :class => options['data-hidden-field-class'] || ''
        }
      end

      def input_html_options
        super.tap do |options|
          options['data-auto-complete']                   = true
          options['data-source']                        ||= source_path
          options['data-hidden-field-class']            ||= ''
          options['data-hidden-field-id']               ||= hidden_field_id if hidden_field_id
          options['data-hidden-field-value-attribute']  ||= hidden_field_value_attribute
          options['data-max-results']                   ||= max_results
          options['data-min-length']                    ||= min_length
          options['data-clear-input']                   ||= clear_input
        end
      end

      def fake?
        options.fetch(:fake, false)
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

      def hidden_field_name_option
        options.fetch(:hidden_field, "#{attribute_name}_id")
      end

      def hidden_field_name
        options.fetch(:hidden_field, attribute_name)
      end

      def hidden_field_id
        option = hidden_field_name_option.to_sym

        [sanitized_object_name, index, option].compact.join('_') if option
      end

      def hidden_field_value_attribute
        'id'
      end

      def max_results
        options.fetch(:max_results, 10)
      end

      def min_length
        options.fetch(:min_length, 1)
      end

      def clear_input
        options[:clear_input] || false
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
