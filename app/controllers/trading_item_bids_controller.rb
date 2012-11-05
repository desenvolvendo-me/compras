class TradingItemBidsController < CrudController
  def new
    object = build_resource
    object.trading_item = @parent

    super
  end

  def create
    create! { trading_trading_items_path(resource.trading) }
  end

  protected

  def create_resource(object)
    object.status = TradingItemBidStatus::WITH_PROPOSAL

    super
  end

  def begin_of_association_chain
    if params[:trading_item_id]
      @parent = TradingItem.find(params[:trading_item_id])
    end
  end
end
