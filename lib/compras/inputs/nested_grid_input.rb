module Compras
  module Inputs
    class NestedGridInput < SimpleForm::Inputs::Base
      disable :label, :wrapper

      def input
        template.render 'crud/nested_grid',
                        f: @builder,
                        association:       reflection_or_attribute_name,
                        association_class: association_class,
                        template_folder:   template_folder,
                        column_names:      column_names,
                        all_hidden_fields: all_hidden_fields,
                        data_disabled:     options.fetch(:data_disabled, nil)
      end

      private

      def all_hidden_fields
        (column_names + extra_data) - exclude_data
      end

      def association_name
        association_class.model_name
      end

      def template_folder
        association_name.tableize
      end

      def association_class
        object.class.reflect_on_association(reflection_or_attribute_name).klass
      end

      def extra_data
       Set.new(options.fetch(:extra_data, []))
      end

      def column_names
       Set.new(options.fetch(:columns, []))
      end

      def exclude_data
        Set.new(options.fetch(:exclude_data, []))
      end
    end
  end
end
