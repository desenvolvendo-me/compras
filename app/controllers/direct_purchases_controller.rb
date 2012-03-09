class DirectPurchasesController < CrudController
  actions :all, :except => [:update, :destroy]

  has_scope :authorized, :type => :boolean

  def new
    object = build_resource
    object.employee = current_user.employee
    object.status = DirectPurchaseStatus::UNAUTHORIZED
    object.date = Date.current

    super
  end

  def create
    object = build_resource
    object.status = DirectPurchaseStatus::UNAUTHORIZED

    super
  end
end
