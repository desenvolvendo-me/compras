class TradingItemBidsController < CrudController
  def new
    object = build_resource
    object.trading_item = @parent
    object.round  = TradingItemBidRoundCalculator.new(@parent).calculate
    object.bidder = TradingItemBidBidderChooser.new(@parent).choose

    super
  end

  def create
    create! { trading_items_path(:trading_id => @parent.trading.id) }
  end

  protected

  def create_resource(object)
    object.status = TradingItemBidStatus::WITH_PROPOSAL
    object.round  = TradingItemBidRoundCalculator.new(@parent).calculate
    object.bidder = TradingItemBidBidderChooser.new(@parent).choose

    super
  end

  def begin_of_association_chain
    @parent = get_parent
  end

  def get_parent
    if parent_id
      @parent = TradingItem.find(parent_id)
    end
  end

  def parent_id
    params[:trading_item_id] || params[:trading_item_bid][:trading_item_id]
  end
end
