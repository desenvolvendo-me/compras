class ExpenseNaturesController < CrudController
  def create
    object = build_resource
    ExpenseNatureFullCodeGenerator.new(object).generate!

    super
  end

  protected

  def update_resource(object, attributes)
    object.localized.assign_attributes(*attributes)

    ExpenseNatureFullCodeGenerator.new(object).generate!

    super
  end
end
