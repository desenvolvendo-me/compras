class PurchaseProcessTradingsController < CrudController
  actions :bids, :new

  def new
    trading = TradingCreator.create!(purchase_process)

    if trading
      redirect_to bids_purchase_process_trading_path(trading)
    else
      redirect_to edit_licitation_process_path(purchase_process)
    end
  end

  def bids
    resource.transaction do
      TradingBidCreator.create_items_bids!(resource)
    end

    @item      = resource.items.first
    @historic  = @item.bids_historic
    @creditors = @item.creditors_ordered_outer
    @next_bid  = NextBidCalculator.next_bid(@item)
  end

  private

  def purchase_process
    @purchase_process ||= LicitationProcess.find(params[:purchase_process_id])
  end
end
