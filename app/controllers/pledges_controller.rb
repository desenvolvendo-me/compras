class PledgesController < CrudController
  actions :all, :except => [:update, :destroy]

  def new
    object = build_resource
    object.emission_date = Date.current

    super
  end

  protected

  def create_resource(object)
    if super
      PledgeBudgetAllocationSubtractor.new(object).subtract_budget_allocation_amount!
    end
  end
end
