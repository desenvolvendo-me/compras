class PurchaseSolicitationAnnulsController < CrudController
  defaults :resource_class => ResourceAnnul

  def new
    object = build_resource
    object.employee = current_user.authenticable
    object.date = Date.current
    object.annullable = PurchaseSolicitation.find(params[:purchase_solicitation_id])

    super
  end

  def create
    create!{ edit_purchase_solicitation_path(resource.annullable) }
  end

  def update
    raise Exceptions::Unauthorized
  end

  protected

  def create_resource(object)
    return unless super

    PurchaseSolicitationAnnulment.new(object.annullable).annul!
  end
end
