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

  def main_controller_name
    'tradings'
  end

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

    unless TradingItemBidStageCalculator.new(@parent).stage_of_round_of_bids?
      raise ActiveRecord::RecordNotFound
    end
  end

  def block_destroy_when_not_last
    get_parent

    bid = TradingItemBid.find(params[:id], :conditions => { :stage => TradingItemBidStage::ROUND_OF_BIDS })

    if bid != @parent.last_bid || @parent.closed?
      raise ActiveRecord::RecordNotFound
    end
  end
end
