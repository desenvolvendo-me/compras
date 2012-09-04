class LicitationProcessClassificationGenerator

  attr_accessor :licitation_process, :classification_repository

  delegate :type_of_calculation, :licitation_process_bidders, :lots_with_items,
           :all_licitation_process_classifications,
           :to => :licitation_process, :allow_nil => true

  def initialize(licitation_process, classification_repository = LicitationProcessClassification)
    self.licitation_process = licitation_process
    self.classification_repository = classification_repository
  end

  def generate!
    licitation_process.destroy_all_licitation_process_classifications

    licitation_process_bidders.each do |bidder|
      send(type_of_calculation, bidder) if type_of_calculation
    end

    check_if_winner_has_zero!
  end

  protected

  def check_if_winner_has_zero!
    all_licitation_process_classifications.group_by(&:classifiable_id).each do |classifiable_id, classifications|
      classifications = classifications.sort_by(&:classification)

      if classifications.first.disqualified?
        classification = classifications.reject(&:disqualified?).first
        classification.update_column(:classification, 1) if classification
      end
    end
  end

  def lowest_total_price_by_item(bidder)
    bidder.proposals.each do |proposal|
      classification_repository.create!(
        :unit_value => proposal.unit_price,
        :total_value => proposal.unit_price * proposal.quantity,
        :classification => bidder.classification_by_item(proposal),
        :licitation_process_bidder => bidder,
        :classifiable => proposal.administrative_process_budget_allocation_item
      )
    end
  end

  def lowest_global_price(bidder)
    classification_repository.create!(
      :total_value => bidder.total_price,
      :classification => bidder.global_classification,
      :licitation_process_bidder => bidder,
      :classifiable => bidder
    )
  end

  def lowest_price_by_lot(bidder)
    lots_with_items.each do |lot|
      classification_repository.create!(
        :total_value => bidder.proposal_total_value_by_lot(lot),
        :classification => bidder.classification_by_lot(lot),
        :licitation_process_bidder => bidder,
        :classifiable => lot
      )
    end
  end
end
