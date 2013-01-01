class LicitationProcessClassificationBiddersVerifier
  attr_accessor :licitation_process

  delegate :bidders, :disqualify_by_documentation_problem, :disqualify_by_maximum_value,
           :to => :licitation_process, :allow_nil => true

  def initialize(licitation_process)
    self.licitation_process = licitation_process
  end

  def verify!
    bidders.each do |bidder|
      disable_bidder_by_documentation_problem(bidder)
      disable_bidder_by_maximum_value(bidder) if validate_bidder_by_maximum_value?(bidder)
    end
  end

  private

  def validate_bidder_by_maximum_value?(bidder)
    bidder.status.nil? || bidder.active?
  end

  def disable_bidder_by_documentation_problem(bidder)
    if disqualify_by_documentation_problem && bidder.has_documentation_problem?
      bidder.inactivate! unless bidder.benefited_by_law_of_proposals?
    else
      bidder.activate!
    end
  end

  def disable_bidder_by_maximum_value(bidder)
    return unless disqualify_by_maximum_value

    if bidder.has_proposals_unit_price_greater_than_budget_allocation_item_unit_price?
      bidder.inactivate!
    end
  end
end
