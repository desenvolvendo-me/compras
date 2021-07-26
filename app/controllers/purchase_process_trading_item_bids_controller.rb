class PurchaseProcessTradingItemBidsController < CrudController
  respond_to :json

  actions :create, :update, :show

  def create
    object = build_resource

    if save_resource(object, resource_params)
      render json: {}
    else
      render json: { errors: object.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    object = resource

    if save_resource(object, resource_params)
      render json: {}
    else
      render json: { errors: object.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def save_resource(object, attributes)
    object.transaction do
      object.localized.assign_attributes(*attributes, as: :trading_user)

      object.status = TradingBidStatusChooser.new(object).choose
      object.number = TradingBidNumberCalculator.calculate(object.item)

      if object.save
        TradingBidCleaner.clean(object.item)
        TradingItemStatusChanger.change(object.item)

        return true
      end
    end

    false
  end

  def item
    @item ||= PurchaseProcessTradingItem.find(params[:item_id])
  end
end
