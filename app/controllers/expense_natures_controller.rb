class ExpenseNaturesController < CrudController
  has_scope :expense_nature_not_eq

  def create
    object = build_resource
    ExpenseNatureCodeGenerator.new(object).generate!

    super
  end

  protected

  def update_resource(object, attributes)
    object.localized.assign_attributes(*attributes)

    ExpenseNatureCodeGenerator.new(object).generate!

    super
  end
end
