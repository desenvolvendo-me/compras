class PurchaseSolicitationLiberationsController < CrudController
  actions :all, :only => [:new, :create, :edit]

  before_filter :check_purchase_solicitation, :only => [ :new, :create ]

  def new
    object = build_resource
    object.responsible = current_user.authenticable
    object.date = Date.current
    object.purchase_solicitation = @purchase_solicitation

    super
  end

  def create
    create!(:notice => t('compras.messages.purchase_solicitation_liberated_successful')) { edit_purchase_solicitation_path(@purchase_solicitation) }
  end

  protected

  def create_resource(object)
    object.transaction do
      return unless super

      return false unless @purchase_solicitation.liberation.present?

      @purchase_solicitation.liberate!
    end
  end

  def check_purchase_solicitation
    purchase_solicitation_id = params[:purchase_solicitation_id] || params[:purchase_solicitation_liberation][:purchase_solicitation_id]

    @purchase_solicitation = PurchaseSolicitation.pending.find(purchase_solicitation_id)
  end
end
