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
                        column_names:      options.fetch(:columns, []),
                        extra_data:        options.fetch(:extra_data, []),
                        exclude_data:      options.fetch(:exclude_data, []),
                        data_disabled:     options.fetch(:data_disabled, nil)
      end

      private

      def association_name
        association_class.model_name
      end

      def template_folder
        association_name.tableize
      end

      def association_class
        object.class.reflect_on_association(reflection_or_attribute_name).klass
      end
    end
  end
end
