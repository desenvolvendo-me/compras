class CreditorsController < CrudController
  def new
    object = build_resource
    object.creditable_type = CreditableType::SPECIAL_ENTRY

    super
  end
end
