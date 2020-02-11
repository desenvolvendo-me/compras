class DemandsController < CrudController
  has_scope :term, allow_blank: true

  def new
    object = build_resource
    object.status = DemandStatus::CREATED

    super
  end

  def api_show
    demand = Demand.find(params["demand_id"])

    render :json => demand.to_json(include: {purchase_solicitations: {include: [:department, :user]}})
  end

end
