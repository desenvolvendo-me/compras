class BidderProposalBuilder
  attr_accessor :bidder

  def initialize(bidder)
    self.bidder = bidder
  end

  def build!
    bidder.items.each  do |item|
      build_proposal(item) unless item.bidder_proposal?(bidder)
    end
  end

  private

  def build_proposal(item)
    bidder.proposals.build({ :purchase_process_item => item })
  end
end
