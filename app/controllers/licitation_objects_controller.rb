class LicitationObjectsController < CrudController

  def new
    object = build_resource
    initializes_values(object)

    super
  end

  def create
    object = build_resource
    initializes_values(object)

    super
  end

  private

  def initializes_values(object)
    object.purchase_licitation_exemption  = 0.00
    object.purchase_invitation_letter     = 0.00
    object.purchase_taking_price          = 0.00
    object.purchase_public_concurrency    = 0.00
    object.build_licitation_exemption     = 0.00
    object.build_invitation_letter        = 0.00
    object.build_taking_price             = 0.00
    object.build_public_concurrency       = 0.00
    object.special_auction                = 0.00
    object.special_unenforceability       = 0.00
    object.special_contest                = 0.00
  end
end