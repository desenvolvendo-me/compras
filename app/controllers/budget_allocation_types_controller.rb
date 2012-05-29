class BudgetAllocationTypesController < CrudController
  def new
    object = build_resource
    object.status = Status::ACTIVE

    super
  end

  def create
    object = build_resource
    object.status = Status::ACTIVE
    object.source = Source::MANUAL

    super
  end
end
