class TradingItemWinner
  def initialize(item, options = {})
    @item = item
    @next_bid_calculator = options.fetch(:next_bid_calculator) { NextBidCalculator }
  end

  def creditor
    return unless trading_for_item_finished?(item)

    lowest_creditor
  end

  def amount
    return unless trading_for_item_finished?(item)

    lowest_amount
  end

  private

  attr_reader :item, :next_bid_calculator

  def trading_for_item_finished?(item)
    next_bid_calculator.next_bid(item).nil?
  end

  def lowest_creditor
    item.negotiation.try(:creditor) || item.lowest_bid.try(:creditor) || item.lowest_proposal.try(:creditor)
  end

  def lowest_amount
    item.negotiation.try(:amount) || item.lowest_bid.try(:amount) || item.lowest_proposal.try(:unit_price)
  end
end
