# encoding: utf-8
class PurchaseProcessTradingItemsController < CrudController
  actions :next_bid, :creditor_list, :undo_last_bid

  respond_to :json

  def next_bid
    @historic   = resource.bids_historic
    @next_bid   = NextBidCalculator.next_bid(resource)
    @lowest_bid = resource.lowest_bid
  end

  def creditor_list
    @creditors = resource.creditors_ordered
  end

  def undo_last_bid
    if TradingBidRemover.undo(resource)
      redirect_to next_bid_purchase_process_trading_item_path(resource)
    else
      render json: { errors: [I18n.t('purchase_process_trading.messages.undo_bid_disabled_message')] }, status: :unprocessable_entity
    end
  end
end
