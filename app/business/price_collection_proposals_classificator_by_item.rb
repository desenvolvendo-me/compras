class PriceCollectionProposalsClassificatorByItem
  attr_accessor :item, :proposals

  def initialize(item)
    self.item = item
    self.proposals = item.price_collection_proposal_items
  end

  def winner_proposal
    sorted_proposals.first
  end

  private

  def sorted_proposals
    self.proposals.sort_by(&:total_price).reject { |proposal| proposal.total_price.zero? }
  end
end
