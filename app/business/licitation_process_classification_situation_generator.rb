class LicitationProcessClassificationSituationGenerator
  NORMAL_PERCENTAGE = 10
  PRESENCE_TRADING_PERCENTAGE = 5

  attr_accessor :licitation_process

  delegate :bidders, :all_licitation_process_classifications, :trading?,
           :lots_with_items, :items, :consider_law_of_proposals, :judgment_form,
           :classifications,
           :to => :licitation_process, :allow_nil => true

  def initialize(licitation_process)
    self.licitation_process = licitation_process
  end

  def generate!
    all_licitation_process_classifications.disqualified.each(&:lose!)

    generate_situation_by_bidder

    generate_situation_by_item

    generate_situation_by_lot
  end

  private

  def generate_situation_by_bidder
    return unless judgment_form.lowest_price? && judgment_form.global?

    valid_classifications = all_licitation_process_classifications.reject(&:disqualified?).sort_by(&:classification)

    classificate(valid_classifications)

    change_proposal_situation_by_bidder!
  end

  def generate_situation_by_lot
    return unless judgment_form.lowest_price? && judgment_form.lot?

    lots_with_items.each do |lot|
      valid_classifications = lot.licitation_process_classifications.for_active_bidders.reject(&:disqualified?).sort_by(&:classification)

      classificate(valid_classifications)
    end

    change_proposal_situation_by_lot!
  end

  def generate_situation_by_item
    return unless judgment_form.lowest_price? && judgment_form.item?

    items.each do |item|
      valid_classifications = classifications.for_active_bidders.for_item(item.id).reject(&:disqualified?).sort_by(&:classification)

      classificate(valid_classifications)
    end

    change_proposal_situation_by_item!
  end

  def is_benefited_classification?(classification_a, classification_b)
    classification_a.benefited == classification_b.benefited || !consider_law_of_proposals
  end

  def classificate(valid_classifications)
    classification_a = valid_classifications.first

    if valid_classifications.size == 1
      classification_a.win!
      return
    end

    valid_classifications.reject { |c| c == classification_a }.each do |classification_b|
      classificator = LicitationProcessClassificator.new(
        classification_a,
        classification_b,
        :tolerance => current_percentage,
        :consider_law_of_proposals => consider_law_of_proposals
      )

      if classificator.draw?
        classification_b.equalize!
        classification_a.equalize!
      else
        classificator.winner.win!
        classificator.loser.lose!
      end
    end
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
    trading? ? PRESENCE_TRADING_PERCENTAGE : NORMAL_PERCENTAGE
  end
end
