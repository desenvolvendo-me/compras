class TradingItemBidBidderChooser
  def initialize(trading_item, options = {})
    @trading_item = trading_item
    @trading_item_bidders = options.fetch(:trading_item_bidders) { TradingItemBidders.new(trading_item, trading_item.bidders.enabled) }
    @current_stage = options[:current_stage]
  end

  def choose
    if current_round == 0
      bidders_available_for_current_round.first
    else
      bidders_available_ordered_for_current_round_by_value.last
    end
  end

  private

  attr_reader :trading_item, :trading_item_bidders, :current_stage

  def bidders_available_ordered_for_current_round_by_value
    bidders_available_for_current_round.sort do |a,b|
      a.lower_trading_item_bid_amount(trading_item) <=> b.lower_trading_item_bid_amount(trading_item)
    end
  end

  def bidders_available_for_current_round
    if current_stage == TradingItemBidStage::NEGOTIATION
      trading_item.bidders_for_negotiation_by_lowest_proposal
    else
      bidders_available - trading_item_bidders.at_bid_round(current_round)
    end
  end

  def current_round(round_calculator = TradingItemBidRoundCalculator)
    if current_stage == TradingItemBidStage::NEGOTIATION
      0
    else
      round_calculator.new(trading_item).calculate
    end
  end

  def bidders_available
    if current_round == 1
      trading_item_bidders.selected_for_trading_item
    elsif current_round > 1
      trading_item_bidders.with_proposal_for_round(current_round.pred)
    else
      trading_item.bidders.enabled
    end
  end

  def value_limit_to_participate_in_bids
    trading_item.value_limit_to_participate_in_bids
  end
end
