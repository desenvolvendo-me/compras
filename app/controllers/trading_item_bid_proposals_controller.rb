class TradingItemBidProposalsController < CrudController
  defaults :resource_class => TradingItemBid, :instance_name => 'trading_item_bid',
           :collection_name => "trading_item_bids"

  actions :new, :create, :edit, :update

  before_filter :deny_when_on_another_stage, :only => [:new, :create]

  def new
    object = build_resource
    object.trading_item = @parent
    object.stage  = TradingItemBidStage::PROPOSALS
    object.status = TradingItemBidStatus::WITH_PROPOSAL
    object.bidder = TradingItemBidBidderChooser.new(@parent, :current_stage => object.stage).choose
    object.amount = 0

    super
  end

  def create
    create! { @parent.decorator.current_stage_path }
  end

  def update
    update! { proposal_report_trading_item_path(@parent) }
  end

  protected

  def main_controller_name
    'tradings'
  end

  def interpolation_options
    { :resource_name => 'Proposta' }
  end

  def create_resource(object)
    object.transaction do
      object.stage  = TradingItemBidStage::PROPOSALS
      object.round  = 0
      object.bidder = TradingItemBidBidderChooser.new(@parent, :current_stage => object.stage).choose

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

  def deny_when_on_another_stage
    get_parent

    unless TradingItemBidStageCalculator.new(@parent).stage_of_proposals?
      raise ActiveRecord::RecordNotFound
    end
  end
end
