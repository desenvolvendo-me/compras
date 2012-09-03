class LicitationProcessClassificationSituationGenerator
  NORMAL_PERCENTAGE = 10
  PRESENCE_TRADING_PERCENTAGE = 5

  attr_accessor :licitation_process

  delegate :licitation_process_bidders, :all_licitation_process_classifications,
           :administrative_process_presence_trading?, :lots_with_items, :items,
           :consider_law_of_proposals,
           :to => :licitation_process, :allow_nil => true

  def initialize(licitation_process)
    self.licitation_process = licitation_process
  end

  def generate!
    generate_situation!

    change_proposal_situation_by_bidder!

    change_proposal_situation_by_lot!

    change_proposal_situation_by_item!
  end

  protected

  def generate_situation!
    all_licitation_process_classifications.each { |c| c.lost! if c.disqualified? }

    classifications = all_licitation_process_classifications.reject(&:disqualified?).sort_by(&:classification)
    first = classifications.first

    if classifications.size == 1
      first.won!
      first.save!
    end

    classifications.reject { |c| c == first }.each do |classification|
      if first.benefited && classification.benefited || !first.benefited && !classification.benefited || !consider_law_of_proposals
        first = classificate_by_same_company_size(first, classification)
      else
        first = classificate_by_different_company_size(first, classification)
      end
    end
  end

  def classificate_by_same_company_size(first, classification)
    if classification.total_value == first.total_value
      first.equalized!
      classification.equalized!
    elsif classification.total_value < first.total_value
      first.lost!
      classification.won!
    else
      first.won!
      classification.lost!
    end

    first.save!
    classification.save!

    first
  end

  # should equalize if benefited company has until 10% difference of big company proposal
  def classificate_by_different_company_size(first, classification)
    first_benefited_value = first.benefited_value(current_percentage)
    classification_benefited_value = classification.benefited_value(current_percentage)

    if (first.benefited && first.total_value > classification.total_value && first_benefited_value <= classification.total_value) ||
      (classification.benefited && classification.total_value > first.total_value && classification_benefited_value <= first.total_value) ||
      (first_benefited_value == classification_benefited_value)

      first.equalized!
      classification.equalized!

    elsif first_benefited_value < classification_benefited_value
      first.won!
      classification.lost!
    else
      classification.won!
      first.lost!
    end

    classification.save!
    first.save!

    first
  end

  def change_proposal_situation_by_bidder!
    licitation_process_bidders.each do |bidder|
      unless bidder.licitation_process_classifications_by_classifiable.empty?
        classification = bidder.licitation_process_classifications_by_classifiable.first

        change_proposals_situation!(bidder.proposals, classification)
      end
    end
  end

  def change_proposal_situation_by_lot!
    lots_with_items.each do |lot|
      unless lot.licitation_process_classifications.empty?
        classification = lot.licitation_process_classifications.first

        proposals = classification.proposals.map { |p| p if p.licitation_process_lot == lot }

        change_proposals_situation!(proposals, classification)
      end
    end
  end

  def change_proposal_situation_by_item!
    items.each do |item|
      unless item.licitation_process_classifications.empty?
        classification = item.licitation_process_classifications.first

        proposals = classification.proposals.map { |p| p if p.administrative_process_budget_allocation_item == item }

        change_proposals_situation!(proposals, classification)
      end
    end
  end

  def change_proposals_situation!(proposals, classification)
    proposals.each do |proposal|
      proposal.classification = classification.classification
      proposal.situation = classification.situation
      proposal.save!
    end
  end

  def current_percentage
    administrative_process_presence_trading? ? PRESENCE_TRADING_PERCENTAGE : NORMAL_PERCENTAGE
  end
end
