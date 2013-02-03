module Compras
  module Inputs
    class NestedFormInput < SimpleForm::Inputs::Base
      disable :label, :wrapper

      def input
        template.render 'crud/nested_form',
                        :f => @builder,
                        :association => reflection_or_attribute_name,
                        :include_add_button => options.fetch(:include_add_button, true),
                        :inline => options.fetch(:inline, false),
                        :append => options.fetch(:append, false)
      end
    end
  end
end
