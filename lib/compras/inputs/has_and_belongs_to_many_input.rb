class Compras::Inputs::HasAndBelongsToManyInput < SimpleForm::Inputs::Base
  def input
    template.render 'crud/has_and_belongs_to_many', :f => @builder, :association => association_name
  end

  def label
    ''
  end

  private

  def association_name
    reflection ? reflection.name : attribute_name
  end
end
