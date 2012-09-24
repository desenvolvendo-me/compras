class LicitationProcessClassificationSituationGenerator
  NORMAL_PERCENTAGE = 10
  PRESENCE_TRADING_PERCENTAGE = 5

  attr_accessor :licitation_process

  delegate :bidders, :all_licitation_process_classifications,
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

  def set_lost_to_all_classifications_disqualified
    all_licitation_process_classifications.disqualified.each do |c|
      c.lose!
    end
  end

  def is_benefited_classification?(classification_a, classification_b)
    classification_a.benefited == classification_b.benefited || !consider_law_of_proposals
  end

  def generate_situation!
    set_lost_to_all_classifications_disqualified

    classifications = all_licitation_process_classifications.reject(&:disqualified?).
                                                             sort_by(&:classification)
    classification_a = classifications.first

    if classifications.size == 1
      classification_a.win!
      return
    end

    classifications.reject { |c| c == classification_a }.each do |classification_b|
      if is_benefited_classification?(classification_a, classification_b)
        classification_a = classificate_by_same_company_size(classification_a, classification_b)
      else
        classification_a = classificate_by_different_company_size(classification_a, classification_b)
      end
    end
  end

  def classificate_by_same_company_size(classification_a, classification_b)
    if classification_b.total_value == classification_a.total_value
      classification_a.equalize!
      classification_b.equalize!
    elsif classification_b.total_value < classification_a.total_value
      classification_a.lose!
      classification_b.win!
    else
      classification_a.win!
      classification_b.lose!
    end

    classification_a
  end

  # should equalize if benefited company has until 10% difference of big company proposal
  def classificate_by_different_company_size(classification_a, classification_b)
    benefited_value_a = classification_a.benefited_value(current_percentage)
    benefited_value_b = classification_b.benefited_value(current_percentage)

    if ((classification_a.benefited && classification_a.total_value > classification_b.total_value && benefited_value_a <= classification_b.total_value) ||
        (classification_b.benefited && classification_b.total_value > classification_a.total_value && benefited_value_b <= classification_a.total_value) ||
        (benefited_value_a == benefited_value_b)) && classification_a.will_submit_new_proposal_when_draw

      classification_a.equalize!
      classification_b.equalize!
    elsif benefited_value_a < benefited_value_b
      classification_a.win!
      classification_b.lose!
    else
      classification_b.win!
      classification_a.lose!
    end

    classification_a
  end

  def change_proposal_situation_by_bidder!
    bidders.each do |bidder|
      bidder.licitation_process_classifications_by_classifiable.each do |classification|
        change_proposals_situation!(bidder.proposals, classification)
      end
    end
  end

  def change_proposal_situation_by_lot!
    lots_with_items.each do |lot|
      lot.licitation_process_classifications.each do |classification|
        proposals = classification.proposals.select { |p| p.licitation_process_lot == lot }

        change_proposals_situation!(proposals, classification)
      end
    end
  end

  def change_proposal_situation_by_item!
    items.each do |item|
      item.licitation_process_classifications.each do |classification|
        proposals = classification.proposals.select { |p| p.administrative_process_budget_allocation_item == item }

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
