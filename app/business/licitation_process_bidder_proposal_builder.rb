class LicitationProcessBidderProposalBuilder
  attr_accessor :bidder

  def initialize(bidder)
    self.bidder = bidder
  end

  def build!
    bidder.items.each  do |item|
      build_proposal(item) unless has_bidder_proposal?(item)
    end
  end

  private

  def has_bidder_proposal?(item) 
    item.licitation_process_bidder_proposals.where { |p| p.licitation_process_bidder_id.eq(bidder.id) }.any?
  end

  def build_proposal(item)
    bidder.proposals.build({ :administrative_process_budget_allocation_item => item })
  end
end
