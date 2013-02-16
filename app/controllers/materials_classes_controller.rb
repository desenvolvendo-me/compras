class MaterialsClassesController < CrudController
  has_scope :term

  before_filter :block_when_not_editable, :only => [:update, :destroy]

  private

  def block_when_not_editable
    return if resource.editable?

    raise Exceptions::Unauthorized
  end
end
