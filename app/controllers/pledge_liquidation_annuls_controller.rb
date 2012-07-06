class PledgeLiquidationAnnulsController < CrudController
  defaults :resource_class => ResourceAnnul

  def new
    object = build_resource
    object.employee = current_user.authenticable
    object.date = Date.current
    object.annullable = PledgeLiquidation.find(params[:pledge_liquidation_id])

    super
  end

  def create
    create!{ edit_pledge_liquidation_path(resource.annullable) }
  end

  protected

  def create_resource(object)
    return unless super

    ObjectAnnulment.new(object.annullable).annul!
  end
end
