class PurchaseProcessTradingItemsController < CrudController
  actions :next_bid, :creditor_list, :undo_last_bid

  respond_to :json

  def update
    object = resource

    if update_resource(object, resource_params)
      redirect_to next_bid_purchase_process_trading_item_path(resource)
    else
      render json: { errors: object.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def next_bid
    @historic   = resource.bids_historic
    @next_bid   = NextBidCalculator.next_bid(resource)
    @lowest_bid = resource.lowest_bid
  end

  def creditor_list
    winner = resource.creditor_winner
    @creditors = resource.creditors_ordered_outer.sort_by{|x| x.creditor_id == winner.try(:id) ? 0 : 1}
  end

  def undo_last_bid
    success = false

    resource.transaction do
      if success = TradingBidRemover.undo(resource)
        TradingItemStatusChanger.change(resource)
      end
    end

    if success
      redirect_to next_bid_purchase_process_trading_item_path(resource)
    else
      render json: { errors: [I18n.t('purchase_process_trading.messages.undo_bid_disabled_message')] }, status: :unprocessable_entity
    end
  end

  def creditor_winner_items
    @winners = PurchaseProcessTradingItem.
      trading_id(params[:trading_id].to_i).
      creditor_winner_items(params[:creditor_id].to_i)
  end

  private

  def update_resource(object, attributes)
    object.localized.assign_attributes(*attributes, as: :trading_user)

    object.save
  end
end
