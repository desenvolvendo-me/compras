class PledgesController < CrudController
  actions :all, :except => [:update, :destroy]

  def new
    object = build_resource
    object.emission_date = Date.current

    super
  end

  def edit
    object = resource
    object.licitation = object.joined_licitation
    object.process = object.joined_process

    super
  end

  protected

  def create_resource(object)
    if super
      PledgeBudgetAllocationSubtractor.new(object).subtract_budget_allocation_amount!
    end
  end
end
