class PledgesController < CrudController
  actions :all, :except => [:update, :destroy]

  def new
    object = build_resource
    object.emission_date = Date.current

    super
  end

  def create
    object = build_resource

    if object.valid?
      PledgeBudgetAllocationSubtractor.new(object).subtract_budget_allocation_amount!
    end

    super
  end

  def edit
    object = resource
    object.licitation = object.joined_licitation
    object.process = object.joined_process

    super
  end
end
