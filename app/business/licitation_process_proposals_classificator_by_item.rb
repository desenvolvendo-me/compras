class LicitationProcessProposalsClassificatorByItem
  attr_accessor :item, :licitation_proposals, :type_of_calculation

  MAXIMUM_PRICE_INDEX = 1.1 # this * best value == maximum_price for classificaition
  MINIMUM_OF_BEST_PROPOSALS = 3

  def initialize(item, type_of_calculation)
    self.item = item
    self.licitation_proposals = item.licitation_process_bidder_proposals
    self.type_of_calculation = type_of_calculation
  end

  def winner_proposals
    case type_of_calculation
    when LicitationProcessTypeOfCalculation::LOWEST_TOTAL_PRICE_BY_ITEM
      best_proposal
    when LicitationProcessTypeOfCalculation::SORT_PARTICIPANTS_BY_ITEM
      classified_proposals
    when LicitationProcessTypeOfCalculation::HIGHEST_BIDDER_BY_ITEM
      higher_proposal
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
    sorted_proposals.select{|proposal| proposal.total_price <= maximum_price_for_classification}
  end

  def minimum_best_proposals
    sorted_proposals.first(MINIMUM_OF_BEST_PROPOSALS)
  end

  def best_proposal
    sorted_proposals.first
  end

  def higher_proposal
    sorted_proposals.last
  end

  def maximum_price_for_classification
    best_proposal.total_price * MAXIMUM_PRICE_INDEX
  end

  def sorted_proposals
    self.licitation_proposals.sort_by(&:total_price).reject { |proposal| proposal.total_price.zero? }
  end
end
