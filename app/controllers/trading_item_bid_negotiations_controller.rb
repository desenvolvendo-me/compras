# encoding: utf-8
class TradingItemBidNegotiationsController < CrudController
  defaults :resource_class => TradingItemBid, :instance_name => 'trading_item_bid',
           :collection_name => "trading_item_bids"

  actions :new, :create, :destroy

  before_filter :deny_when_on_another_stage, :only => [:new, :create]
  before_filter :block_destroy_when_not_last, :only => [:destroy]

  def new
    object = build_resource
    object.trading_item = @parent
    object.stage  = TradingItemBidStage::NEGOTIATION
    object.bidder = TradingItemBidBidderChooser.new(@parent, object.stage).choose
    object.status = TradingItemBidStatus::WITH_PROPOSAL
    object.amount = 0

    super
  end

  def create
    create! { @parent.decorator.current_stage_path }
  end

  def destroy
    destroy!(:notice => '') { classification_trading_item_path(@parent) }
  end

  protected

  def main_controller_name
    'tradings'
  end

  def interpolation_options
    { :resource_name => 'Negociação' }
  end

  def create_resource(object)
    object.transaction do
      object.stage  = TradingItemBidStage::NEGOTIATION
      object.bidder = TradingItemBidBidderChooser.new(@parent, object.stage).choose
      object.round  = 0

      super
    end
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

  def deny_when_on_another_stage
    get_parent

    return if TradingItemBidStageCalculator.new(@parent).stage_of_negotiation?

    render 'public/404', :formats => [:html], :status => 404, :layout => false
  end

  def block_destroy_when_not_last
    get_parent

    bid = TradingItemBid.find(params[:id], :conditions => { :stage => TradingItemBidStage::NEGOTIATION })

    if bid != @parent.last_bid || @parent.closed?
      render 'public/404', :formats => [:html], :status => 404, :layout => false
    end
  end
end
