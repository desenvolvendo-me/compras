class LicitationProcessClassificationGenerator
  NORMAL_PERCENTAGE = 10
  PRESENCE_TRADING_PERCENTAGE = 5

  attr_accessor :licitation_process, :licitation_process_classification_repository

  delegate :type_of_calculation, :licitation_process_bidders, :lots_with_items, :items, :to => :licitation_process, :allow_nil => true
  delegate :disqualify_by_documentation_problem, :disqualify_by_maximum_value, :consider_law_of_proposals, :to => :licitation_process, :allow_nil => true
  delegate :administrative_process_presence_trading?, :all_licitation_process_classifications, :to => :licitation_process, :allow_nil => true

  def initialize(licitation_process, licitation_process_classification_repository = LicitationProcessClassification)
    self.licitation_process = licitation_process
    self.licitation_process_classification_repository = licitation_process_classification_repository
  end

  def generate!
    licitation_process.destroy_all_licitation_process_classifications

    licitation_process_bidders.each do |bidder|
      send(type_of_calculation, bidder)
    end

    check_if_winner_has_zero!

    disable_bidders_by_documentation_problem!

    disable_bidders_by_maximum_value!

    generate_situation!
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

  def disable_bidders_by_documentation_problem!
    return unless disqualify_by_documentation_problem

    licitation_process_bidders.each do |bidder|
      if !bidder.filled_documents? || bidder.expired_documents?
        if (consider_law_of_proposals && !bidder.benefited) || !consider_law_of_proposals
          bidder.disable!
          bidder.save!
        end
      else
        unless bidder.benefited
          bidder.enable!
          bidder.save!
        end
      end
    end
  end

  def disable_bidders_by_maximum_value!
    return unless disqualify_by_maximum_value

    licitation_process_bidders.each do |bidder|
      bidder.disable! if bidder.has_proposals_unit_price_greater_than_budget_allocation_unit_price
    end
  end

  def generate_situation!
    all_licitation_process_classifications.each { |c| c.lost! if c.disqualified? }

    classifications = all_licitation_process_classifications.reject(&:disqualified?).sort_by(&:classification)
    first = classifications.first

    if classifications.size == 1
      first.won!
      first.save!
    end

    classifications.reject { |c| c == first }.each do |classification|
      total_value = classification.benefited_value(current_percentage)

      if total_value == first.total_value
        first.equalized!

        classification.equalized!
      elsif total_value < first.total_value
        first.lost!
        first.save!

        classification.won!
        classification.save!

        first = classification
      else
        first.won!
        classification.lost!
      end

      first.save!
      classification.save!
    end
  end

  def current_percentage
    administrative_process_presence_trading? ? PRESENCE_TRADING_PERCENTAGE : NORMAL_PERCENTAGE
  end

  def lowest_total_price_by_item(bidder)
    bidder.proposals.each do |proposal|
      licitation_process_classification_repository.create!(
        :unit_value => proposal.unit_price,
        :total_value => proposal.unit_price * proposal.quantity,
        :classification => bidder.classification_by_item(proposal),
        :licitation_process_bidder => bidder,
        :classifiable => proposal.administrative_process_budget_allocation_item
      )
    end
  end

  def lowest_global_price(bidder)
    licitation_process_classification_repository.create!(
      :total_value => bidder.total_price,
      :classification => bidder.global_classification,
      :licitation_process_bidder => bidder,
      :classifiable => bidder
    )
  end

  def lowest_price_by_lot(bidder)
    lots_with_items.each do |lot|
      licitation_process_classification_repository.create!(
        :total_value => bidder.proposal_total_value_by_lot(lot),
        :classification => bidder.classification_by_lot(lot),
        :licitation_process_bidder => bidder,
        :classifiable => lot
      )
    end
  end
end
