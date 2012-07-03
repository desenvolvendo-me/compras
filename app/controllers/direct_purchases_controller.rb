class DirectPurchasesController < CrudController
  actions :all, :except => :destroy

  has_scope :authorized, :type => :boolean

  def new
    object = build_resource
    object.employee = current_user.authenticable
    object.date = Date.current
    object.year = Date.current.year

    super
  end

  def update
    return super unless params[:commit] != 'Salvar'

    supply_authorization = SupplyAuthorizationGenerator.new(resource).generate!
    redirect_to supply_authorization
  end

  protected

  def create_resource(object)
    object.direct_purchase = object.next_purchase

    super
  end
end
