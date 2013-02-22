class MaterialsClassesController < CrudController
  has_scope :term
  has_scope :without_children, :type => :boolean

  before_filter :block_when_not_editable, :only => [:update, :destroy]

  def new
    object = build_resource
    object.mask = '99.99.99.999.999'

    super
  end

  private

  def block_when_not_editable
    return if resource.editable?

    raise Exceptions::Unauthorized
  end
end
