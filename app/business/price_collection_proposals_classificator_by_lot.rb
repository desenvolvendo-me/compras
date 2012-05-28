class PriceCollectionProposalsClassificatorByLot
  attr_accessor :lot, :proposals

  def initialize(lot)
    self.lot = lot
    self.proposals = lot.price_collection_proposals
  end

  def winner_proposal
    sorted_proposals.first
  end

  private

  def sorted_proposals
    all_proposals_sorted = proposals.sort_by do |proposal|
      proposal.item_total_value_by_lot(lot)
    end

    all_proposals_sorted.reject {|proposal| proposal.item_total_value_by_lot(lot).zero? }
  end
end
