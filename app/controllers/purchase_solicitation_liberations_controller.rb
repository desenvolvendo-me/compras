class PurchaseSolicitationLiberationsController < CrudController
  actions :all, :only => [:new, :create, :edit]

  before_filter :check_purchase_solicitation, :only => [ :new, :create ]

  def new
    object = build_resource
    object.responsible = current_user.authenticable
    object.date = Date.current
    object.purchase_solicitation = @parent

    super
  end

  def create
    create! { purchase_solicitation_liberations_path(:purchase_solicitation_id => @parent.id) }
  end

  def begin_of_association_chain
    if params[:purchase_solicitation_id]
      @parent = PurchaseSolicitation.find(params[:purchase_solicitation_id])
    end
  end

  protected

  def main_controller_name
    'purchase_solicitations'
  end


  def create_resource(object)
    object.transaction do
      return unless super

      @parent.change_status!(object.service_status)
    end
  end

  def check_purchase_solicitation
    @parent ||= PurchaseSolicitation.find(params[:purchase_solicitation_id] ||
                                          params[:purchase_solicitation_liberation][:purchase_solicitation_id])

    return if @parent.pending?

    raise Exceptions::Unauthorized
  end
end
