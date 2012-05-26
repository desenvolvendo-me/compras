class LicitationProcessProposalsClassificatorByLot
  attr_accessor :lot, :bidders, :type_of_calculation

  MAXIMUM_PRICE_INDEX = 1.1 # this * best value == maximum_price for classificaition
  MINIMUM_OF_BEST_PROPOSALS = 3

  def initialize(lot, type_of_calculation)
    self.lot = lot
    self.bidders = lot.licitation_process_bidders.uniq
    self.type_of_calculation = type_of_calculation
  end

  def winner_proposals(type_of_calculation_enumerator = LicitationProcessTypeOfCalculation)
    case type_of_calculation
    when type_of_calculation_enumerator::LOWEST_PRICE_BY_LOT
      best_proposal
    when type_of_calculation_enumerator::SORT_PARTICIPANTS_BY_LOT
      classified_proposals
    when type_of_calculation_enumerator::HIGHEST_BIDDER_BY_LOT
      highest_proposal
    end
  end

  private

  def classified_proposals
    if pre_classified_proposals.size >= MINIMUM_OF_BEST_PROPOSALS
      pre_classified_proposals
    else
      minimum_best_proposals
    end
  end

  def pre_classified_proposals
    sorted_proposals.select do |bidder|\
      bidder.proposal_total_value_by_lot(lot.id) <= maximum_price_for_classification
    end
  end

  def minimum_best_proposals
    sorted_proposals.first(MINIMUM_OF_BEST_PROPOSALS)
  end

  def maximum_price_for_classification
    best_proposal.proposal_total_value_by_lot(lot.id) * 1.1
  end

  def best_proposal
    sorted_proposals.first
  end

  def highest_proposal
    sorted_proposals.last
  end

  def sorted_proposals
    all_bidders_sorted = bidders.sort_by do |bidder|
      bidder.proposal_total_value_by_lot(lot.id)
    end

    all_bidders_sorted.reject {|bidder| bidder.proposal_total_value_by_lot(lot.id).zero? }
  end
end
