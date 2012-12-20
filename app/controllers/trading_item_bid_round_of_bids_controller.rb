class TradingItemBidRoundOfBidsController < CrudController
  defaults :resource_class => TradingItemBid, :instance_name => 'trading_item_bid',
           :collection_name => "trading_item_bids"

  actions :new, :create, :destroy

  before_filter :block_when_not_on_stage_of_round_of_bids, :only => [:new, :create]
  before_filter :block_destroy_when_not_last, :only => [:destroy]

  def new
    object = build_resource
    object.trading_item = @parent
    object.stage  = TradingItemBidStage::ROUND_OF_BIDS
    object.round  = TradingItemBidRoundCalculator.new(@parent).calculate(object.stage)
    object.bidder = TradingItemBidBidderChooser.new(@parent, object.stage).choose
    object.status = TradingItemBidStatus::WITH_PROPOSAL
    object.amount = 0

    super
  end

  def create
    create! { @parent.decorator.current_stage_path }
  end

  def update
    update! { @parent.decorator.current_stage_path }
  end

  def destroy
    destroy!(:notice => '') { @parent.decorator.current_stage_path }
  end

  protected

  def create_resource(object)
    object.transaction do
      object.stage  = TradingItemBidStage::ROUND_OF_BIDS
      object.round  = TradingItemBidRoundCalculator.new(@parent).calculate(object.stage)
      object.bidder = TradingItemBidBidderChooser.new(@parent, object.stage).choose

      super
    end
  end

  def begin_of_association_chain
    get_parent
  end

  def get_parent
    if parent_id
      @parent = TradingItem.find(parent_id)
    end
  end

  def parent_id
    params[:trading_item_id] || params[:trading_item_bid][:trading_item_id]
  end

  def block_when_not_on_stage_of_round_of_bids
    get_parent

    return if TradingItemBidStageCalculator.new(@parent).stage_of_round_of_bids?

    render 'public/404', :formats => [:html], :status => 404, :layout => false
  end

  def block_destroy_when_not_last
    get_parent

    bid = TradingItemBid.find(params[:id], :conditions => { :stage => TradingItemBidStage::ROUND_OF_BIDS })

    unless bid == @parent.last_bid
      render 'public/404', :formats => [:html], :status => 404, :layout => false
    end
  end
end
