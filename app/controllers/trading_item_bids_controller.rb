class TradingItemBidsController < CrudController
  def new
    object = build_resource
    object.trading_item = @parent
    object.round  = TradingItemBidRoundCalculator.new(@parent).calculate
    object.bidder = @parent.first_bidder_available_for_current_round
    object.status = TradingItemBidStatus::WITH_PROPOSAL
    object.amount = 0

    super
  end

  def create
    create! { @parent.decorator.trading_item_bid_or_classification_path }
  end

  protected

  def create_resource(object)
    object.round  = TradingItemBidRoundCalculator.new(@parent).calculate
    object.bidder = @parent.first_bidder_available_for_current_round

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
