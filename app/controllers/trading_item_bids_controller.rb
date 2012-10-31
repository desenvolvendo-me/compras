class TradingItemBidsController < CrudController
  def new
    object = build_resource
    object.trading_item = TradingItem.find(params[:trading_item_id])

    super
  end

  def create
    create! { trading_trading_items_path(resource.trading) }
  end

  def begin_of_association_chain
    if params[:trading_item_id]
      @parent = TradingItem.find(params[:trading_item_id])
    end
  end
end
