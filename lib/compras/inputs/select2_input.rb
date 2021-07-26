module Compras
  module Inputs
    class Select2Input < SimpleForm::Inputs::Base
      def input
        select2_field + hidden_field
      end

      protected

      def select2_field
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
          options["data-select_2"] = true
          options["data-source"] ||= source_path
          options["data-new-resource-path"] ||= new_resource_path
          options["data-new-resource-text"] ||= new_resource_text
          options["data-hidden-field-id"] ||= hidden_field_id if hidden_field_id
          options["data-hidden-field-value-attribute"] ||= hidden_field_value_attribute
          options["data-max-results"] ||= max_results
          options["data-min-length"] ||= min_length
          options["data-clear-input"] ||= clear_input
          options["data-preload"] ||= preload
          options["data-scope"] ||= scope
        end
      end

      def preload
        options[:preload] || false
      end

      def clear_input
        options[:clear_input] || false
      end

      def source_path
        s_path = options[:source_path] || template.send(route)
        s_path.include?("?") ? "#{s_path}&#{params_page}" : "#{s_path}?#{params_page}"
      end

      def params_page
        "#{(max_results == "all" ? "page" : "per")}=#{max_results}"
      end

      def new_resource_path
        path = route(new: true) ? template.send(route(new: true)) : ""
        options[:new_resource_path] || path
      end

      def new_resource_text
        options[:new_resource_text] || template.t("new", resource: translated_model_name)
      end

      def route(new: false)
        route = new ? "new_#{model_name}_path" : "#{model_name.pluralize}_path"
        has_route = template.respond_to?(route)

        if new && !has_route
          route = nil
        elsif !new && !has_route
          raise "Missing route for #{model_name.gsub(/_/, " ")} modal (#{route})"
        end

        route
      end

      def model_name
        model_name_class.to_s.underscore
      end

      def translated_model_name
        model_name_class.human
      end

      def model_name_class
        if attribute_name.to_s.classify == "MainCnae"
          Cnae.model_name
        else
          model = reflection ? reflection.klass : attribute_name.to_s.classify.constantize
          model.model_name
        end
      end

      def hidden_field_name
        options.fetch(:hidden_field, attribute_hidden)
      end

      def attribute_hidden
        attribute_name.to_s.include?("_id") ? attribute_name : (attribute_name.to_s + "_id").to_sym
      end

      def hidden_field_id
        [sanitized_object_name, index, hidden_field_name].compact.join("_") if hidden_field_name
      end

      def hidden_field_value_attribute
        "id"
      end

      def max_results
        options.fetch(:max_results, 15)
      end

      def scope
        options[:scope] || "term"
      end

      def min_length
        options.fetch(:min_length, 1)
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
