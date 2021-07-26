class Compras::Inputs::HasAndBelongsToManyInput < SimpleForm::Inputs::Base
  disable :label, :wrapper

  def input
    template.render 'crud/has_and_belongs_to_many',
                    :f => @builder,
                    :association => reflection_or_attribute_name,
                    :columns => options[:attributes],
                    :link_by => options[:link_by],
                    :modal_url_method => options[:modal_url_method],
                    :modal_options => options[:modal_options]
  end
end
