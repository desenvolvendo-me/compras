class NextBidCalculator
  def initialize(item)
    @item = item
  end

  def self.next_bid(*args)
    new(*args).next_bid
  end

  def next_bid
    return if next_creditor_has_lowest_bid?

    next_bid_without_proposal
  end

  private

  attr_reader :item

  def item_bids
    item.bids(true)
  end

  def next_creditor_has_lowest_bid?
    lowest_bid_creditor == next_bid_without_proposal_creditor
  end

  def bids_without_proposal
    item_bids.without_proposal.reorder(:id)
  end

  def next_bid_without_proposal
    bids_without_proposal.first
  end

  def next_bid_without_proposal_creditor
    next_bid_without_proposal.try(:accreditation_creditor)
  end

  def lowest_bid
    item.lowest_bid
  end

  def lowest_proposal_creditor
    item.creditors_ordered.selected_creditors.last
  end

  def lowest_bid_creditor
    lowest_bid.try(:accreditation_creditor) || lowest_proposal_creditor
  end
end
