class DirectPurchaseLiberationsController < CrudController
  def new
    object = build_resource
    object.employee = current_user.authenticable
    object.direct_purchase = DirectPurchase.find(params[:direct_purchase_id])

    super
  end

  def create
    create!{ direct_purchase_liberations_path(:direct_purchase_id => resource.direct_purchase_id) }
  end

  def update
    raise Exceptions::Unauthorized
  end

  protected

  def create_resource(object)
    object.transaction do
      return unless super

      DirectPurchaseStatusUpdater.new(object).update!
    end
  end

  def begin_of_association_chain
    if params[:direct_purchase_id]
      @parent ||= DirectPurchase.find(params[:direct_purchase_id])
    else
      super
    end
  end
end
