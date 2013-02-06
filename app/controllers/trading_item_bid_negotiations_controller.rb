# encoding: utf-8
class TradingItemBidNegotiationsController < CrudController
  defaults :resource_class => TradingItemBid, :instance_name => 'trading_item_bid',
           :collection_name => "bids"

  actions :new, :create, :destroy

  before_filter :deny_when_on_another_stage, :block_not_allowed_bidder, :only => [:new, :create]

  def new
    object = build_resource
    object.trading_item = parent
    object.stage  = TradingItemBidStage::NEGOTIATION
    object.bidder = bidder
    object.status = TradingItemBidStatus::WITH_PROPOSAL
    object.amount = 0

    super
  end

  def create
    create! { classification_trading_item_path(parent) }
  end

  def destroy
    destroy!(:notice => '') { new_trading_item_bid_negotiation_path(:trading_item_id => parent.id, :bidder_id => bidder.id) }
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
      object.bidder = bidder
      object.round  = 0

      super
    end
  end

  def begin_of_association_chain
    parent
  end

  def parent
    @parent ||= if parent_id
      TradingItem.find(parent_id)
    else
      TradingItemBid.find(params[:id]).trading_item
    end
  end

  def parent_id
    return unless params[:trading_item_id] || params[:trading_item_bid]

    params[:trading_item_id] || params[:trading_item_bid][:trading_item_id]
  end

  def bidder_id
    return unless params[:bidder_id] || params[:trading_item_bid]

    params[:bidder_id] || params[:trading_item_bid][:bidder_id]
  end

  def bidder
    @bidder ||= if bidder_id
      Bidder.find(bidder_id)
    else
      resource.bidder
    end
  end

  def deny_when_on_another_stage
    unless TradingItemBidStageCalculator.new(parent).stage_of_negotiation?
      raise ActiveRecord::RecordNotFound
    end
  end

  def block_not_allowed_bidder
    return if valid_bidder == bidder

    raise ActiveRecord::RecordNotFound
  end

  def valid_bidder
    TradingItemBidderNegotiationSelector.new(parent).remaining_bidders.first
  end
end
