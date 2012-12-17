class TradingItemBidsController < CrudController
  def new
    object = build_resource
    object.trading_item = @parent
    object.stage  = TradingItemBidStage.current_stage(@parent)
    object.round  = TradingItemBidRoundCalculator.new(@parent).calculate(object.stage)
    object.bidder = TradingItemBidBidderChooser.new(@parent, object.stage).choose
    object.status = TradingItemBidStatus::WITH_PROPOSAL
    object.amount = 0

    super
  end

  def create
    create! { @parent.decorator.current_stage_path }
  end

  protected

  def create_resource(object)
    object.stage  = TradingItemBidStage.current_stage(@parent)
    object.round  = TradingItemBidRoundCalculator.new(@parent).calculate(object.stage)
    object.bidder = TradingItemBidBidderChooser.new(@parent, object.stage).choose

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
