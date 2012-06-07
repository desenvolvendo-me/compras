class PledgesController < CrudController
  actions :all, :except => [:update, :destroy]

  has_scope :global_or_estimated, :type => :boolean

  def new
    object = build_resource
    object.emission_date = Date.current

    super
  end

  def create
    object = build_resource
    GenerateNumberPledgeParcels.new(object.pledge_parcels).generate!

    super
  end

  protected

  def create_resource(object)
    if super
      PledgeBudgetAllocationSubtractor.new(object).subtract_budget_allocation_amount!
    end
  end
end
