class DisabledBiddersController < CrudController
  def new
    Bidder.find(params[:bidder_id]).disable!
    redirect_to classification_trading_item_path(trading_item_id)
  end

  private

  def trading_item_id
    params[:trading_item_id]
  end
end
