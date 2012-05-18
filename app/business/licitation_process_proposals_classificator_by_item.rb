class LicitationProcessProposalsClassificatorByItem
  attr_accessor :item, :licitation_proposals

  def initialize(item)
    self.item = item
    self.licitation_proposals = item.licitation_process_bidder_proposals
  end

  def winner_proposal
    self.licitation_proposals.min_by(&:total_price)
  end
end
