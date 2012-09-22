class PurchaseSolicitationsController < CrudController
  has_scope :by_material_id
  has_scope :by_pending_or_ids, :allow_blank => true, :type => :array
  has_scope :except_ids, :type => :array
  has_scope :can_be_grouped

  def new
    object = build_resource
    object.service_status = PurchaseSolicitationServiceStatus::PENDING
    object.request_date = Date.current
    object.accounting_year = Date.current.year
    object.responsible = current_user.authenticable

    super
  end

  def create
    object = build_resource
    object.service_status = PurchaseSolicitationServiceStatus::PENDING

    super
  end

  def update
    raise Exceptions::Unauthorized unless resource.editable?

    super
  end
end
