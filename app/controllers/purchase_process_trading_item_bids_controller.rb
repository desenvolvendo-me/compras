class PurchaseProcessTradingItemBidsController < CrudController
  respond_to :json

  actions :update, :show

  def update
    object = resource

    if update_resource(object, resource_params)
      render json: {}
    else
      render json: { errors: object.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def update_resource(object, attributes)
    object.transaction do
      object.localized.assign_attributes(*attributes, as: :trading_user)

      object.status = TradingBidStatusChooser.new(object).choose
      object.number = TradingBidNumberCalculator.calculate(object.item)

      if object.save
        TradingBidCreator.create!(object.item)
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
