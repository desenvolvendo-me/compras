class LicitationProcessClassificationBiddersVerifier
  attr_accessor :licitation_process

  delegate :bidders, :disqualify_by_documentation_problem, :disqualify_by_maximum_value,
           :to => :licitation_process, :allow_nil => true

  def initialize(licitation_process)
    self.licitation_process = licitation_process
  end

  def verify!
    disable_bidders_by_documentation_problem!

    disable_bidders_by_maximum_value!
  end

  protected

  def disable_bidders_by_documentation_problem!
    return unless disqualify_by_documentation_problem

    bidders.each do |bidder|
      if has_documentation_problem?(bidder)
        bidder.inactivate! unless bidder.benefited_by_law_of_proposals?
      else
        bidder.activate!
      end
    end
  end

  def disable_bidders_by_maximum_value!
    return unless disqualify_by_maximum_value

    bidders.each do |bidder|
      if bidder.has_proposals_unit_price_greater_than_budget_allocation_item_unit_price?
        bidder.inactivate!
      end
    end
  end

  private

  def has_documentation_problem?(bidder)
    !bidder.filled_documents? || bidder.expired_documents?
  end

end
