class NextBidCalculator
  def initialize(item)
    @item = item
  end

  def next_bid
    return if next_creditor_has_lowest_bid?

    next_bid_without_proposal
  end

  private

  def next_creditor_has_lowest_bid?
    lowest_trading_bid_creditor == next_bid_without_proposal_creditor
  end

  def bids_without_proposal
    @item.trading_bids.without_proposal.reorder(:id)
  end

  def next_bid_without_proposal
    bids_without_proposal.first
  end

  def next_bid_without_proposal_creditor
    next_bid_without_proposal.try(:accreditation_creditor)
  end

  def lowest_trading_bid
    @item.lowest_trading_bid
  end

  def lowest_proposal_creditor
    @item.trading_creditors_ordered.selected_creditors.last
  end

  def lowest_trading_bid_creditor
    lowest_trading_bid.try(:accreditation_creditor) || lowest_proposal_creditor
  end
end
