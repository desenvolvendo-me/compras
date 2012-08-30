class CreditorsController < CrudController
  def new
    object = build_resource
    object.creditable_type = 'SpecialEntry'

    super
  end
end
